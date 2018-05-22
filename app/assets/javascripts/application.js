// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require_tree .

// This will let you use the .remove() function later on
if (!('remove' in Element.prototype)) {
  Element.prototype.remove = function() {
    if (this.parentNode) {
      this.parentNode.removeChild(this);
    }
  };
}


function render_map(){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
  		var rooms_json = JSON.parse(this.responseText);
      mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
      var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v9',
        center: [12.48197078704834,41.893460648167355],
        zoom: 15
      });
      
      map.addControl(new MapboxGeocoder({
        accessToken: mapboxgl.accessToken
      }));
      
      map.addControl(new mapboxgl.NavigationControl());
      map.addControl(new mapboxgl.GeolocateControl({
        positionOptions: {
            enableHighAccuracy: true
        },
        trackUserLocation: true
      }));
      
      map.on('click', 'symbols', function (e) {
        map.flyTo({center: e.features[0].geometry.coordinates});
      });
      
      var array_obj = []
      for(var i = 0; i < rooms_json.length; i++){
        var coord = [rooms_json[i].longitude, rooms_json[i].latitude];
        array_obj[i] = {
          "type": "Feature",
          "geometry": 
            {
              "type": "Point",
              "coordinates": coord
            }, 
          "properties": 
            {
              "title": rooms_json[i].name,
              "address": rooms_json[i].address,
              "owner": rooms_json[i].user_id,
              "description": rooms_json[i].description
            }
          };
      }
      
      var stores = {
        "type": "FeatureCollection",
        "features": array_obj
      }
      
      function createPopUp(currentFeature) {
        var popUps = document.getElementsByClassName('mapboxgl-popup');
        // Check if there is already a popup on the map and if so, remove it
        if (popUps[0]) popUps[0].remove();
        
        var popup = new mapboxgl.Popup({ closeOnClick: true })
          .setLngLat(currentFeature.geometry.coordinates)
          .setHTML('<h3>'+currentFeature.properties.title+'</h3>' +
            '<h4>' + currentFeature.properties.address + '</h4>'+ 
            '<p>'+currentFeature.properties.description+'</p>')
          .addTo(map);
      }

      function buildLocationList(data) {
      // Iterate through the list of stores
        for (i = 0; i < data.features.length; i++) {
          var currentFeature = data.features[i];
          // Shorten data.feature.properties to just `prop` so we're not
          // writing this long form over and over again.
          var prop = currentFeature.properties;
          // Select the listing container in the HTML and append a div
          // with the class 'item' for each store
          var listings = document.getElementById('listings');
          var listing = listings.appendChild(document.createElement('div'));
          listing.className = 'item';
          listing.id = 'listing-' + i;
      
          // Create a new link with the class 'title' for each store
          // and fill it with the store address
          var link = listing.appendChild(document.createElement('h4'))
          link.className = 'title';
          link.dataPosition = i;
          link.innerHTML = prop.title;
      
          // Create a new div with the class 'details' for each store
          // and fill it with the city and phone number
          var details = listing.appendChild(document.createElement('div'));
          details.innerHTML = "Address: "+prop.address;
          if (prop.phone) {
            details.innerHTML += ' &middot; ' + prop.phoneFormatted;
          }
          // Add an event listener for the links in the sidebar listing
            
          link.addEventListener('click', function(e) {
            // Update the currentFeature to the store associated with the clicked link
            var clickedListing = data.features[this.dataPosition];
            // 1. Fly to the point associated with the clicked link
            flyToStore(clickedListing);
            // 2. Close all other popups and display popup for clicked store
            createPopUp(clickedListing);
            // 3. Highlight listing in sidebar (and remove highlight for all other listings)
            var activeItem = document.getElementsByClassName('active');
            if (activeItem[0]) {
              activeItem[0].classList.remove('active');
            }
            this.parentNode.classList.add('active');
          });
        }
      }
      
      function flyToStore(currentFeature) {
        map.flyTo({
          center: currentFeature.geometry.coordinates,
          zoom: 15
        });
      }
      
      map.on('load', function () {
        map.loadImage("https://i.imgur.com/MK4NUzI.png", function(error, image) {
          if (error) throw error;
          map.addImage("custom-marker", image);
          map.addLayer({
            "id": 'locations',
            "type": "symbol",
            "source": {
                "type": "geojson",
                "data": stores
            },
            "layout": {
                "icon-image": "custom-marker",
                "icon-allow-overlap": true,
                "icon-size": 0.5,
                "text-field": "{title}",
                "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
                "text-offset": [0, 0.5],
                "text-anchor": "top"
            }
          });
          buildLocationList(stores);
          
        });
      });
      
      map.on('click', function(e) {
      // Query all the rendered points in the view
        var features = map.queryRenderedFeatures(e.point, { layers: ['locations'] });
        if (features.length) {
          var clickedPoint = features[0];
          // 1. Fly to the point
          flyToStore(clickedPoint);
          // 2. Close all other popups and display popup for clicked store
          createPopUp(clickedPoint);
          // 3. Highlight listing in sidebar (and remove highlight for all other listings)
          var activeItem = document.getElementsByClassName('active');
          if (activeItem[0]) {
            activeItem[0].classList.remove('active');
          }
          // Find the index of the store.features that corresponds to the clickedPoint that fired the event listener
          var selectedFeature = clickedPoint.properties.address;
      
          for (var i = 0; i < stores.features.length; i++) {
            if (stores.features[i].properties.address === selectedFeature) {
              selectedFeatureIndex = i;
            }
          }
          // Select the correct list item using the found index and add the active class
          var listing = document.getElementById('listing-' + selectedFeatureIndex);
          listing.classList.add('active');
        }
      });
    }
  };
  xmlhttp.open("GET", '/rooms.json', true);
	xmlhttp.send();
}
