<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require_once 'mail/Exception.php';
require_once 'mail/PHPMailer.php';
require_once 'mail/SMTP.php';

class Mail
{
    public static function sendMail($to, $subject, $body)
    {
        $res = '1';
        try {
            if (!self::checkNewLine($body)) {
                $res = '0';
            } else {
                $mail = new PHPMailer();
                $mail->isSMTP();
                $mail->SMTPDebug = SMTP::DEBUG_OFF;
                $mail->CharSet = 'UTF8';
                $mail->Encoding = 'quoted-printable';
                $mail->Host = Config::$MAIL_HOST;
                $mail->Port = Config::$MAIL_PORT;
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
                $mail->SMTPAuth = true;
                $mail->Username = Config::$MAIL_USERADDRESS;
                $mail->Password = Config::$MAIL_USERPASS;
                $mail->setFrom(Config::$MAIL_USERADDRESS, Config::$MAIL_USERNAME);
                $mail->addReplyTo(Config::$MAIL_USERADDRESS, Config::$MAIL_USERNAME);
                $mail->addAddress($to, 'Destinatario');
                $mail->Subject = $subject;
                $mail->msgHTML($body);
    
                if (!$mail->send()) {
                    $res = $mail->ErrorInfo;
                }
            }
        } catch (Exception $e) {
           $res = $e->getMessage();
        }
        return $res;
    }

    private static function checkNewLine($string) {
        if (preg_match("/(%0A|%0D|\\n+|\\r+)/i", $string) != 0) {
            return false;
        }
        return true;
    }
}
