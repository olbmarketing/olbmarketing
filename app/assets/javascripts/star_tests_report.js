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
        updateChartView();
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
        
        updateChartView(data);
        
    }
}

function downloadPDF(img_uri) {
    var doc = new jsPDF();
    doc.setFontSize(40);
    doc.text(35, 25, "Student Report");
    doc.addImage(img_uri, 'PNG', 15, 40, 180, 80);
    doc.save('test.pdf');
}

function updateChartView(data) {
        if (!data) {
            document.getElementById('star_tests_chart_div').innerHTML = 'Star Tests Chart Not Available';
        } else {
            var chart = new google.visualization.ColumnChart(document.getElementById('star_tests_chart_div'));

            // add a button for download when ready 
            google.visualization.events.addListener(chart, 'ready', function() {
                var report_div = document.getElementById('star_tests_report');
                var btn = document.createElement("BUTTON");        // Create a <button> element
                var t = document.createTextNode("Download Graph");  
                btn.appendChild(t);   
                btn.addEventListener('click', function() {
                    downloadPDF(chart.getImageURI());
                });
                report_div.insertBefore(btn, report_div.childNodes[0]);
            });
            var options = {
                // see color reference http://www.tayloredmktg.com/rgb/
                colors:['4169e1','0000ff','1e90ff', '00bfff'],
                animation: {"startup": true},
                annotations: {
                    alwaysOutside: false, 
                    textStyle: {
                        color: '#000'
                    }
                },
                bar: {groupWidth: "80%"},
                title: 'STAR EARLY LITERACY - SUB-DOMAIN SCORES', 
                hAxis: {
                    title: 'Test Category',
                },
                vAxis: {
                    maxValue: 110, 
                    ticks: [0, 20, 40, 60, 80, 100]
                }
            }
            chart.draw(data, options);

        }
        
    }