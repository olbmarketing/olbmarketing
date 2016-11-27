# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  if $('#pairsh_table').length > 0 && !$('#studentsTable').hasClass('data')
    $('#pairsh_table').dataTable 'scrollX': true
    # make dataTable operation idempotent
    $('#pairsh_table').addClass('data')
  return
