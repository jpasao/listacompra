<?php

class REST 
{
	
	public $allow = array();
	public $content_type = 'application/json';
	public $request = array();
	private $code = 200;
	
	public function __construct()
	{
		$this->inputs();
	}
	
	public function get_referer()
	{
		return $_SERVER['HTTP_REFERER'];
	}
	
	public function response($data, $status)
	{
		$this->code = ($status) ? $status : 200;
		$this->set_headers();
		echo $data;
		exit;
	}
	
	private function get_status_message()
	{
		$status = array(
					200 => 'OK',
					201 => 'Created',
					204 => 'No Content',
					404 => 'Not Found',
					406 => 'Not Acceptable',
					500 => 'Server Error');

		return ($status[$this->code]) ? $status[$this->code] : $status[500];
	}
	
	public function get_request_method()
	{
		return $_SERVER['REQUEST_METHOD'];
	}
	
	private function inputs()
	{
		switch ($this->get_request_method()) {
			case 'POST':
				$this->request = $this->cleanInputs($_POST);
				break;
			case 'GET':
			case 'DELETE':
				$this->request = $this->cleanInputs($_GET);
				break;
			case 'PUT':
				parse_str(file_get_contents('php://input'), $this->request);
				$this->request = $this->cleanInputs($this->request);
				break;
			default:
				$this->response('', 406);
				break;
		}
	}

	private function cleanInputs($data)
	{
		$clean_input = array();
		if (is_array($data)) {
			foreach ($data as $k => $v) {
				$clean_input[$k] = $this->cleanInputs($v);
			}
		} else {
			if (get_magic_quotes_gpc()) {
				$data = trim(stripslashes($data));
			}
			$data = strip_tags($data);
			$clean_input = trim($data);
		}
		return $clean_input;
	}
	
	private function set_headers()
	{
		header('HTTP/1.1 ' . $this->code . ' ' . $this->get_status_message());
		header('Content-Type:' . $this->content_type);
		header('Access-Control-Allow-Origin: *');
		header("Access-Control-Allow-Headers: X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method");
		header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE, PATCH");
		header("Allow: GET, POST, OPTIONS, PUT, DELETE, PATCH");
	}
}