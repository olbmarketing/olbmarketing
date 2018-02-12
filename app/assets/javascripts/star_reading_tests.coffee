# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  if $('.star_reading_tests').length > 0 &&  $('#star_test_gender_form').length > 0 && !$('#star_test_gender_form').hasClass('data')
    # update star_math_test_download_report_link to pass gender as parameter
    gender_value = document.querySelector('input[name = "gender"]:checked').value
    download_report_btn_href = $('#star_reading_test_download_report_link').attr('href')
    $('#star_reading_test_download_report_link').attr('href', download_report_btn_href + '&gender=' + gender_value)
    # make gender operation idempotent
    $('#star_test_gender_form').addClass('data')
  if $('.star_reading_tests').length > 0 && $('#star_test_gender_form').length
    # register input click event 
    $("input[name='gender']").click -> 
        gender_value = document.querySelector('input[name = "gender"]:checked').value
        download_report_btn_href = $('#star_reading_test_download_report_link').attr('href')
        $('#star_reading_test_download_report_link').attr('href', download_report_btn_href.replace(/gender=.*/i, 'gender='+gender_value))
  return