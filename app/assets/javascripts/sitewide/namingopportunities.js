// javaScript and JQuery routines for the naming-opportunities floorplan pages


$(document).ready(function() {

	// first prep the fancybox options and instantiate it (we need to use the click() method here since we're dynamically adjusting the href parameter)
	$('.room-link').bind('ajax:complete', function(e, o, ajaxObj) {
		var div = o.responseText;
		$('#roomDetailsModal .modal-body')
			.html( div );
		$('#roomDetailsModal').modal('show');
	});
	/*
	$.ajax(href, {
		success : function(data, status, o) {
			$img = $('<img>');
			$img.attr('src', '/assets/' + data.thumbnail.image_url);
			$thumbnailDiv = $('<div></div>');
			$thumbnailDiv.append( $img );
			$('#roomDetailsModal .modal-body').append( $thumbnailDiv );
			$('#roomDetailsModal').modal('show');
		},
		error : function() {
			
		}
	});
	*/
	$('#roomlist a[data-target-area]').click(function(e) {
		href = $(this).attr('href');
		room_title = $(this).attr('title');
		
		// set the modal title prior to loading markup
		$('#roomDetailsModalLabel').text( room_title );
		return e.preventDefault;
	});
	
	//$('map[name!="libraryprofilemap"] area, #roomlist a[data-target-area]').click(fancyboxActivation);

	// now prep some of the mapster options (including the appropriate JQuery container objects), and instantiate the mapster options

	document.floorplans = $('#floorplans img'); // lumps together all of the areamap-enabled imgs into a single jQuery object (should only be one img element, but previous versions of this application had the option of multiple floorplans on one page)

	// all of the mapster options are provided in great detail at <https://github.com/jamietre/ImageMapster/wiki/Options>
	var imageMapsterCommonSettings = {
		stroke: true,
		strokeColor: '003300',
		strokeWidth: 2,
		fillColor: '00cc00',
		fillOpacity: 0.5,
		fadeInterval: 20,
		mapKey: 'data-roomgroup', // the attribute on each area tag that identifies it uniquely (or as part of a group with the same value)
		mapValue: 'data-roomdesc' // a user-defined attribute on the area tag that will be passed in onGetList - can be used for quick and dirty listmaking
	};
	
	var floorplanMapsterOptions = {
		isSelectable: true, // areas can be selected/deselected
		singleSelect: true,
		listKey: 'name', // the attribute on the external list that matches it with the image map. These values should correspond with the mapKey values from the imagemap.
		listSelectedAttribute: 'checked', // an attribute that will be created or removed from the external list
		sortList: 'asc', //
		onClick: highlightRoomInList // event when item is clicked
	};

	$.extend(floorplanMapsterOptions, imageMapsterCommonSettings);

	// also add definitions for non-nameable rooms (mainly different coloring).  Identifying the right areas for this category of rooms is based on the presence of a "data-nameable" attribute on <area> elements associate dwith a map, and also that this attribute is set to "no".  To get this list, we need to iterate through all <area> elements, identify the distinct set of <area> "data-roomgroup" values that are not-nameable, and then produce a list of those areas in an image-mapster-compatible options array.
	var nonNameableAreas = [];
	$('area[data-nameable]').each(function() {
		var nameability = $(this).attr('data-nameable');
		var roomGroup = $(this).attr('data-roomgroup');
		if ((nameability && ((nameability == 'no') || (nameability == "pending"))) && roomGroup && ($.inArray(roomGroup, nonNameableAreas) < 0)) {
			// most of the qualifying areas will be non-nameable, but a few might be pending
			fillColorCode = '336699';
			if (nameability == "pending") {
				fillColorCode = '800000';
			}
			nonNameableAreas.push({key: roomGroup, fillColor: fillColorCode});
		}
		// also add some hover capabilities to each room area (so that the roomlist links can be highlighted); we'll just piggyback on the browser hover methods, using a special class name and manually adding/removing the class to the corresponding roomlist link based on the mouse event
		$(this).hover(function(e) {
			var className = 'nameablehover';
			if (nameability) {
				if (nameability== 'no') {
					className = 'nonnameablehover';
				}
				if (nameability== 'pending') {
					className = 'pendingsalehover';
				}
			}
			var roomListLink = $('#roomlist a[data-target-area="' + roomGroup + '"]');
			// add the class to the aLink on enter/ remove on leave
			if (e.type == 'mouseenter') {
				roomListLink.addClass(className);
			} else if (e.type == 'mouseleave') {
				roomListLink.removeClass(className);
			}
		});
	});
	floorplanMapsterOptions['areas'] = nonNameableAreas;

	function IsImageOk(img) {
		console.log(img[0].complete);
		console.log(img[0].naturalWidth);
		for (var i in img[0]) {
			console.log(i + ' = ' + img[0][i]);
		}
		if (!img[0].complete) {
			return false;
		}	
		if (img[0].naturalWidth === 0) {
			return false;
		}
		return true;
	}

	console.log('floorplans length = ' + document.floorplans.length);
	/*
	$('.floorplan-map').hide().on('load', function() {
		$(this).show({
			complete : function() {
				document.floorplans.mapster(floorplanMapsterOptions); // activate mapster options for the floorplan(s)
				$('#roomlist a[data-target-area]').on('click mouseenter mouseleave', {
					'imageMapJqueryObject': document.floorplans
					},listLinkEventListener
				); // prep the roomlist links for both clicking and for hovering				
			}
		});
	});
	*/

	if (document.floorplans.length > 0) {
		document.floorplans.mapster(floorplanMapsterOptions); // activate mapster options for the floorplan(s)
		$('#roomlist a[data-target-area]').on('mouseenter mouseleave', {'imageMapJqueryObject': document.floorplans},listLinkEventListener); // prep the roomlist links for both clicking and for hovering
	}
	/*
	if (document.floorplans.length > 0) {
		document.floorplans.mapster(floorplanMapsterOptions); // activate mapster options for the floorplan(s)
		$('#roomlist a[data-target-area]').on('click mouseenter mouseleave', {'imageMapJqueryObject': document.floorplans},listLinkEventListener); // prep the roomlist links for both clicking and for hovering
	}
	*/
	
	// also instantiate imagemapster on home page image
	var buildingProfileImage = $('.libraryprofilegraphic img[usemap]');
	$(buildingProfileImage).each(function(n, el){
		var buildingProfileImageMapName = $(this).attr('usemap');
		if (buildingProfileImageMapName && (buildingProfileImageMapName.length > 0)) {
			buildingProfileImageMapName = buildingProfileImageMapName.replace(/#/, '');
			// compile imageMapster options for the building-profile image...
			buildingProfileMapsterOptions = { isSelectable: false, onClick: followAreaHref, noHrefIsMask: false };
			$.extend(buildingProfileMapsterOptions, imageMapsterCommonSettings);
			var buildingProfileAreas = [];
			$('map[name="' + buildingProfileImageMapName + '"] area').each(function() {
				var floorGroup = $(this).attr('data-roomgroup');
				buildingProfileAreas.push({key: floorGroup, isSelectable: false});
			});
			$(this).mapster(buildingProfileMapsterOptions);
			// and make floor list links able to highlight imagemap floors on hover
			$('.buildingfloorlist a[data-target-area]').on('hover', {'imageMapJqueryObject': $(this)}, listLinkEventListener);
		}
		
	});
	/*
	var buildingProfileImageMapName = buildingProfileImage.attr('usemap');
	if (buildingProfileImageMapName && (buildingProfileImageMapName.length > 0)) {
		buildingProfileImageMapName = buildingProfileImageMapName.replace(/#/, '');
		// compile imageMapster options for the building-profile image...
		buildingProfileMapsterOptions = { isSelectable: false, onClick: followAreaHref, noHrefIsMask: false };
		$.extend(buildingProfileMapsterOptions, imageMapsterCommonSettings);
		var buildingProfileAreas = [];
		$('map[name="' + buildingProfileImageMapName + '"] area').each(function() {
			var floorGroup = $(this).attr('data-roomgroup');
			buildingProfileAreas.push({key: floorGroup, isSelectable: false});
		});
		buildingProfileImage.mapster(buildingProfileMapsterOptions);
		// and make floor list links able to highlight imagemap floors on hover
		$('.buildingfloorlist a[data-target-area]').on('hover', {'imageMapJqueryObject': buildingProfileImage}, listLinkEventListener);
	}
	*/
	// fade in the various lists (previously hidden from view)
	$('#roomlist, #buildingfloorlist, #buildinglist').show('blind', {direction: 'vertical'}, 600);
});

// Functions follow below

// fancyboxActivation() is a relatively simple function meant to be used on the click event for <area> or <a> links.  It is invoked in two jQuery contexts: as a click method for imagemap areas (since those are presumably known by the time the document is ready), and as a live method for future <a> links (bound to the click method)
function fancyboxActivation(e) {
	var currentHref = $(this).attr('href');
	if (currentHref && (currentHref.length > 0)) {
		// we need to do an override if we're dealing witht he <a> links on a roomlist, since those links' href is simply "#".
		var targetArea = $(this).attr('data-target-area');
		if (targetArea && (targetArea.length > 0)) {
			var targetAreaHref = $('area[data-roomgroup="' + targetArea + '"]').attr('href'); // this should grab the first href attribute from the applicable area(s)
			if (targetAreaHref && (targetAreaHref.length > 0)) {
				currentHref = targetAreaHref;
			}
		}
		var fancyboxOptions = {
			'hideOnContentClick' : false,
			'href' : currentHref + '?mode=popup'
		};
		// make some adjustments for IE7 (it doesn't seem to be able to auto-size the popup properly)
		if ($.browser.msie && (parseInt($.browser.version, 10) < 8)) {
			var fancyboxOptionsIE7 = {
				'autoDimensions': false,
				'width': 850,
				'height': 680,
				'autoScale': true
			}
			$.extend(fancyboxOptions, fancyboxOptionsIE7);
		}
		$.fancybox(fancyboxOptions);
	}
}

// listLinkEventListener() is an event listener used for binding links in a list of rooms, or a list of floors, or for an <area> on an imagemap, to a desired image-mapster image-map(s).  It is mainly invoked via the "delegate" Jquery method, so that future bindings are assured (regardless of the current link-list or <area> contents).  It can handle various events, so that it can be used not just for a "click" event, but also hover-related events (mouseenter, mouseleave).  It is also flexible as to which mapster-instantiated object it can invoke -- this information is passed in via the event.data attribute imageMapJqueryObject. It expects the context to be an element with a data-target-area attribute, containing the key value for an appropriate imagempaster img <area>.
function listLinkEventListener(e) {
	var targetAreaName = $(this).attr('data-target-area');
	if (targetAreaName && (targetAreaName.length > 0)) {
		// also identify the appropriate jQuery object (mapster-enabled) for the imagemap
		if ((typeof(e.data) != 'undefined') && (typeof(e.data.imageMapJqueryObject) != 'undefined')) {
			// for mouse-entry, not only highlight the appropriate area
			if (e.type == 'mouseenter') {
				e.data.imageMapJqueryObject.mapster('highlight', targetAreaName);
			// for mouse-leave, remove any highlighting in the imagemapster (note that this will apply across all images -- image-mapster doesn't let you specify an area to remove highlighting (but imagemapster also doesn't allow for multiple simultaneous image-highlighting...))
			} else if (e.type == 'mouseleave') {
				e.data.imageMapJqueryObject.mapster('highlight', false); 
			} else if (e.type == 'click') {
				// click behavior is specific to imagemap-mapster types, so make sure to use the right one...
				if (e.data.imageMapJqueryObject == document.floorplans) {
					// for link-clicking on the roomList links, select the area on the imagemap, much like what is done via the native imagemapster plugin for clicked areas (making sure to pass the *inverse* of the selected state to the styleRoomListLink function, as the styleRoomListLink function expects to get the post-clicked selected state, and here we're only able to determine the pre-clicked state...)
					var selectedState = e.data.imageMapJqueryObject.mapster('get', targetAreaName);
					e.data.imageMapJqueryObject.mapster('set', 'toggle', targetAreaName);
					styleRoomListLink(selectedState ? false : true, targetAreaName);
				}
			}
		}
	}
	return false;
}

// styleRoomListLink() is a companion function to the listLinkEventListener() and highlightRoomInList() methods, effectively wiping any bold-effects in the roomlist links, and bolding the appropriate link based on the passed-in arguments (which should be a current-selection-state and an <area> name-key)
function styleRoomListLink(currentSelectedState, targetAreaName) {
	$('#roomlist a[data-target-area]').parent('li').removeClass('selected ui-corner-all').filter(function(index) {
		// we only want to select those elements that match on the targetAreaName, for which the currentSelectedstate is false (indicating that it's been un-selected)
		var returnState = false;
		if (currentSelectedState) {
			var elementAttribute = $(this).children('a').attr('data-target-area');
			if (elementAttribute && (elementAttribute == targetAreaName)) {
				returnState = true;
			}
		}
		return returnState;
	// }).fadeOut(100, function() { $(this).addClass('selected ui-corner-all').fadeIn('slow'); });
	}).addClass('selected ui-corner-all').effect('highlight', {}, 1000);
}

// event-handler for building-profile clicked areas (basically, just normal click behavior (follow href), but it appears that imageMapster actually overrides normal click behavior, so we need to add it back in this case).
function followAreaHref(data) {
	document.location = this.href;
}

// event-handler for non-building-profile clicked areas (for more information on the data-argument for this function, see the "onClick" callback event documentation at <https://github.com/jamietre/ImageMapster/wiki/Options>)
function highlightRoomInList(data) {
	// all we need to do here is style the respective roomlist link appropriately (depending on whether the clicked area is selected or not)
	styleRoomListLink(data.selected, data.key);
}


