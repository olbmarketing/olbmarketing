// Callback for initializing the map once the API is loaded
function initialize() {
  beachFlag = {
    url: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png',
    size: new google.maps.Size(20, 32),
    origin: new google.maps.Point(0, 0),
    anchor: new google.maps.Point(0, 32)
  };
  // OLB's coordinates
  var OLBPos = new google.maps.LatLng(40.053930, -83.035042);
  var myOptions = {
      zoom: 13,
      center: OLBPos,
      streetViewControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  pageMap = new google.maps.Map(document.getElementById("map-canvas"),
          myOptions);

  // "Drops" a marker on OLB
  var marker = new google.maps.Marker({
    map: pageMap,
    draggable: false,
    animation: google.maps.Animation.DROP,
    position: OLBPos,
    icon: beachFlag
  });
  marker.addListener('click', function() {
    infowindow.setContent( '<div id="content">'+
      '<div id="siteNotice">'+
      '</div>'+
      '<h4 id="firstHeading" class="firstHeading">Our Lady of Bethlehem</h4>'+
      '<div id="bodyContent">'+
      '</div>'+
      '</div>' );
    infowindow.open(pageMap, marker);
  });

  geocoder = new google.maps.Geocoder();

  infowindow = new google.maps.InfoWindow({
    content: null
  });

  initializeLayers();
}

function initializeLayers() {
  initializeParishLayer();
  initializeStudentLayers();
}

function initializeParishLayer() {
  displayParishLayer = false;
  parishLayer = [];
  var parishes = $('.parishes_class').data('parishes');
  parishes.forEach( function (parish, index, array) {
    geocoder.geocode( { 'address': assembleAddress( parish.address,
          parish.city, parish.state, parish.zip ) },
      function(results, status) {
        if (status == 'OK') {
          var marker = new google.maps.Marker({
              map: pageMap,
              position: results[0].geometry.location,
              icon: beachFlag,
              animation: google.maps.Animation.DROP
          });
          marker.addListener('click', function() {
            infowindow.setContent('<div id="content">'+
              '<div id="siteNotice">'+
              '</div>'+
              '<h4 id="firstHeading" class="firstHeading">' + parish.name + '</h4>' +
              '<h5>' + parish.address + '<br/>' + parish.city + ', ' + parish.state + ' ' + parish.zip + '</h5>' +
              '<div id="bodyContent">'+
              '</div>'+
              '</div>');
            infowindow.open(pageMap, marker);
          });
          parishMarkers.push( marker );
        } else {
          console.log('Geocode was not successful for the following reason: ' + status);
        }
      });
  });
}

function updateMap() {
  if (!displayParishLayer) {
    setMarkersToMap(parishMarkers, pageMap);
  } else {
    setMarkersToMap(parishMarkers, null);
  }
  displayParishLayer = !displayParishLayer;
}

function initializeStudentLayers() {
  displayStudentLayer = false;
  studentLayers = [];
  var students = $('.students_class').data('students');
  //console.log(students);
  for ( var _class in students ) {
    if ( students.hasOwnProperty(_class) ) {
      var markers = [];
      //console.log(students[_class]);
      students[_class].forEach( function ( student, index, array ) {
        var address = assembleAddress( student.address, student.city,
            student.state, student.zip );
        geocoder.geocode( { 'address': address },
          function(results, status) {
            if (status == 'OK') {
              var marker = new google.maps.Marker({
                  title: student.first_name + " " + student.last_name,
                  map: pageMap,
                  position: results[0].geometry.location,
                  animation: google.maps.Animation.DROP
              });
              marker.addListener('click', function() {
                infowindow.setContent('<div id="content">'+
                  '<div id="siteNotice">'+
                  '</div>'+
                  '<h4 id="firstHeading" class="firstHeading">' + student.first_name + " " + student.last_name + '</h4>'+
                  '<h5>' + student.address + '<br/>' + student.city + ', ' + student.state + ' ' + student.zip + '</h5>' +
                  '<div id="bodyContent">'+
                  '<p><b>Attended:</b> ' + student.school_year + '</p>' +
                  '</div>'+
                  '</div>');
                infowindow.open( pageMap, marker );
              });
              markers.push( marker );
            } else {
              console.log( 'Could not find \"' + address + '\":' + status );
            }
          });
      });
      studentLayers.push( {[_class]: { display: true, markers: markers } } );
    }
  }
  //console.log(studentLayers);
}

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
