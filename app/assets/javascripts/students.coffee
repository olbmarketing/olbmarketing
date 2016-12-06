$(document).on 'turbolinks:load', ->
  if $('#studentsTable').length > 0 && !$('#studentsTable').hasClass('data')
    $('#studentsTable').dataTable 'scrollX': true
    # make dataTable operation idempotent
    $('#studentsTable').addClass('data')
  return
