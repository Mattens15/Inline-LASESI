//ROOM#SHOW
function render_map_for_room_show(path_JSON){
  var rooms_json = init(path_JSON);
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  
  var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [rooms_json.longitude, rooms_json.latitude],
    zoom: 15,
    attributionControl: false,
    interactive: false
  });
  
  var coord = [rooms_json.longitude, rooms_json.latitude];
  var array_obj = [{
    "type": "Feature",
    "geometry": 
      {
        "type": "Point",
        "coordinates": coord
      }, 
    "properties": 
      {
        "id": rooms_json.id,
        "title": rooms_json.name,
        "address": rooms_json.address,
        "owner": rooms_json.user_id,
        "description": rooms_json.description
      }
  }];

  
  var stores = {
    "type": "FeatureCollection",
    "features": array_obj
  }
  
  map.on('load', function(e){
    map.addSource('place', {
      'type': 'geojson',
      'data': stores
    });
    
    map.addLayer({
      'id': 'places',
      'type': 'symbol',
      'source': 'place',
      'layout': {
          'icon-image': 'marker-15',
          'text-field': '{title}',
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        }
    });
    
    function buildMarker(stores){
      stores.features.forEach(function(marker, i) {
				var el = document.createElement('div');
				el.id = "marker-0";
				el.className = 'marker';
        //DECOMMENTA LA LINEA SOTTO SE SEI SOTTO TEST
				//el.innerHTML = 'I\' here for testing!';
				// Add markers to the map at all points
				new mapboxgl.Marker(el, {offset: [0, 0]})
						.setLngLat(marker.geometry.coordinates)
						.addTo(map);	
      });
    }
    buildMarker(stores);
  });
}

//ROOM#NEW
function render_map_for_room(){
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [12.48197078704834,41.893460648167355],
    zoom: 15,
    attributionControl: false,
    //DECOMMENTA SE SEI IN FASE DI TEST
    //hash:true
  });
  
  map.on('load', function(e) {
    map.addSource('single-point', {
      "type": "geojson",
      "data": {
          "type": "FeatureCollection",
          "features": []
      }
    });
    
    map.addLayer({
      "id": 'location',
      "type": "symbol",
      "source": 'single-point',
      "layout": {
        "icon-image": "marker-15",
        "text-offset": [0, 0.6],
        "text-anchor": "top"
      }
    });
    
    geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
    });
		
    document.getElementById('geocoder').appendChild(geocoder.onAdd(map));
    
    geocoder.on('result', function(ev){
      var searchResult = ev.result.geometry;
      map.getSource('single-point').setData(ev.result.geometry);
      
      var lats_html = document.getElementById('lats_input');
      var lons_html = document.getElementById('lons_input');
      var addr_html = document.getElementById('addr_input');
      
      lats_html.value = searchResult.coordinates[1];
      lons_html.value = searchResult.coordinates[0];
      addr_html.value = ev.result.place_name;
    });
  });  
}
