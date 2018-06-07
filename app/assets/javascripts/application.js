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
//= require jquery
//= require jquery-ujs
//= require flatpickr
//= require activestorage
//= require bootstrap
//= require turbolinks
//= require bootstrap
//= require mapbox-gl
//= require_tree 


//FUNZIONA USATA PER RENDERIZZARE MAPPA IN ROOM#SHOW
function render_map_for_room_show(path_JSON){
  var rooms_json = init(path_JSON);
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  
  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [rooms_json.longitude, rooms_json.latitude],
    zoom: 12,
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

//FUNZIONE USATA PER RENDERIZZARE MAPPA IN ROOM#NEW
function render_map_for_room(){
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [12.48197078704834,41.893460648167355],
    zoom: 15,
    attributionControl: false,
    hash:true
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

//FUNZIONE USATA PER RENDERIZZARE LA MAPPA IN DASHBOARD
function render_map(stores){
  
  //AUTORIZE AND CREATE THE MAP
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    center: [12.48197078704834,41.893460648167355],
    zoom: 15,
    attributionControl: false,
    hash: true
  });
  
  var complete_stores = buildObjectForMap('/rooms.json', 1);
  //SPOSTO LE INFO DI MAPBOX IN ALTO A DESTRA
  map.addControl(new mapboxgl.AttributionControl(), 'top-left');
  
  //METODI ASINCRONI PER LA MAPPA
  map.on('load', function (e) {
      
      //AGGIUNGO SORGENTE CON TUTTE LE ROOM
      map.addSource("places", {
        "type": "geojson",
        "data": stores
      });
      
      //COSTRUISCO I DIV
      buildLocationList(complete_stores, false);
      
      //AGGIUNGO SORGENTE SENZA PUNTI
      map.addSource('single-point', {
        'type': 'geojson',
        'data': {
          'type': 'FeatureCollection',
          'features': []
        }
      });
      
      //AGGIUNGO STRATO CHE PRENDE SINGLEPOINT COME SORGENTE
      //SERVIRÀ AD AGGIUNGERE UN CERCHIO ALLA LOCALITÀ PUNTATA
      map.addLayer({
        "id": 'center',
        "type": "circle",
        "source": 'single-point',
        'paint': {
          'circle-radius': 7,
          'circle-color': '#33ccff'
        }
      });
      
      //AGGIUNGO STRATO CHE PRENDE PLACES COME SORGENTE
      //SERVIRÀ A RENDERIZZARE TUTTI LE ROOM SULLA MAPPA
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
      
      //AGGIUNGO GEOCODER E GEOLOCATOR
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
      
      //QUANDO CLICCO SU UN MARKER LO CENTRA
      map.on('click', 'locations', function(e) {
        var feature = e.features[0];
        flyToStore(feature);
      });
      
      //QUANDO IL MOUSE ENTRA IN UNA LOCATION CAMBIA
      map.on('mouseenter', 'locations', function () {
        map.getCanvas().style.cursor = 'pointer';
      });
      
      //QUANDO IL MOUSE ESCE DA UNA LOCATION TORNA NORMALE
      map.on('mouseleave', 'locations', function () {
        map.getCanvas().style.cursor = '';
      });
   
      //QUANDO IL GEOCODER È VUOTO
      geocoder.on('clear', function(){
        buildLocationList(complete_stores, false);  
      });
      
      //QUANDO GEOLOCALIZZO DEFINISCO LA DISTANZA TRA LA LOCALITÀ CERCATA E LE ROOM
      //LE ORDINO E SCARTO QUELLE FUORI DAL RAGGIO DI RICERCA
      geolocate.on('geolocate', function(ev){
        var searchResult = ev.coords;
        
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
      
      
        buildLocationList(stores, true);
        //FUNZIONE COPIATA E INCOLLATA DALLA DOCUMENTAZIONE DI MAPBOX
        //SERVE A ORDINARE PER DISTANZA  
        
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
      
      geolocate.on('trackuserlocationend', function(){
        buildLocationList(complete_stores, false);
      });
      
      //COME SOPRA, SOLO CHE CON LA GEOLOCALIZZAZIONE
      geocoder.on('result', function(ev) {
        var searchResult = ev.result.geometry;

        map.getSource('single-point').setData(searchResult);
        var options = {units: 'kilometers'};
        complete_stores.features.forEach(function(store){
          if(store.geometry.coordinates[0] == 0 && store.geometry.coordinates[1] == 0){
            return;
          }
          
          Object.defineProperty(store.properties, 'distance', {
            
            value: turf.distance(searchResult.coordinates, store.geometry, options),
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
  
        buildLocationList(complete_stores, true);
        
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
  
      $('#searchbyname_form').keyup(function(){
        updateByParam()
      });
        
    
    //COSTRUISCO ELEMENTI HTML PER OGNI ROOM
    
    
    function buildMarker(stores){
      stores.features.forEach(function(marker, i) {
        if(stores.features[i].properties.visible){
          // Create an img element for the marker
          var el = document.createElement('div');
          el.id = "marker-" + i;
          el.className = 'marker';
					//DECOMMENTA LA LINEA SOTTO SE SEI SOTTO TEST
          //el.innerHTML = 'I\' here for testing!';
          // Add markers to the map at all points
          new mapboxgl.Marker(el, {offset: [0, 0]})
              .setLngLat(marker.geometry.coordinates)
              .addTo(map);
        }
        
      });
    }
    
    buildMarker(stores);
    //USATA PER DISEGNARE UN CERCHIO DI RAGGIO (VALUE OF FORM RADIUS)
    //DA OTTIMIZZARE SICURAMENTE VISTO CHE RIMUOVE LAYER E LO RICREA
    //INVECE DI CAMBIARE I DATI
    function drawCircle(data, r){
      if(map.getLayer('circle')) map.removeLayer('circle');
      if(map.getSource('circle-point')) map.removeSource('circle-point');
      if(radius < 0.1) return;
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
    
  });
}

//COSTRUISCE I DIV PER LE ROOM
function buildLocationList(data,query) {
  var header = document.getElementById('num_rooms');
  header.innerHTML = '';
  var toremove = document.getElementById('listings');
  while(toremove != null && toremove.hasChildNodes()){
    toremove.removeChild(toremove.childNodes[0]);
  }
  var j = 0;
  var count = 0;
  
  if(document.getElementById('radius').value < 0.1 && query){
    var listings = document.getElementById('listings');
    var alert = listings.appendChild(document.createElement('div'));
    alert.className = 'alert alert-danger text-center';
    alert.innerHTML = 'Il raggio deve essere un numero reale maggiore o uguale a 0.1';
    return;
  }
  
  for (i = 0; i < data.features.length; i++) {
    if(i != 0 && i % 4 == 0){
      j++;
    }
    var currentFeature = data.features[i];
    var prop = currentFeature.properties;
    if(query && (currentFeature.geometry.coordinates[0] == 0 || currentFeature.geometry.coordinates[1] == 0)) continue;
    if(query && (prop.distance < 0 || prop.distance > document.getElementById('radius').value || !prop.visible)) {
      continue;
    }
    count++;
    var listings = document.getElementById('listings');
    var card_deck;
    
    if(!listings.hasChildNodes()){
      var child = listings.appendChild(document.createElement('div'));
      child.className = 'row my-2 divCard';
      child.id = 'deck-'+j;
    }
    
    if(listings.children.length - 1 < j){
      var added = listings.appendChild(document.createElement('div'));
      added.className = 'row my-2 divCard';
      added.id = 'deck-'+j
    }
  
    card_deck = listings.children[j];
      
    var card = card_deck.appendChild(document.createElement('div'));
    card.className = 'card mx-2';
    
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
    
    if (prop.distance && query) {
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
  if(query){
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
}

//USATA NELLE FUNZIONI JQUERY
//SERVE PER SELEZIONARE LE ROOM TRAMITE ESPRESSIONE REGOLARE
function updateByParam(){
  var data = buildObjectForMap('/dashboard.json', 1);
  if($('#searchbyname_form').val() != ""){
    for(var i=0; i < data.features.length; i++){
      var contained = document.getElementById('searchbyname_form').value
      var regex = new RegExp('(.*)'+contained+'(.*)', 'i');
      data.features[i].properties.visible = regex.test(data.features[i].properties.title);
    }
  
  }
  else{
    for(var i=0; i<data.features.length; i++){
      data.features[i].properties.visible = true;
    }
  }
  
  buildLocationList(data,false);
}

function retriveCoords(mode){
  var coords;
  if(mode > 0){
    coords = [0, 0];
  } 
  else{
    coords = [null, null];
  }
  
  return coords;
}
//USATA PER COSTRUIRE UN OGGETTO GEOJSON PER LA MAPPA
//PATH = PATH DEL JSON
//MODE = 1 / 0
//0 SCARTA TUTTE LE ROOM CHE NON HANNO LOCATION
//1 PRENDE TUTTE LE LOCATION
function buildObjectForMap(path, mode){
  var rooms_json = init(path);
  var array_obj = []
  var length = rooms_json.length;
  for(var i = 0; i < length; i++){
    var coord;
    if(rooms_json[i].longitude == null|| rooms_json[i].latitude == null){
      coord = retriveCoords(mode);
      if(coord[1] == null || coord[0] == null) continue;
    }
    else{
      coord = [rooms_json[i].longitude, rooms_json[i].latitude];
    }
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
          "description": rooms_json[i].description,
          "visible": true
        }
    };
    
  }
  
  array_obj = array_obj.filter(function(n){ return n != undefined});
  
  
  var stores = {
    "type": "FeatureCollection",
    "features": array_obj
  }
  return stores;
}

//FUNZIONE MAI USATA DIRETTAMENTE
//CHIAMATA IN BUILDOBJECTFORMAP
function init(path_JSON){
  var json = function () {
    var jsonTemp = null;
    $.ajax({
        'async': false,
        'url': path_JSON,
        'success': function (data) {
            jsonTemp = data;
        }
    });
    return jsonTemp;
  }();
  return json;
};

//CENTRA E ZOMMA SU CURRENT FEATURE
function flyToStore(currentFeature) {
  if(currentFeature.geometry.coordinates[0] == 0 && currentFeature.geometry.coordinates[1] == 0)
  {
    alert(currentFeature.properties.title+' non ha una location!');
  }
  
  else{
    map.flyTo({
      center: currentFeature.geometry.coordinates,
      zoom: 16
    });
  }
}

//TOGLIE LA BARRA ALLA FINE DELL'URL
function getRightUrl(){
  var url = document.URL;
  if (url.substr(-1) == '/'){
    url = url.slice(0,-1);
  }
  return url;
}
