$(document).on 'turbolinks:load', ->
  $('#studentsTable').DataTable 'scrollX': true
  return
