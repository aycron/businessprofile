var map;

function setProfileMap(lat,lng) {
	var myLatlng = new google.maps.LatLng(lat,lng)
	var myOptions = { 
    	zoom: 15, 
    	center: myLatlng, 
    	mapTypeId: google.maps.MapTypeId.ROADMAP
  	} 
	map = new google.maps.Map(document.getElementById("section-5-body-map"), myOptions);
	map.setCenter(myLatlng);					
				
	var image = '/images/map/Mapa-marker.png';
	
	var marker = new google.maps.Marker({ 
   		position: myLatlng,  
   		map: map,  
		icon: image
	});
			
	marker.setMap(map);	
}

function setZoomOut() {
	var zoom = map.getZoom();
	
	if (zoom > 2) {
		map.setZoom(zoom-1);
	}
}

function setZoomIn() {
	var zoom = map.getZoom();
	
	if (zoom < 20) {
		map.setZoom(zoom+1);
	}
}

function moveOnMap(x,y) {
	map.panBy(x,y);	
}

function setCleanMap(lat,lng) {
	var myLatlng = new google.maps.LatLng(lat,lng)
	var myOptions = { 
    	zoom: 15,
		disableDefaultUI: true,
		draggable: false, 
    	center: myLatlng, 
    	mapTypeId: google.maps.MapTypeId.ROADMAP
  	} 
	map = new google.maps.Map(document.getElementById("section-5-body-map"), myOptions);
	map.setCenter(myLatlng);					
				
	var image = '/images/map/Mapa-marker.png';
	
	var marker = new google.maps.Marker({ 
   		position: myLatlng,  
   		map: map,  
		icon: image
	});
			
	marker.setMap(map);	
}
