function Layer( name, markers, map ) {
  this.name = name;
  this.markers = markers;
  var map = map || null;
  this.addMarker = function( marker ) {
    marker.map = map;
    this.markers.push( marker );
  }
  this.setMap = function( map ) {
    this.markers.forEach( function( marker, index, array ) {
      marker.map = map;
    });
  }
}

function LayerGroup( name, layers ) {
  this.name = name;
  this.layers = layers || [];
  this.setMap = function( map ) {
    this.layers.forEach( function( layer, index, array ) {
      layer.setMap( map )
    }
  }
}
