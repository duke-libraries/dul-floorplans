$ ->
  $('#diagInlineEditFloorArea')
    .on 'show.bs.modal', (e) ->
      target = e.relatedTarget
      coord = $(target).attr('data-coord')
      shape = $(target).attr('data-shape')
      url_target = $(target).attr('data-url')
      floorarea_id = $(target).attr('data-floor-area-id')
      $('#editFloorAreaShape').val(shape)
      $('#editFloorAreaCoord').val(coord)
      $('#primaryButton').attr('data-url', url_target).attr('data-floor-area-id',floorarea_id)
      

  $('.btn-primary', '#diagInlineEditFloorArea')
    .on 'click', (e) ->
      # POST the data to the server
      target = e.target
      coord = $('#editFloorAreaCoord').val()
      shape = $('#editFloorAreaShape').val()
      url = $(target).attr('data-url')
      floor_area_id = $(target).attr('data-floor-area-id')

      $.ajax
        url: url
        data: {floor_area: {coord: coord, shape: shape}, json: true}
        type: 'PUT'
        success: (data, textStatus, jqXHR) ->
          alert('hi')
        error: (jqXHR, textStatus, err) ->
          debugger
          alert('oops')
