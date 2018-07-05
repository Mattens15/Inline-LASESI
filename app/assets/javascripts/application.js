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
//= require_tree
//= require jquery
//= require jquery-ujs
//= require recurring_select
//= require flatpickr
//= require bootstrap
//= require mapbox-gl
 


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
    if(rooms_json[i].private) continue;
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
          "id": rooms_json[i].hash_id,
          "title": rooms_json[i].name,
          "address": rooms_json[i].address,
          "owner": rooms_json[i].user_id,
          "description": rooms_json[i].description,
          "visible": true,
          "avatar": rooms_json[i].avatar
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

//TOGLIE LA BARRA ALLA FINE DELL'URL
function getRightUrl(){
  var protocol = window.location.protocol;
  var hostname = window.location.hostname;
  var port     = window.location.port;
  if(window.location.pathname != undefined){
    var pathname = window.location.pathname
    if (pathname.substr(-1) == '/'){
      pathname = pathname.slice(0,-1);
    }
    return protocol+'//'+hostname+':'+port+pathname;
  }
  return protocol+'//'+hostname+':'+port;
}
