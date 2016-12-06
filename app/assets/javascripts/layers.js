// A grouping of markers that can be toggled together.
function Layer( p_name, p_map, p_markers, p_removable, p_visible ) {
  this.name = p_name;  // Name of the layer.
  this.map = p_map;  // Map the layer will appear on
  this.markers = p_markers || [];  // Markers in the layer
  this.removable = p_removable || true;  // Whether or not the layer can be invisible
  this.visible = p_visible || true;  // Initial visibility
  // this.visible = this.visible || !this.removable;

  var _this = this;
  this.markers.forEach( function( marker, index, array ) {
    marker.setMap( _this.map );
  });

  // Adds a marker.
  this.addMarker = function( p_marker ) {
    marker.setMap( this.map );
    p_marker.setVisible( this.visible );  // Add the marker to the map
    this.markers.push( p_marker );
  }

  // Removes a marker.
  this.removeMarker = function( p_marker ) {
    var index = this.markers.indexOf( p_marker );
    if ( index > -1 ) {
      var m = this.markers.splice( index, 1 ).map;  // Remove from layer
      m.map = null;  // Remove from the map
      return m;
    }
  }

  // Toggles whether or not contained markers are visible on map.
  this.setVisible = function( p_visible ) {
    this.visible = p_visible;// || !this.removable;
    this.markers.forEach( function( marker, index, array ) {
      marker.setVisible( _this.visible );
    });
    if ( checkbox ) {
      checkbox.prop("checked", this.visible);
    }
  }

  // Links a checkbox to toggle this layer
  var checkbox;
  this.linkCheckbox = function( p_checkbox ) {
    checkbox = p_checkbox;
    // Update the checkbox to reflect the layer's state
    checkbox.prop("checked", this.visible);
    checkbox.change( function() {
        _this.setVisible( $(this).is(':checked') );
    });
  }
}

// A layer as a group of layers that can be toggled together.
function LayerGroup( p_name, p_layers, p_visible ) {
  this.name = p_name;
  this.visible = p_visible || true;
  this.layers = p_layers || [];

  var _this = this;

  // Adds a layer to the group and sets the visibility to the group's.
  this.addLayer = function( layer ) {
    layer.setVisible( this.visible );
    this.layers.push( layer );
  }

  // Removes a layer from the group
  this.removeLayer = function( layer ) {
    var index = this.layers.indexOf( layer );
    if ( index > -1 ) {
      return this.layers.splice( index, 1 );
    }
  }
  
  // Toggles whether or not contained markers are visible on map.
  this.setVisible = function( p_visible ) {
    this.visible = p_visible;
    this.layers.forEach( function( layer, index, array ) {
      layer.setVisible( _this.visible );
    });
    if ( checkbox ) { // Update the linked checkbox to relfect change if linked
      checkbox.prop("checked", this.visible);
    }
  }

  // Links a checkbox to toggle this layer
  var checkbox;
  this.linkCheckbox = function( p_checkbox ) {
    checkbox = p_checkbox;
    // Update the checkbox to reflect the layer's state
    checkbox.prop("checked", true);
    checkbox.change( function() {
        _this.setVisible( $(this).is(':checked') );
    });
  }
}
