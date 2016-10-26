function Layer( name, markers, map, removable ) {
  this.name = name;
  this.markers = markers;
  this.removable = removable
  var map = map;
  this.setMap = function( map ) {
    this.markers.forEach( function( marker, index, array ) {
      marker.map = map;
    });
  }
}

function LayerGroup( name, layers ) {
  this.name = name;
  this.layers = layers;
  this.addLayer= function( layer ) {
    this.layers.push( layer );
  }
  this.setMap = function( map ) {
    this.layers.forEach( function( layer, index, array ) {
      layer.setMap( map )
    }
  }
}
