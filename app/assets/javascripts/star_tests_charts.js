// this file generate chart for star test data
/*
// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['bar']});

// Set a callback to run when the Google Visualization API is loaded.

document.addEventListener("turbolinks:load", function() {
    if (document.getElementById('star_tests_table')) {
        google.charts.setOnLoadCallback(drawChart);    
    }
});
*/
/*
window.onpageshow = function() {
    console.log("hello");
    google.charts.setOnLoadCallback(drawChart);   
};*/

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart() {

    // store dom star_tests_table
    var table = document.getElementById('star_tests_table')
    // matrix that stores star test header and rows(data) 
    var matrix = [];
    var header = [];
    var nrows = table.getElementsByTagName('tr').length;
    // get header
    [].slice.call(table.getElementsByTagName('tr')[0].getElementsByTagName('th')).forEach(
            function(td) {
                if (td.innerHTML !== "") header.push(td.innerHTML);
            });
    matrix.push(header);
    
    if (nrows >= 2) {
        for (var i = 1; i < nrows; i++) {
            var row = [];
            [].slice.call(table.getElementsByTagName('tr')[i].getElementsByTagName('td')).forEach(
                function(td) {
                    if (row.length < header.length) {
                        if (isNaN(td.innerHTML)) {
                            row.push(td.innerHTML);
                        } else {
                            row.push(+td.innerHTML);
                        }
                    }
                });
            matrix.push(row);
        }
    }

    // delete Scaled score & Developmental stage
    for (var i = 0; i < matrix.length; i++) {
        matrix[i].splice(1,2);
    }
    
    // transpose table 
    var transposed_table = [];
    for (var i = 0; i < header.length; i++) {
        row = [];
        for (var j = 0; j < matrix.length; j++) {
            row.push(matrix[j][i]);
        }
        transposed_table.push(row);
    }
    

    // Create the data table.
    var data = google.visualization.arrayToDataTable(transposed_table);
    /* 
    var data = google.visualization.arrayToDataTable([
          ['Year', 'Sales', 'Expenses', 'Profit'],
          ['2014', 1000, 400, 200],
          ['2015', 1170, 460, 250],
          ['2016', 660, 1120, 300],
          ['2017', 1030, 540, 350]
        ]);

    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Topping');
    data.addColumn('number', 'Slices');
    data.addRows([
        ['Mushrooms', 3],
        ['Onions', 1],
        ['Olives', 1],
        ['Zucchini', 1],
        ['Pepperoni', 2]
    ]);
    */

    // Set chart options
    /*
    var options = {'title':'How Much Pizza I Ate Last Night',
                    'width':1400,
                    'height':500};
    */
    var options = {
          chart: {
            title: 'Student Performance'
          }
        };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.charts.Bar(document.getElementById('star_test_chart_div'));
    chart.draw(data, options);
}