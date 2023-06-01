<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Products extends API
{
    public function callMethod($filter)
    {
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getProducts($filter);
                break;
            case 'POST':
                $this->saveProduct(true);
                break;
            case 'PUT':
                $this->saveProduct(false);
                break;
            case 'PATCH':
                $this->checkProduct();
                break;
            default:
                $this->response('', 204);
                break;
        }
    }

    // Get products filtered by name
    public function getProducts($filter)
    {
        try {
            $query = $this->getRows($filter);
            
            if ($query->rowCount() > 0) {
                $this->buildResponse($query->fetchAll());
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getProducts', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('getProducts', $e);
            $this->response($message, 500);
        }
    }

    private function getRows($filter)
    {
        try {
            // Empty query throws exception
            if ($filter == null) { $filter = ''; }

            $sql = "SELECT ingredientId AS id, name, isChecked, quantity, comment FROM ingredients WHERE isProduct = 1 AND LOWER(name) LIKE CONCAT('%', :filter, '%') ORDER BY isChecked, name";
            
            $query = $this->db->prepare($sql);
            $params = array(':filter' => $filter);
            $query->execute($params);
        } catch (Exception $e) {
            $message = Utils::buildError('getRows', $e);
            $this->response($message, 500);
        }
        return $query;
    }

    // Creates or updates a product
    public function saveProduct($isPost)
    {
        $sql = '';
        try {
            $name = Utils::getValue('name', $isPost);
            $authorId = Utils::getValue('authorId', $isPost);
            $quantity = Utils::getValue('quantity', $isPost);
            $comment = Utils::getValue('comment', $isPost);
            $productId = -1;
            if ($isPost) {
                $sql = "INSERT INTO ingredients (name, isProduct, isChecked, quantity, comment) VALUES (:name, 1, 0, :quantity, :comment)";
                $params = array(':name' => $name, ':quantity' => $quantity, ':comment' => $comment);
            } else {
                $productId = Utils::getValue('productId', $isPost);
                $sql = "UPDATE ingredients SET name = :name, quantity = :quantity, comment = :comment WHERE ingredientId = :productId";
                $params = array(
                    ':name' => $name,
                    ':productId' => $productId,
                    ':quantity' => $quantity,
                    ':comment' => $comment);
            }
            $query = $this->db->prepare($sql);
            $query->execute($params);
            if ($query) {
                  $response = array(
                    'id' => $productId,
                    'name' => $name,
                    'quantity' => $quantity,
                    'comment' => $comment);

                $notification = new Message();
                $notificationOperation = "añadido algo";
                if ($isPost) {
                    $product = array('id' => '', 'name' => '', 'quantity' => '', 'comment' => '');
                    $notificationMessage = str_replace("xxx", $notificationOperation, NOTIFICATION_MESSAGE);
                    $notification->buildMessage($product, 'POST', $notificationMessage);
                } else {
                    $product = $this->getProduct($productId);
                    $notificationOperation = "modificado " . $product->name;
                    $notificationMessage = str_replace("xxx", $notificationOperation, NOTIFICATION_MESSAGE);
                    $notification->buildMessage($product, 'PUT', $notificationMessage);
                }

                $res = json_encode($response);
                $this->response($res, 200);
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveProduct', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveProduct', $e);
            $this->response($message, 500);
        }
    }

    // Checks or unckecks a product
    public function checkProduct()
    {
        try {
            $productId = Utils::getValue('productId', false);
            $check = Utils::getPATCHValue('check');
            $notificationOperation = "marcado ";
            if ($check == null) {
                $check = "1";
            } else {
                $check = "0";
                $notificationOperation = "desmarcado ";
            }            
            
            $sql = "UPDATE ingredients SET isChecked = :check, quantity = 1 WHERE ingredientId = :productId";
            $params = array(':check' => $check, ':productId' => $productId);
            $query = $this->db->prepare($sql);
            $query->execute($params);
            
            if ($query) {
                $product = $this->getProduct($productId);
                $notificationOperation = $notificationOperation . $product->name;
                $notificationMessage = str_replace("xxx", $notificationOperation, NOTIFICATION_MESSAGE);
                $notification = new Message();
                $notification->buildMessage($product, 'PATCH', $notificationMessage);
                $this->getProducts('');
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO checkProduct', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('checkProduct', $e);
            $this->response($message, 500);
        }
    }

    private function getProduct($productId)
    {
        try {
            $sql = "SELECT ingredientId AS id, name, isChecked, quantity, comment FROM ingredients WHERE ingredientId = :productId";
            
            $query = $this->db->prepare($sql);
            $params = array(':productId' => $productId);
            $query->execute($params);
            $row = $query->fetch();
        } catch (Exception $e) {
            $message = Utils::buildError('getProduct', $e);
            $this->response($message, 500);
        }
        return $row;
    }
}