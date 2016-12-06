// Generates a sorting function based on any field of an object
var sort_by = function( field, reverse, primer ){
  var key = function ( x ) { return primer ? primer( x[field] ) : x[field] };

  return function ( a, b ) {
	  var A = key( a ), B = key( b );
	  return ( ( A < B ) ? -1 : ( ( A > B ) ? 1 : 0 ) ) * [-1,1][+!!reverse];
  }
}

// Callback for initializing the map once the API is loaded
var map, infowindow; // Global objects
function initialize() {
  var OLBPos = new google.maps.LatLng(40.053930, -83.035042); // OLB's coordinates
  // Create the map model object
  pageMap = new google.maps.Map( document.getElementById( 'map-canvas' ), {
      zoom: 13,
      center: OLBPos,
      streetViewControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  // This infowindow object is reused and re-placed abpve each marker.
  // This conserves memory and speeds things up.
  infowindow = new google.maps.InfoWindow({
    content: null
  });
  beachFlag = {  // Beach flag icon to be used for OLB and parishes
    url: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png',
    size: new google.maps.Size(20, 32),
    origin: new google.maps.Point(0, 0),
    anchor: new google.maps.Point(0, 32)
  };
  // Creates the marker for OLB.
  var marker = new google.maps.Marker( {
    map: pageMap,
    position: OLBPos,
    title: "Our Lady of Bethlehem",
    icon: beachFlag
  });
  // Add the click listener to open the infowindow over this marker.
  marker.addListener( 'click', function() {
    infowindow.setContent( '<div id="content">'+
      '<h4 id="firstHeading" class="firstHeading">Our Lady of Bethlehem</h4>'+
      '</div>' );
    infowindow.open( pageMap, marker );
  });
  initializeLayerModel(); // parse layer data
  fillSidebar(); // add checkboxes for layers
}

// Parses the data from the databse into a layer model with markers.
function initializeLayerModel() {
  layers = []; // array of layer obejcts (Layers of LayerGroups)
  initializeParishLayer();
  initializeStudentLayers();
}

// Parse the parish layer model data
function initializeParishLayer() {
  var parishMarkers = [];
  var parishes = $('.data-parishes').data('parishes');
  parishes.forEach( function ( parish, index, array ) {
    parishMarkers.push( generateParishMarker( parish ) );
  });
  parishLayer = new Layer( "Parishes", pageMap, parishMarkers );
  layers.push( parishLayer );
}

// Creates a marker and info window for a parish object.
function generateParishMarker( parish ) {
  var address = assembleAddress( parish.address, parish.city,
    parish.state, parish.zip );
  var marker = new google.maps.Marker({
        map: pageMap,
        position: new google.maps.LatLng( parish.latitude, parish.longitude ),
        title: parish.name,
        icon: beachFlag
    });
  // Add click listener for opening the infowindow over the marker.
  marker.addListener('click', function() {
    infowindow.setContent('<div id="content">' +
        '<h4 id="firstHeading" class="firstHeading">' +
          parish.name +
        '</h4>' +
        '<div id="bodyContent">' +
          '<p>' + parish.address + '<br/>' +
            parish.city + ', ' +  parish.state + ' ' + parish.zip +
          '</p>' +
        '</div>' +
      '</div>');
    infowindow.open(pageMap, marker);
  });
  return marker;
}

// Parses all student data into layers by class, and puts
// all of them in a group.
function initializeStudentLayers() {
  var group = new LayerGroup( "Students" );
  var students = $('.data-students').data('students');
  // Parse each student class into a layer for the group
  for ( var _class in students ) {
    if ( students.hasOwnProperty( _class ) ) { // Find a class group
      // Parse each student from the class into a marker
      var markers = [];
      students[_class].forEach( function ( student, index, array ) {
        if ( student.longitude && student.latitude ) {
          markers.push( generateStudentMarker( student ) );
        } else {
          console.log( 'Student ' + student.first_name + ' ' +
            student.last_name + 'had no position data.' );
        }
      });
      group.addLayer( new Layer( _class, pageMap, markers, true, true ) )
    }
  }
  // Sort the classes to appear most recent first.
  group.layers.sort( sort_by( "name", false ) );
  layers.push( group ); // Add the group to the list of layers
}

// Generates a marker and info window for a student object.
function generateStudentMarker( student, markers ) {
  var pos = new google.maps.LatLng(student.latitude, student.longitude);
  var marker = new google.maps.Marker({ // create the marker
      title: student.first_name + " " + student.last_name,
      map: pageMap,
      position: pos
  });
  // Add the info window click event listener
  marker.addListener( 'click', function() {
    infowindow.setContent( generateStudentInfoWindowContent( student ) );
    infowindow.open( pageMap, marker );
  });
  return marker;
}

// Generates content the string for a marker's infowindow from a student's data.
function generateStudentInfoWindowContent( student ) {
  return '<div id="content">' +
      '<h4 id="firstHeading" class="firstHeading">' + student.first_name + " " + student.last_name + '</h4>' +
      '<div id="bodyContent">' +
        '<p>' + student.address + '<br/>' + student.city + ', ' + student.state + ' ' + student.zip + '</p>' +
        '<p><b>Attended:</b> ' + student.school_year + '</p>' +
      '</div>' + 
    '</div>';
}

// Assembles address component strings into one.
function assembleAddress( street, city, state, zip ) {
  var address = street;
  if ( city !== null && state !== null ) {
    address += ' ' + city + ", " + state;
  }
  if ( zip !== null ) {
    address += ' ' + zip;
  }
  return address;
}

// Adds checkboxes to the sidebar for each layer and layer group.
function fillSidebar() {
  layers.forEach( function( layer, index, array ) {
    if( layer instanceof LayerGroup ) { // Layer group
      var html = '<div class="group-checkbox"><input type="checkbox" id="' + layer.name +
        '_checkbox" class="group-checkbox"> ' + layer.name + '</div>' + '<div id="' + layer.name +
        '_group" class="layer-group"></div>';
      $('#sidebar').append( html );
      layer.linkCheckbox( $( '#' + layer.name + '_checkbox' ) );
      // Fill the layer-group element with the layer checkboxes in the group.
      var group = layer;
      layer.layers.forEach( function( layer, index, array ){
        var html = '<div class="layer-checkbox"><input type="checkbox" id="' + layer.name +
          '_checkbox" class="group-checkbox"> ' + layer.name + '</div>';
        $( '#' + group.name + '_group' ).append( html );
        layer.linkCheckbox( $( '#' + layer.name + '_checkbox' ) );
      });
    } else { // Ungrouped layer
      var html = '<div class="layer-checkbox"><input type="checkbox" id="' + layer.name +
        '_checkbox" class="layer-checkbox"> ' + layer.name + '</div>';
      $('#sidebar').append( html );
      layer.linkCheckbox( $( '#' + layer.name + '_checkbox' ) );
    }
  });
}
