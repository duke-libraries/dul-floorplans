$ ->
  ###
  Install a small dainty little modal widget for alerts
  ###
  $modal = $('<div class="modal fade modal-alert" role="dialog"><div class="modal-dialog">' +
    '<div class="modal-content"><div class="modal-header">' +
    '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
    '<h4 class="modal-title"></h4>' +
    '</div>' +
    '<div class="modal-body"></div>' + 
    '<div class="modal-footer">' +
    '<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>' +
    '</div></div></div></div>' )
  $('body').append($modal)
      
  $("#btnAddFloorArea").on "click", (e) ->
    url = $(this).attr('href')
    new_coords = $('#newAreaCoords').val()
    new_area_shape = $('#areaMapShape option:selected').val()
    
    $.ajax
      url: url
      data: {coord: new_coords, shape: new_area_shape}
      type: 'POST'
      success: (data, textStatus, jqXHR) ->
        if (Object.prototype.toString.call( data ) == '[object Array]') 
          # error occured.
          $('.modal-alert .modal-title').text('Whoops')
          $('.modal-alert .modal-body').html('<p>' + data[0] + '</p>')
          $('.modal-alert').modal('show')
        else 
          $('.modal-alert .modal-title').text('Success')
          $('.modal-alert .modal-body').html('<p>The new Floor Area record has been added.</p>')
          $('.modal-alert').modal('show')
          $('TBODY.tbodyFloorAreas').append(data).children(':last').hide().fadeIn(500)
          $('#newAreaCoords').val('')
        
        
    e.preventDefault();
    
  $('#diagInlineEditArea')
    .on 'show.bs.modal', (e) ->
      target = e.relatedTarget
      coord = $(target).attr('data-coord')
      shape = $(target).attr('data-shape')
      $('#editFloorAreaShape').val(shape)
      $('#editFloorAreaCoord').val(coord)
    
