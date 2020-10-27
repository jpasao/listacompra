<?php

class SendEvent
{
    private const loopInterval = 3;
    private const expirationTime = 7200;
    private const timeLimit = 30;

    public static function sendList($data)
    {
        SendEvent::setHeaders();
        //echo 'event: updateClient' . PHP_EOL;
        echo $data . PHP_EOL;
        echo PHP_EOL;
        
        ob_flush();
        flush();
    }
    
    public static function initialLoad()
    {
        SendEvent::setHeaders();
        ob_end_clean();
        // ob_start();  
        //ob_flush();
        //flush();        
        
        $expTime = time() + SendEvent::expirationTime;

        while (time() < $expTime) {
            SendEvent::performLoop();
            sleep(SendEvent::loopInterval);
        }
    }

    private static function performLoop()
    {
        set_time_limit(SendEvent::timeLimit);

        ob_end_flush();
        flush();
    }

    private static function setHeaders()
	{
        header('Content-Type: text/event-stream');
        // Allow from any origin
        if (isset($_SERVER['HTTP_ORIGIN'])) {
            // Decide if the origin in $_SERVER['HTTP_ORIGIN'] is one
            // you want to allow, and if so:
            header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        }

        // Access-Control headers are received during OPTIONS requests
        if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

            if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
                // may also be using PUT, PATCH, HEAD etc
                header("Access-Control-Allow-Methods: GET, POST, OPTIONS");         

            if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
                header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

            exit(0);
        }        
        header('Cache-Control: no-cache');
    }
    
}
SendEvent::initialLoad();