// Load the Visualization API and the corechart package.
google.charts.load('current', {packages: ['corechart', 'bar']});

// add event listener for star tests report 
document.addEventListener("turbolinks:load", function() {
    if (document.getElementById('star_tests_report')) {
        create_report();
    }
});

// ajax request to server 
function httpAsync(httpMethod, url, callback) {
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function() {
        if (httpRequest.readyState == 4 && httpRequest.status == 200) {
            callback(httpRequest.responseText);
        }
    }
    httpRequest.open(httpMethod, url, true);
    httpRequest.send(null);
}

// tmp 
//var myT = '';
// end tmp 

function create_report() {
    // send ajax request to server
    var callback = function(responseText) {
        // tmp 
        //myT = responseText;
        // end tmp 
        // process response from server
        var tests = JSON.parse(responseText);
        google.charts.setOnLoadCallback( function () {
            drawAnnotations(tests);
        });
    }
    httpAsync("GET", window.location.origin + '/star_tests.json' + window.location.search, callback);

}

function drawAnnotations(tests) {
    if (tests.length === 0) {
        document.getElementById('star_tests_chart_div').innerHTML = 'Star Tests Chart Not Available';
    } else {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Category');
        for (var i = 0; i < tests.length; i++) {
            data.addColumn('number', tests[i].test_date);
            data.addColumn({type: 'number', role: 'annotation'});
        }

        
        // create a map for test Category
        var test_category_map = {'AP': 'alphabetic_principle', 'CW': 'concept_of_word', VD: 'visual_discrimination', PA: 'phonemic_awareness', PH: 'phonics', SA: 'structural_analysis', VO: 'vocabulary', SC: 'sentence_level_comprehension', PC: 'paragraph_level_comprehension', EN: 'early_numeracy'};
        var test_category_map_keys = Object.keys(test_category_map);
        // add test data 
        // for reference see first example on https://developers.google.com/chart/interactive/docs/gallery/columnchart
        for (var i = 0; i < test_category_map_keys.length; i++) {
            var my_row = [];
            var key = test_category_map_keys[i]
            // first push test Category
            my_row.push(key);
            // push data for each test date 
            for (var j = 0; j < tests.length; j++) {
                my_row.push(tests[j][test_category_map[key]]);
                // another copy for annotation
                my_row.push(tests[j][test_category_map[key]]);
            }
            data.addRow(my_row);
        }
        var options = {
            title: 'Student Performance', 
            hAxis: {
                title: 'Test Category',
            }
        }

        var chart = new google.visualization.ColumnChart(document.getElementById('star_tests_chart_div'));
        chart.draw(data, options);
        
    }
    
    

}