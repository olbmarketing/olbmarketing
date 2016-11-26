# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('#terraNovaTest').dataTable 'scrollX': true
  if $('#terra_nova_test_gender_form').length > 0 && !$('#terra_nova_test_gender_form').hasClass('data')
    # update star_test_download_report_link to pass gender as parameter
    gender_value = document.querySelector('input[name = "gender"]:checked').value
    $('.terra_nova_test_download_report_links').each((index) ->
      download_report_btn_href = $(this).attr('href')
      #console.log(this)
      $(this).attr('href', download_report_btn_href + '&gender=' + gender_value)
      return
    )
    # make gender operation idempotent
    $('#terra_nova_test_gender_form').addClass('data')
  if $('#terra_nova_test_gender_form').length
    # register input click event 
    $("input[name='gender']").click -> 
      gender_value = document.querySelector('input[name = "gender"]:checked').value
      $('.terra_nova_test_download_report_links').each((index) ->
        download_report_btn_href = $(this).attr('href')
        $(this).attr('href', download_report_btn_href.replace(/gender=.*/i, 'gender='+gender_value))
        return
      )
  return
