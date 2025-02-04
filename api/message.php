<?php

class Message extends API
{
    private $token;

    public function __construct()
    {
        $this->token = $this->getToken()->access_token;
    }

    public function buildDataMessage($object, $operation, $notificationMessage, $db, $originalData = '')
    {
        $data = $this->getMessageData($object, $operation);
        $additionaldata['firebaseSent'] = 0;
        $additionaldata['remoteAddr'] = $_SERVER['REMOTE_ADDR'];
        $additionaldata['originalData'] = $originalData;
        $additionaldata['id'] = 0;
        $additionaldata['id'] = $this->logOperation($data, $additionaldata, $db);

        $notification = array(
            'title' => Config::$NOTIFICATION_TITLE,
            'body' => $notificationMessage
        );

        $message = array(
            'topic' => Config::$MAIN_TOPIC,
            'notification' => $notification,
            'data' => $data
        );

        $obj = array('message' => $message);
        $additionaldata['firebaseSent'] = $this->sendRequest($obj) ? 1 : 0;
        $this->logOperation($data, $additionaldata, $db);
    }

    public function buildNoDataMessage($authorId, $topic)
    {
        $notification = array(
            'title' => Config::$NOTIFICATION_TITLE,
            'body' => $authorId
        );

        $message = array(
            'topic' => $topic,
            'notification' => $notification
        );

        $obj = array('message' => $message);
        $this->sendRequest($obj);
    }

    private function getMessageData($product, $operation) {
        return array(
            'operation' => $operation,
            'productId' => Utils::ensureNotNull($product->id),
            'name' => Utils::ensureNotNull($product->name),
            'quantity' => Utils::ensureNotNull($product->quantity),
            'comment' => Utils::ensureNotNull($product->comment),
            'isChecked' => Utils::ensureNotNull($product->isChecked),
            'user' => Utils::ensureNotNull($product->user)
        );
    }

    private function logOperation($data, $additionalData, $db) {
        try {
            $id = $additionalData['id'];
            $user = strlen($data['user'] ?? '') != 0 ? $data['user'] : 6; // Default user
            $productId = $data['productId'];
            $name = $data['name'];
            $code = $this->getOperationCode($data['operation']);
            $firebaseSent = $additionalData['firebaseSent'];
            $remoteAddr = $additionalData['remoteAddr'];
            $originalData = $additionalData['originalData'];

            $request = $db->prepare('CALL HistoricSave(?, ?, ?, ?, ?, ?, ?, ?)');
            $request->bindParam(1, $id);
            $request->bindParam(2, $user);
            $request->bindParam(3, $productId);
            $request->bindParam(4, $name);
            $request->bindParam(5, $code);
            $request->bindParam(6, $firebaseSent);
            $request->bindParam(7, $remoteAddr);
            $request->bindParam(8, $originalData);
     
            $request->execute();
            return Utils::getLastInsertedId($db);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO logOperation', $e, $db);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('logOperation', $e, $db);
            $this->response($message, 500);
        }
    }

    private function getOperationCode($operation) {
        // operationId meanings: 1->create, 2->update, 3->check, 4->uncheck, 5->delete
        // operations: POST->1, PUT->2, PATCH1->3, PATCH0->4, DELETE->5
        $code = 0;
        switch ($operation) {
            case 'POST': $code = 1; break;
            case 'PUT': $code = 2; break;
            case 'PATCH0': $code = 3; break; 
            case 'PATCH1': $code = 4; break;
            case 'DELETE': $code = 5; break;
            default: break;
        }
        return $code;
    }

    private function sendRequest($data)
    {
        $return = new stdClass;
        $response = false;
        $headers = array(
            "Content-Type: application/json",
            "Authorization: Bearer " . $this->token);

        $jsonData = json_encode($data);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, Config::$FIREBASE_PROJECT_URL);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
        $return->response = curl_exec($ch);
        if ($return->response) {
            $response = true;
        }
        curl_close($ch);
        return $response;
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
        $authConfigString = file_get_contents(Config::$SERVICE_ACCOUNT_PATH);
        $authConfig = json_decode($authConfigString);

        $secret = openssl_get_privatekey($authConfig->private_key);
        $header = json_encode([
            'typ' => 'JWT',
            'alg' => 'RS256'
        ]);

        $time = time();
        $start = $time - 60;
        $end = $time + Config::$NOTIFICATION_TTL;

        $payload = json_encode([
            "iss" => $authConfig->client_email,
            "scope" => Config::$FIREBASE_SCOPE,
            "aud" => Config::$FIREBASE_TOKEN,
            "exp" => $end,
            "iat" => $start
        ]);

        $base64UrlHeader = $this->base64UrlEncode($header);
        $base64UrlPayload = $this->base64UrlEncode($payload);

        openssl_sign($base64UrlHeader . "." . $base64UrlPayload, $signature, $secret, OPENSSL_ALGO_SHA256);
        $base64UrlSignature = $this->base64UrlEncode($signature);

        $jwt = $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;

        $options = array('http' => array(
            'method'  => 'POST',
            'content' => 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=' . $jwt,
            'header'  => "Content-Type: application/x-www-form-urlencoded"
        ));
        $context  = stream_context_create($options);
        $responseText = file_get_contents(Config::$FIREBASE_TOKEN, false, $context);

        return json_decode($responseText);
    }
}

