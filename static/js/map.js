	
			if ($('.map-canvas').length) {
				var styles = [
					
						];
				var mapOptions = {center: new google.maps.LatLng(40.936529,-74.1535307),zoom: 14,scrollwheel: false,panControl: true,mapTypeControl: false,streetViewControl: false,disableDefaultUI: false,zoomControl: true,disableDoubleClickZoom: false,fullscreenControl: false,styles: styles
				};
				var initMap = function() {var contactdata = $('#contact-map').data('content');var map = new google.maps.Map(document.getElementById("contact-map"), mapOptions);var bounds = new google.maps.LatLngBounds();var myIcon = new google.maps.MarkerImage("assets/images/map_pin.png", null, null, null, new google.maps.Size(50, 52));var marker = new google.maps.Marker({	position: new google.maps.LatLng(40.936529,-74.1535307),	map: map,	icon: myIcon
					});

				};
				initMap();
				google.maps.event.addDomListener(window, 'load resize', initMap);
			}

