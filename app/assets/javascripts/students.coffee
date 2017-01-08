$(document).on 'turbolinks:load', ->
  if $('#studentsTable').length > 0 && !$('#studentsTable').hasClass('data')
    $('#studentsTable').dataTable 'scrollX': true
    # make dataTable operation idempotent
    $('#studentsTable').addClass('data')

  # redirect to retrive corresponding school year 
  $('select[name="student[school_year]"]').on 'change', (e) => 
    window.location.href = window.location.origin + window.location.pathname + '?school_year=' + e.target.value
  return
