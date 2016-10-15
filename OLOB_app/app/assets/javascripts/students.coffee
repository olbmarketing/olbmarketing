# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


angular.module("myApp", ["ngTable"]);

$(document).ready ->
  $('.filterable .btn-filter').click ->
    $panel = $(this).parents('.filterable')
    $filters = $panel.find('.filters input')
    $tbody = $panel.find('.table tbody')
    if $filters.prop('disabled') == true
      $filters.prop 'disabled', false
      $filters.first().focus()
    else
      $filters.val('').prop 'disabled', true
      $tbody.find('.no-result').remove()
      $tbody.find('tr').show()
    return
  $('.filterable .filters input').keyup (e) ->

    ### Ignore tab key ###

    code = e.keyCode or e.which
    if code == '9'
      return

    ### Useful DOM data and selectors ###

    $input = $(this)
    inputContent = $input.val().toLowerCase()
    $panel = $input.parents('.filterable')
    column = $panel.find('.filters th').index($input.parents('th'))
    $table = $panel.find('.table')
    $rows = $table.find('tbody tr')

    ### Dirtiest filter function ever ;) ###

    $filteredRows = $rows.filter(->
      value = $(this).find('td').eq(column).text().toLowerCase()
      value.indexOf(inputContent) == -1
    )

    ### Clean previous no-result if exist ###

    $table.find('tbody .no-result').remove()

    ### Show all rows, hide filtered ones (never do that outside of a demo ! xD) ###

    $rows.show()
    $filteredRows.hide()

    ### Prepend no-result row if all rows are filtered ###

    if $filteredRows.length == $rows.length
      $table.find('tbody').prepend $('<tr class="no-result text-center"><td colspan="' + $table.find('.filters th').length + '">No result found</td></tr>')
    return
  return
