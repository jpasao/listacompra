<?php

class Config
{
	public static $HTTP_HOST;
	public static $SCRIPT_NAME;
	public static $URL;
	public static $URL_SUB_FOLDER;
	public static $ROOT;
	public static $IMG_DIR;
	public static function init()
	{
		if (self::$ENVIRONMENT == 'development' || self::$ENVIRONMENT == 'dev') {
			error_reporting(E_ALL);
			ini_set("display_errors", 1);
		}
		self::$HTTP_HOST = $_SERVER['HTTP_HOST'];
		self::$SCRIPT_NAME = $_SERVER['SCRIPT_NAME'];
		self::$URL = self::$URL_PROTOCOL . self::$HTTP_HOST . self::$URL_SUB_FOLDER;
		self::$URL_SUB_FOLDER = str_replace(self::$URL_PUBLIC_FOLDER, '', dirname(self::$SCRIPT_NAME));
		self::$ROOT = dirname(__DIR__) . DIRECTORY_SEPARATOR;
		$IMG_DIR = self::$ROOT . 'images';
	}
	
	public static $ENVIRONMENT = 'development';
	
	// App constants
	public static $URL_PUBLIC_FOLDER = 'public';
	public static $URL_PROTOCOL = 'http://';
	public static $MAX_IMAGE_SIZE = 2 * 1024 * 1024;
	public static $WHITELIST_PATH = '***';
	public static $INSTALLATION_ID_HEADER = 'INSTALLATIONID';

	// DB Constants
	public static $DB_TYPE = 'mysql';
	public static $DB_HOST = 'localhost';
	public static $DB_NAME = '***';
	public static $DB_NAME_EMPTY = '***';
	public static $DB_USER = '***';
	public static $DB_PASS = '***';
	public static $DB_CHARSET = 'utf8mb4';
	public static $DB_COLLATION = 'utf8mb4_unicode_ci';

	// Message Constants
	public static $MAIN_TOPIC = 'MAIN_TOPIC';
	public static $MEAL_TOPIC = 'MEAL_TOPIC';
	public static $OTHER_TOPIC = 'OTHER_TOPIC';
	public static $NOTIFICATION_TITLE = 'ListaDLC';
	public static $NOTIFICATION_MESSAGE = "Alguien ha xxx en la lista de la compra. Echa un vistazo.";
	public static $NOTIFICATION_TTL = 3600;
	public static $SERVICE_ACCOUNT_PATH = '***';
	public static $FIREBASE_PROJECT_URL = '***';
	public static $FIREBASE_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';
	public static $FIREBASE_TOKEN = 'https://oauth2.googleapis.com/token';

	// Mail Constants
	public static $MAIL_FROM = '***';
	public static $MAIL_TO = '***';
	public static $MAIL_LOCAL_SUBJECT = 'Ha ocurrido un error en el api';
	public static $MAIL_APP_SUBJECT = 'Ha ocurrido un error en la app';
}
