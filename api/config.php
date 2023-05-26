<?php

define('ENVIRONMENT', 'development');

if (ENVIRONMENT == 'development' || ENVIRONMENT == 'dev') {
	error_reporting(E_ALL);
	ini_set("display_errors", 1);
}
// App constants
define('URL_PUBLIC_FOLDER', 'public');
define('URL_PROTOCOL', 'http://');
define('URL_DOMAIN', $_SERVER['HTTP_HOST']);
define('URL_SUB_FOLDER', str_replace(URL_PUBLIC_FOLDER, '', dirname($_SERVER['SCRIPT_NAME'])));
define('URL', URL_PROTOCOL . URL_DOMAIN . URL_SUB_FOLDER);
define('ROOT', dirname(__DIR__) . DIRECTORY_SEPARATOR);

// DB Constants
define('DB_TYPE', 'mysql');
define('DB_HOST', 'localhost');
define('DB_NAME', 'recetas');
define('DB_USER', 'invitado');
define('DB_PASS', 'invitado');
define('DB_CHARSET', 'utf8');

// Message Constants
define('MAIN_TOPIC', 'MAIN_TOPIC');
define('NOTIFICATION_TITLE', 'ListaDLC');
define('NOTIFICATION_MESSAGE', 'Alguien ha añadido algo a la lista de la compra. Echa un vistazo.');
define('NOTIFICATION_TTL', 3600);
define('SERVICE_ACCOUNT_PATH', '/var/listacompra-636c5-firebase-adminsdk-yakfo-15eb2ba912.json');


