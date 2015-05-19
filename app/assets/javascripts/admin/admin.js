// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-migrate-min
//= require jquery_ujs
// require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= floorplans
//= require_self

/*
$(function() {
	$('#btnAddFloorArea').on('click', function(evt) {
		var url, new_coord, new_area_shape;
		url = $(this).attr('href');
		new_coords = $('#newAreaCoords');
		new_area_shape = $('#areaMapShape');
		alert(url);
		try {
		$.ajax({
			url: url,
			dataType: 'json',
			data: {coord: new_coords, shape: new_area_shape},
			type: 'POST',
			success: function(data, textStatus, jqXHR) {
				
			}
		});
		} catch(e) {
			console.log(e);
		}
		return evt.preventDefault();
	});
});
*/
