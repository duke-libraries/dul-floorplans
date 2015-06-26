$ ->
  $('#filter_building_id')
    .on 'change', (e) ->
      building_id = $(this).val()
      $.ajax({
        url: '/admin/rooms/floorplan_filter_options'
        data: {building_id: building_id}
        success: (data, textStatus, jqXHR) ->
          $('#filter_floorplan_id').empty()
          $.each data, (index, value) ->
            $('#filter_floorplan_id').append("<option value='" + value[1] + "'>" + value[0] + "</option>")
        error: (jqXHR, textStatus, err) ->
      })
