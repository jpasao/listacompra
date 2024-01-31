<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Systems extends API
{
    public function callMethod()
    {
        switch ($this->get_request_method()) {
            case 'POST':
                $this->sendErrorMail();
                break;
            default:
            $this->response('', 204);
                break;
        }
    }

    public function sendErrorMail()
    {
        $to = Config::$MAIL_TO;
        $point = Utils::getValue('point', true);
        $message = Utils::getValue('message', true);

        $subject = Config::$MAIL_APP_SUBJECT . ': ' . $point;
        Utils::sendSimpleMail($to, $subject, $message, $this->db);
    }
}