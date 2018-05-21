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


function render_map(){
	var point_rooms;
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
  	if (this.readyState == 4 && this.status == 200) {
  		var point_rooms = JSON.parse(this.responseText);
			var array = []
			for(var i = 0; i < point_rooms.length; i++){
				coord = [point_rooms[i].longitude, point_rooms[i].latitude];
				array[i] = {
					"type": "Feature",
					"geometry": 
						{
							"type": "Point",
							"coordinates": coord
						}, 
					"properties": 
						{
							"title": point_rooms[i].name,
							"marker-color": "#7e7e7e",
        			"marker-size": "medium",
						}
					};
				console.log('Long: '+point_rooms[i].longitude);
				console.log('Lat: '+point_rooms[i].latitude);
			}
			
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
			

			map.on('load', function () {
		    map.addLayer({
		        "id": "points",
		        "type": "symbol",
		        "source": {
		            "type": "geojson",
		            "data": {
		                "type": "FeatureCollection",
		                "features": array
		            }
		        },
		        "layout": {
		            "icon-image": "{marker-symbol}-15",
		            "text-field": "{title}",
		            "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
		            "text-offset": [0, 0.6],
		            "text-anchor": "top"
		        }
		    });
			});
		}
	};
	xmlhttp.open("GET", "/rooms.json", true);
	xmlhttp.send(); 

	
}

