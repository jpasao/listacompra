<?php

require 'config.php';

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class API extends REST
{
    public $db = null;
    private $endPoints = array('product', 'author', 'meal', 'other', 'system', 'historic');

    public function __construct()
    {
        $this->openDBConnection();
    }

    private function openDBConnection()
    {
        // Set options for PDO
        $options = array(
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
        );
        $dbName = Utils::CheckWhitelist() ? Config::$DB_NAME : Config::$DB_NAME_EMPTY;
        Config::$DB_NAME_CHOSEN = $dbName;
        // Generate DB connection
        $this->db = new PDO(Config::$DB_TYPE .
            ':host=' . Config::$DB_HOST .
            ';dbname=' . $dbName .
            ';charset=' . Config::$DB_CHARSET .
            ';collation=' . Config::$DB_COLLATION,
            Config::$DB_USER,
            Config::$DB_PASS,
            $options
        );
    }

    // Check method name
    public function processApi()
    {
        Config::init();
        $request = trim($_REQUEST['x']);
        $bar = '/';
        $queryWithoutParams = strpos($request, $bar);

        if ($queryWithoutParams === false) {
            $func = strtolower(trim(str_replace($bar, '', $request))); //x parameter from RewriteRule
            $this->checkFunction($func, null);
        } else {
            list($func, $param) = array_filter(explode($bar, $request));
            $this->checkFunction($func, $param);
        }
    }

    private function checkFunction($functionName, $param)
    {
        $found = false;
        foreach ($this->endPoints as $endPoint) {
            if ($endPoint === $functionName) {
                $found = true;
                break;
            }
        }

        if ($found) {
            $this->$functionName($param);
        } else {
            $this->response('', 404);
        }
    }

    private function json($data)
    {
        if (is_array($data)) {
            return json_encode($data);
        }
    }

    protected function buildResponse($data)
    {
        $this->response($this->json($data), 200);
    }

    // Api endpoints
    private function product($filter)
    {
        $products = new Products();
        $products->callMethod($filter);
    }

    private function author()
    {
        $authors = new Authors();
        $authors->callMethod();
    }

    private function meal()
    {
        $meals = new Meals();
        $meals->callMethod();
    }

    private function other()
    {
        $others = new Others();
        $others->callMethod();
    }

    private function system()
    {
        $systems = new Systems();
        $systems->callMethod();
    }

    private function historic()
    {
        $systems = new Historic();
        $systems->callMethod();
    }
}

// Start app
$api = new API;
$api->processApi();