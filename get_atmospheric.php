<?php
    $conn = new mysqli("10.254.254.101", "monitor", "monitor", "GRC_B50_ATMOSPHERIC");
    if ($conn->connect_error) {
        die("ERROR: Unable to connect: " . $conn->connect_error);
    } 
    
    if (!$result = $conn->query("SELECT * FROM DHT11 WHERE date(datetime) = CURDATE() ORDER BY datetime ASC LIMIT 10000")) {
        die ('There was an error running query[' . $connection->error . ']');
    }
    
    while ($row = $result->fetch_assoc()) {
        echo 'data.addRow(["'.$row["datetime"].'",'.$row["temperature"].']);'."\r\n";
    }
    
    $result->close();
    $conn->close();
?>
