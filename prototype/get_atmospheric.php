<?php
    $conn = new mysqli("10.254.254.101", "monitor", "monitor", "GRC_B50_ATMOSPHERIC");
    if ($conn->connect_error) {
        die("ERROR: Unable to connect: " . $conn->connect_error);
    } 
    
    if (!$result = $conn->query("SELECT TIME(datetime) as time, temperature FROM DHT11 WHERE DATE(datetime) = CURDATE() AND TIME(datetime) > DATE_SUB(CURTIME(), INTERVAL 30 MINUTE) ORDER BY datetime ASC")) {
        die ('There was an error running query[' . $connection->error . ']');
    }
    
    while ($row = $result->fetch_assoc()) {
        echo 'data.addRow(["'.$row["time"].'",'.$row["temperature"].']);'."\r\n";
    }
    
    $result->close();
    $conn->close();
?>
