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

/*
function render_map_for_room(){
  var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [12.48197078704834,41.893460648167355],
    zoom: 15,
    attributionControl: false
  });
  var stores = {
    "type": "FeatureCollection",
    "features": []
  }
  
  map.on('load', function(e) {
    map.addSource('single-point', {
      'type': 'geojson'
      'data': stoes
    });
  });
  
  map.addLayer({
    "id": 'locations',
    "type": "cirlce",
    "source": 'single-point',
    "layout": {
      "icon-image": "marker-15",
      "text-field": "{title}",
      "text-offset": [0, 0.6],
      "text-anchor": "top"
    }
  });
  
  geocoder = new MapboxGeocoder({
    accessToken: mapboxgl.accessToken
  });
  
  geolocate = new mapboxgl.GeolocateControl({
    positionOptions: {
      enableHighAccuracy: true
    },
    trackUserLocation: true
  });
  
  document.getElementById('geocoder').appendChild(geocoder.onAdd(map));
  document.getElementById('geolocate').appendChild(geolocate.onAdd(map));
  
  geolocate.on('geolocate', function(ev){
    console.log(ev);
    var searchResult = ev.coords;
    map.getSource('single-point').setData(searchResult);
    
    var lats_html = document.getElementById('lats_input');
    var lons_html = document.getElementById('lons_input');
    var addr_html = document.getElementById('addr_input');
  });
  
  geodecoder.on('result', function(ev){
    console.log(ev);
  });
}
*/
function render_map(){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      var toremove = document.getElementById('listings');
      while(toremove != null && toremove.hasChildNodes()){
        toremove.removeChild(toremove.childNodes[0]);
      }
      
  		var rooms_json = JSON.parse(this.responseText);
      mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
      var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v8',
        center: [12.48197078704834,41.893460648167355],
        zoom: 15,
        attributionControl: false
      });
      
      map.addControl(new mapboxgl.AttributionControl(), 'top-left');
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
              "id": rooms_json[i].id,
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
      
      map.on('load', function (e) {
          
          map.addSource("places", {
            "type": "geojson",
            "data": stores
          });
          
          buildLocationList(stores);
          
          map.addSource('single-point', {
            'type': 'geojson',
            'data': {
              'type': 'FeatureCollection',
              'features': []
            }
          });
          
          map.addLayer({
            "id": 'locations',
            "type": "symbol",
            "source": 'places',
            "layout": {
              "icon-image": "marker-15",
              "text-field": "{title}",
              "text-offset": [0, 0.6],
              "text-anchor": "top"
            }
          });
          
          geocoder = new MapboxGeocoder({
              accessToken: mapboxgl.accessToken
          });
          
          geolocate = new mapboxgl.GeolocateControl({
            positionOptions: {
              enableHighAccuracy: true
            },
            trackUserLocation: true
          });
          
          document.getElementById('geocoder').appendChild(geocoder.onAdd(map));
          document.getElementById('geolocate').appendChild(geolocate.onAdd(map));
         
          geolocate.on('geolocate', function(ev){
            var searchResult = ev.coords;
            map.getSource('single-point').setData(searchResult);
            
            var options = {units: 'kilometers'};
            stores.features.forEach(function(store){
              var actual_coord = [searchResult.longitude, searchResult.latitude];
              Object.defineProperty(store.properties, 'distance', {      
                value: turf.distance(actual_coord, store.geometry, options),
                writable: true,
                enumerable: true,
                configurable: true
              });
            });
            
            drawCircle([searchResult.longitude, searchResult.latitude], document.getElementById('radius').value)
            stores.features.sort(function(a,b){
              if (a.properties.distance > b.properties.distance) {
                return 1;
              }
              if (a.properties.distance < b.properties.distance) {
                return -1;
              }
              // a must be equal to b
              return 0;
            });
            
            var listings = document.getElementById('listings');
            while (listings.firstChild) {
              listings.removeChild(listings.firstChild);
            }
      
            buildLocationList(stores);
      
            function sortLonLat(storeIdentifier) {
              var result_lats = searchResult.latitude;
              var result_lons = searchResult.longitude;
              var lats = [stores.features[storeIdentifier].geometry.coordinates[1], result_lats]
              var lons = [stores.features[storeIdentifier].geometry.coordinates[0], result_lons]
      
              var sortedLons = lons.sort(function(a,b){
                  if (a > b) { return 1; }
                  if (a.distance < b.distance) { return -1; }
                  return 0;
                });
              var sortedLats = lats.sort(function(a,b){
                  if (a > b) { return 1; }
                  if (a.distance < b.distance) { return -1; }
                  return 0;
                });

            };
      
            sortLonLat(0);
          });
          
          geocoder.on('result', function(ev) {
            var searchResult = ev.result.geometry;
            map.getSource('single-point').setData(searchResult);
            var options = {units: 'kilometers'};
            stores.features.forEach(function(store){
              Object.defineProperty(store.properties, 'distance', {
                value: turf.distance(searchResult, store.geometry, options),
                writable: true,
                enumerable: true,
                configurable: true
              });
            });
          
            stores.features.sort(function(a,b){
              if (a.properties.distance > b.properties.distance) {
                return 1;
              }
              if (a.properties.distance < b.properties.distance) {
                return -1;
              }
              // a must be equal to b
              return 0;
            });
            
            drawCircle(searchResult.coordinates, document.getElementById('radius').value);
            var listings = document.getElementById('listings');
            while (listings.firstChild) {
              listings.removeChild(listings.firstChild);
            }
      
            buildLocationList(stores);
            
            function sortLonLat(storeIdentifier) {
              var lats = [stores.features[storeIdentifier].geometry.coordinates[1], searchResult.coordinates[1]]
              var lons = [stores.features[storeIdentifier].geometry.coordinates[0], searchResult.coordinates[0]]
      
              var sortedLons = lons.sort(function(a,b){
                  if (a > b) { return 1; }
                  if (a.distance < b.distance) { return -1; }
                  return 0;
                });
              var sortedLats = lats.sort(function(a,b){
                  if (a > b) { return 1; }
                  if (a.distance < b.distance) { return -1; }
                  return 0;
                });
            };
            
            sortLonLat(0);
      
          });
      
        // This is where your interactions with the symbol layer used to be
        // Now you have interactions with DOM markers instead

        stores.features.forEach(function(marker, i) {
          // Create an img element for the marker
          var el = document.createElement('div');
          el.id = "marker-" + i;
          el.className = 'marker';
          // Add markers to the map at all points
          new mapboxgl.Marker(el, {offset: [0, -23]})
              .setLngLat(marker.geometry.coordinates)
              .addTo(map);
          el.addEventListener('click', function(e){
              // 1. Fly to the point
              flyToStore(marker);

              // 3. Highlight listing in sidebar (and remove highlight for all other listings)
              var activeItem = document.getElementsByClassName('active');
      
              e.stopPropagation();
              if (activeItem[0]) {
                 activeItem[0].classList.remove('active');
              }
      
              var listing = document.getElementById('listing-' + i);
              listing.classList.add('active');
      
          });
        });
        
        function flyToStore(currentFeature) {
          map.flyTo({
              center: currentFeature.geometry.coordinates,
              zoom: 16
            });
        }
        
        function drawCircle(data, r){
          if(map.getLayer('circle')) map.removeLayer('circle');
          if(map.getSource('circle-point')) map.removeSource('circle-point');
          
          var radius = r;
          var options = {steps: 64, units: 'kilometers'};
          var circle = turf.circle(data, radius, options);
          map.addSource('circle-point',{
            'type': 'geojson',
            'data': circle
          });
          
          map.addLayer({
            "id": 'circle',
            "type": 'fill',
            "source": 'circle-point',
            "layout": {  
            },
            "paint":{
              'fill-color': '#33ccff',
              'fill-opacity': 0.2
            }
          });
        }
      
        function buildLocationList(data) {
          var j = 0;
          var count = 0;
          for (i = 0; i < data.features.length; i++) {
            if(i != 0 && i % 4 == 0){
              j++;
            }
            var currentFeature = data.features[i];
            var prop = currentFeature.properties;

            if(prop.distance < 0 || prop.distance > document.getElementById('radius').value) continue;
            count++;
            var listings = document.getElementById('listings');
            var card_deck;
            
            if(!listings.hasChildNodes()){
              var child = listings.appendChild(document.createElement('div'));
              child.className = 'card-deck';
              child.id = 'deck-'+i;
            }
            
            card_deck = listings.children[j];
              
            var card = card_deck.appendChild(document.createElement('div'));
            card.className = 'card';
            
            var card_body = card.appendChild(document.createElement('div'));
            card_body.className = 'card-body';
            
            var link = card_body.appendChild(document.createElement('h4'));
            link.className = 'card-title';
            link.dataPosition = i;
            link.innerHTML = prop.title;
      
            var details = card_body.appendChild(document.createElement('p'));
            details.className = 'card-text';
            details.innerHTML = prop.address;
            if (prop.description){
              details.innerHTML += '<br><small>'+prop.description+'</small>';
            }
            if (prop.phone) {
              details.innerHTML += ' &middot; ' + prop.phoneFormatted;
            }
            
            if (prop.distance) {
              var roundedDistance = Math.round(prop.distance*100)/100;
              details.innerHTML += '<p><strong>' + roundedDistance + ' kilometers away</strong></p>';
            }
      
            var link_to= card_body.appendChild(document.createElement('a'));
            link_to.href = '/rooms/'+prop.id;
            link_to.className = 'card-link';
            link_to.innerHTML = 'Visita la room';
            
            link.addEventListener('click', function(e){
              // Update the currentFeature to the store associated with the clicked link
              var clickedListing = data.features[this.dataPosition];
      
              // 1. Fly to the point
              flyToStore(clickedListing);
              
              // 3. Highlight listing in sidebar (and remove highlight for all other listings)
              var activeItem = document.getElementsByClassName('active');
      
              if (activeItem[0]) {
                 activeItem[0].classList.remove('active');
              }
              this.parentNode.classList.add('active');
          
            });
          }
          
          var header = document.getElementById('num_rooms');
          var suffix;
          var prefix;
          if(count == 1){
            suffix = ' stanza';
            prefix = 'E\' stata trovata ';
          }
          else {
            suffix = ' stanze';
            prefix = 'Sono state trovate ';
          }
          
          header.innerHTML = prefix+count+suffix+' nel raggio di '+document.getElementById('radius').value+' km.';
        }
        
      });
      
    }
  };
  xmlhttp.open("GET", '/rooms.json', true);
  xmlhttp.send(); 
}
