<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <title>B50 Temperature Tracking</title>
        <link rel="stylesheet" type="text/css" href="css/style.css" media="screen" />
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script
			  src="https://code.jquery.com/jquery-3.4.1.min.js"
			  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
			  crossorigin="anonymous"></script>
        <script type="text/javascript">
            google.charts.load('current', {packages: ['corechart', 'line']});
            google.charts.setOnLoadCallback(drawBasic);
            var newData;
            function drawBasic() {
                $.get("get_atmospheric.php", "", function(newData) {
                    var data = new google.visualization.DataTable();
                    data.addColumn('string', 'X');
                    data.addColumn('number', 'Temperature (°C)');
                    eval(newData);
                    
                    var options = {
                        chartArea: {
                            top: 20,
                            height: '75%'
                        },
                        legend: {position:'top'},
                        hAxis: {
                            title: 'Time'
                        },
                        vAxis: {
                            title: 'Temperature (°C)'
                        }
                    };
                    
                    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                    chart.draw(data, options);
                });
            }
            
            window.setInterval(drawBasic, 5000);
        </script>
    </head>

    <body>
        <div id="wrap">
        <div id="chart_div" style="height:500px;"></div>
        </div>
    </body>
</html>
