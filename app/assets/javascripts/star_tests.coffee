# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->
    if !$.fn.dataTable.isDataTable( '#star_tests_table' )
        $('#star_tests_table').dataTable 'scrollX': true
    if $('#star_test_gender_form').length > 0
        # update star_test_download_report_link to pass gender as parameter
        gender_value = document.querySelector('input[name = "gender"]:checked').value
        download_report_btn_href = $('#star_test_download_report_link').attr('href')
        $('#star_test_download_report_link').attr('href', download_report_btn_href + '&gender=' + gender_value)
        # register input click event 
        $("input[name='gender']").click -> 
            gender_value = document.querySelector('input[name = "gender"]:checked').value
            download_report_btn_href = $('#star_test_download_report_link').attr('href')
            $('#star_test_download_report_link').attr('href', download_report_btn_href.replace(/gender=.*/i, 'gender='+gender_value))
    return
