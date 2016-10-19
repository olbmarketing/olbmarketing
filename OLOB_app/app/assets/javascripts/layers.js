function Layer( name, markers ) {
  this.name = name;
  this.markers = markers;
  this.addMarker = function( marker ) {
    this.markers.push( marker );
  }
  this.setMap = function( map ) {

  }
}

function LayerGroup( name, layers ) {
  this.name = name;
  this.layers = layers || [];
}
