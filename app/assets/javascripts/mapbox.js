//RENDERIZZA MAPPA CON TUTTE LE SUE FUNZIONI NELLA HOME PAGE
function render_map(stores){
  //AUTORIZE AND CREATE THE MAP
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A';
  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8?optimize=true',
    center: [12.48197078704834,41.893460648167355],
    zoom: 15,
    attributionControl: false,
  });
  
  var protocol = window.location.protocol;
  var hostname = window.location.hostname;
  var port     = window.location.port;
  var url = protocol+'//'+hostname+':'+port+'/dashboard.json'
  var complete_stores = buildObjectForMap(url, 1);
  
  //COSTRUISCO I DIV
  buildLocationList(complete_stores, false);

  //SPOSTO LE INFO DI MAPBOX IN ALTO A DESTRA
  map.addControl(new mapboxgl.AttributionControl(), 'top-left');
  
  //METODI ASINCRONI PER LA MAPPA
  map.on('load', function (e) {
    //AGGIUNGO SORGENTE CON TUTTE LE ROOM
    map.addSource("places", {
      "type": "geojson",
      "data": stores
    });

      
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
    var geocoder = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken
    });
    
    var geolocate = new mapboxgl.GeolocateControl({
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
        if(store.geometry.coordinates[0] === 0 && store.geometry.coordinates[1] === 0){
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
      updateByParam(complete_stores);
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
          el.innerHTML = 'I\' here for testing!';
          // Add markers to the map at all points
          new mapboxgl.Marker(el, {offset: [0, 0]})
              .setLngLat(marker.geometry.coordinates)
              .addTo(map);
        }
        
      });
    }

    buildMarker(stores);
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

//COSTRUISCE DECK E CARD NELL HOMPAGE
function buildLocationList(data,query) {
  var header = document.getElementById('num_rooms');
  header.innerHTML = '';
  var toremove = document.getElementById('listings');
  while(toremove !== null && toremove.hasChildNodes()){
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

  for (var i = 0; i < data.features.length; i++) {

    if(i !== 0 && i % 4 === 0){
      j++;
    }

    var currentFeature = data.features[i];
    var prop = currentFeature.properties;
    
    if(!prop.visible) continue;
    if(query && (currentFeature.geometry.coordinates[0] === 0 || currentFeature.geometry.coordinates[1] === 0)) continue;
    if(query && (prop.distance < 0 || prop.distance > document.getElementById('radius').value )) continue;
    count++;
    var listings;
    listings = document.getElementById('listings');
    
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
    card.className = 'col-xl-2 col-lg-3 col-md-4 col-sm-6 col-xs-6 col-12 rooms';

    var figure = card.appendChild(document.createElement('figure'));

    var img = figure.appendChild(document.createElement('img'));
    img.src = prop.avatar
    img.className = 'mx-auto'

    var figcaption = figure.appendChild(document.createElement('figcaption'));
    
    var created_by = figcaption.appendChild(document.createElement('h3'));
    var room_host  = prop.room_host
    
    created_by.innerHTML = room_host.length > 1 ? 'Roomhosts: ' : 'Roomhost: '

    
    for(var k = 0; k < room_host.length; k++){
      var span = figcaption.appendChild(document.createElement('span'));
      span.innerHTML = "<span><a href = "+room_host[k].url+">"+room_host[k].username+"</a></span>"
      var br = figcaption.appendChild(document.createElement('br'));
    }

    var card_body = card.appendChild(document.createElement('div'));
    card_body.className = 'card-body';

    var link = card_body.appendChild(document.createElement('h4'));
    link.className = 'card-title';
    link.dataPosition = i;
    link.innerHTML = prop.title;
  
    var details = card_body.appendChild(document.createElement('p'));
    details.className = 'card-text';
    
    if(prop.address){
      details.innerHTML = prop.address;
      
      link.addEventListener('click', function(e){
        // Update the currentFeature to the store associated with the clicked link
        var clickedListing = data.features[this.dataPosition];
        // 1. Fly to the point
        flyToStore(clickedListing);
      });
    }
    else details.innerHTML = 'Room senza location';

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
    
    
  }

  if(query){
    var header = document.getElementById('num_rooms');
    var suffix;
    var prefix;
    if(count === 1){
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
function updateByParam(stores){
  var data = stores
  if($('#searchbyname_form').val() !== ""){
    for(var i=0; i < data.features.length; i++){

      var contained = document.getElementById('searchbyname_form').value
      var regex = new RegExp('(.*)'+contained+'(.*)', 'i');
      console.log('Sto comparando: '+regex+' con '+ data.features[i].properties.title);
      data.features[i].properties.visible = regex.test(data.features[i].properties.title);
      console.log('Result: '+data.features[i].properties.visible);
    }
  
  }
  else{
    var i;
    for(i = 0; i<data.features.length; i++){
      data.features[i].properties.visible = true;
    }
  }
  
  buildLocationList(data, false);
}

//CORREGGE COORDINATE NULLE
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

//CENTRA E ZOMMA SU CURRENT FEATURE
function flyToStore(currentFeature) {
  map.flyTo({
    center: currentFeature.geometry.coordinates,
    zoom: 16,
    curve: 0.7,
    speed: 0.5,
    bearing: 30,
    pitch: 45
  });
}