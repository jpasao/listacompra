<?php

class Utils
{ 
    public static function buildError($endPoint, $exception)
    {
        return 'Excepción en ' . $endPoint . ': ' . $exception->getMessage();  
    }

    public static function getValue($varName, $isPost)
    {
        $res = null;

        if ($isPost) {
            $arr = $_POST;
        } else {
            parse_str(file_get_contents("php://input"), $_PUT);
            $arr = $_PUT;
        }
        
        if (isset($arr[$varName]) && empty($arr[$varName]) === false) {
            $res = $arr[$varName];
        }
        return $res;
    }

    public static function getJsonContent()
    {
        return json_decode(file_get_contents("php://input"), true);
    } 

    public static function GetLastInsertedId($db)
    {
        $query = $db->query('SELECT LAST_INSERT_ID()');
        return $query->fetchColumn();
    }
}