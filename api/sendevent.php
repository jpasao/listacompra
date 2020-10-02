<?php

class SendEvent
{
    public static function sendList($data)
    {
        SendEvent::initialLoad();
        //echo 'event: updateClient' . PHP_EOL;
        echo $data . PHP_EOL;
        echo PHP_EOL;
        
        ob_flush();
        flush();
    }
    
    private static function initialLoad()
    {
        SendEvent::set_headers();
        ob_end_flush();
        ob_start();        
    }

    private static function set_headers()
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