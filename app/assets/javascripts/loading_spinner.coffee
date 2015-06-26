@PageSpinner = 
  spin: (ms=500)->
    @spinner = setTimeout( (=> @add_spinner()), ms)
    $(document).on 'page:change', =>
      @remove_spinner()
  spinner_html: '
    <div class="modal fade" id="page-spinner" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header card-title">Please Wait...</div>
          <div class="modal-body card-body">
            <i class="icon-spinner icon-spin icon-2x"></i>
            &nbsp;Loading...
          </div>
        </div>
      </div>
    </div>
  '
  spinner: null
  add_spinner: ->
    $('body').append(@spinner_html)
    $('body div#page-spinner').modal('show')
  remove_spinner: ->
    clearTimeout(@spinner)
    $('div#page-spinner').modal('hide')              
    $('div#page-spinner').on 'hidden', ->
      $(this).remove()
      
$(document).on 'page:fetch', ->
  PageSpinner.spin()
