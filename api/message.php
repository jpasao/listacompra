<?php

class Message
{
    private $token;
    private $url;
    private $topic;
    
    public function __construct()
    {
        $this->token = $this->getToken()->access_token;
        $this->url = 'https://fcm.googleapis.com/v1/projects/listacompra-636c5/messages:send';
        $this->topic = MAIN_TOPIC;
    }

    public function buildMessage($product, $operation, $notificationMessage)
    {
        $data = array(
            'operation' => $operation,
            'productId' => Utils::ensureNotNull($product->id),
            'name' => Utils::ensureNotNull($product->name),
            'quantity' => Utils::ensureNotNull($product->quantity),
            'comment' => Utils::ensureNotNull($product->comment),
            'isChecked' => Utils::ensureNotNull($product->isChecked)
        );

        $notification = array(
            'title' => NOTIFICATION_TITLE,
            'body' => $notificationMessage
        );

        $message = array(
            'topic' => $this->topic,
            'notification' => $notification,
            'data' => $data
        );
        
        $obj = array('message' => $message);
        $this->sendRequest($obj);
    }

    private function sendRequest($data)
    {
        $headers = array(
            "Content-Type: application/json",
            "Authorization: Bearer " . $this->token);

        $jsonData = json_encode($data);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
        curl_exec($ch);
        curl_close($ch);
    }

    private function base64UrlEncode($text)
    {
        return str_replace(
            ['+', '/', '='],
            ['-', '_', ''],
            base64_encode($text)
        );
    }

    private function getToken()
    {
        $authConfigString = file_get_contents(SERVICE_ACCOUNT_PATH);
        $authConfig = json_decode($authConfigString);

        $secret = openssl_get_privatekey($authConfig->private_key);
        $header = json_encode([
            'typ' => 'JWT',
            'alg' => 'RS256'
        ]);

        $time = time();
        $start = $time - 60;
        $end = $time + NOTIFICATION_TTL;

        $payload = json_encode([
            "iss" => $authConfig->client_email,
            "scope" => "https://www.googleapis.com/auth/firebase.messaging",
            "aud" => "https://oauth2.googleapis.com/token",
            "exp" => $end,
            "iat" => $start
        ]);

        $base64UrlHeader = $this->base64UrlEncode($header);
        $base64UrlPayload = $this->base64UrlEncode($payload);

        $result = openssl_sign($base64UrlHeader . "." . $base64UrlPayload, $signature, $secret, OPENSSL_ALGO_SHA256);
        $base64UrlSignature = $this->base64UrlEncode($signature);

        $jwt = $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;

        $options = array('http' => array(
            'method'  => 'POST',
            'content' => 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion='.$jwt,
            'header'  =>
                "Content-Type: application/x-www-form-urlencoded"
        ));
        $context  = stream_context_create($options);
        $responseText = file_get_contents("https://oauth2.googleapis.com/token", false, $context);
        
        return json_decode($responseText);
    }
}
