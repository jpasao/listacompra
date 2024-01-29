<?php

class Utils
{
    private static $phpInput = 'php://input';

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
            parse_str(file_get_contents(self::$phpInput), $_PUT);
            $arr = $_PUT;
        }
        
        if (isset($arr[$varName]) && empty($arr[$varName]) === false) {
            $res = $arr[$varName];
        }
        return $res;
    }

    public static function getPATCHValue($varName)
    {
        $res = null;

        parse_str(file_get_contents(self::$phpInput), $_PATCH);
        
        if (isset($_PATCH[$varName]) && empty($_PATCH[$varName]) === false) {
            $res = $_PATCH[$varName];
        }
        return $res;
    }

    public static function getDELETEValues()
    {
        $url = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
        $path = parse_url($url, PHP_URL_PATH);

        return explode('/', $path);
    }

    public static function getJsonContent()
    {
        return json_decode(file_get_contents(self::$phpInput), true);
    }

    public static function getLastInsertedId($db)
    {
        $query = $db->query('SELECT LAST_INSERT_ID()');
        return $query->fetchColumn();
    }

    public static function ensureNotNull($str)
    {
        $res = $str;
        if (strlen($str) == 0) {
            $res = '';
        }
        return $res;
    }

    public static function checkWhitelist()
    {
        $whiteListFile = file_get_contents(Config::$WHITELIST_PATH);
        $whiteList = json_decode($whiteListFile);

        $headers = getallheaders();

        $installationIdHeader = $headers[Config::$INSTALLATION_ID_HEADER];
        return in_array($installationIdHeader, $whiteList->devices);
    }

    public static function uploadImage()
    {
        // TBD
        return true;
    }
}
