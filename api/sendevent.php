<?php

$db = null;
$lastOperationId = null;

// no normal requests
if (isset($_SERVER['HTTP_ACCEPT']) == false || $_SERVER['HTTP_ACCEPT'] !== 'text/event-stream') {
    return;
} else {
    require_once 'config.php';
    
    openDBConnection();
    $lastOperationId = getValueOperation();
    startEvent();
}

function startEvent()
{
    global $lastOperationId;
    // Disable default disconnect checks
    ignore_user_abort(true);
    
    // Set headers for stream
    header('Content-Type: text/event-stream');
    header('Cache-Control: no-cache');
    header('Access-Control-Allow-Origin: *');
    
    // Set expiration time
    $expTime = time() + EXPIRATION_TIME;

    // Start stream
    while (time() < $expTime) {
        set_time_limit(TIME_LIMIT);

        // Kill process if user disconnects
        if (connection_aborted()) {
            exit();
        } else {    
            // Get operation id
            $latestOperationId = getValueOperation();
    
            if ($lastOperationId != $latestOperationId) {
                $lastOperationId = $latestOperationId;
                $operationData = getOperationData();
                echo 'data: {"authorId":' . $operationData->authorId . ',"productId":' . $operationData->productId . ',"typeId":' . $operationData->typeId . '}';
                echo PHP_EOL . PHP_EOL;   
            }
        }
    
        // Flush buffer
        ob_flush();
        flush();
    
        // Sleeping x seconds
        sleep(LOOP_INTERVAL);
    }
}

// Open db connection
function openDBConnection()
{
    global $db;
    // Set options for PDO
    $options = array(
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ, 
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
    );
    // Generate DB connection
    $db = new PDO(DB_TYPE . ':host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET, DB_USER, DB_PASS, $options);
}

// Get operation id
function getValueOperation()
{
    global $db;
    $sql = "SELECT operationId FROM operations LIMIT 1";
    $query = $db->prepare($sql);                 
    $query->execute(); 
    $idArray = $query->fetchAll();
    return $idArray['0']->operationId;
}

function getOperationData()
{
    global $db;
    $sql = "SELECT operationId, authorId, productId, typeId FROM operations LIMIT 1";
    $query = $db->prepare($sql);                 
    $query->execute(); 
    $idArray = $query->fetchAll();
    return $idArray['0'];
}