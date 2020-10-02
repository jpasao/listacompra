<?php

spl_autoload_register(function($filename)
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
                $this->markProduct();
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
            if ($filter == null) $filter = '';

            $sql = "SELECT ingredientId AS id, name, isChecked FROM ingredients WHERE isProduct = 1 AND LOWER(name) LIKE CONCAT('%', :filter, '%') ORDER BY isChecked, name";
            
            $query = $this->db->prepare($sql);      
            $params = array(':filter' => $filter);      
            $query->execute($params);  
        } catch (Exception $e) {
            $message = Utils::buildError('getRows', $e);
            $this->response($message, 500);   
        }
        return $query;
    }

    // Creates or updates a product name
    public function saveProduct($isPost)
    {
        $sql;
        try {
            $name = Utils::getValue('name', $isPost);
            if ($isPost){
                $sql = "INSERT INTO ingredients (name, isProduct, isChecked) VALUES (:name, 1, 0)";
                $params = array(':name' => $name); 
            } else {
                $productId = Utils::getValue('productId', $isPost);
                $sql = "UPDATE ingredients SET name = :name WHERE ingredientId = :productId";
                $params = array(':name' => $name, ':productId' => $productId); 
            }
            $query = $this->db->prepare($sql);
            $query->execute($params);
            if ($query) {
                $this->response('', 200);
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
    public function markProduct()
    {        
        try {
            $data = Utils::getJsonContent();

            $sql = "UPDATE ingredients SET isChecked = :check WHERE ingredientId = :productId";
            $params = array(':check' => $data['isChecked'], ':productId' => $data['productId']); 
            $query = $this->db->prepare($sql);
            $query->execute($params);
            $sentEvent = false;
            if ($query) {
                $productList = $this->getRows(null);
                if ($productList->rowCount() > 0) {  
                    $jsonData = json_encode($productList->fetchAll());          
                    SendEvent::sendList($jsonData);   
                    $sentEvent = true;         
                }
                if ($sentEvent == false) $this->response('', 200);
            }            
            if ($sentEvent == false) $this->response('', 204);  
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO markProduct', $e);
            $this->response($message, 500);                        
        } catch (Exception $e) {
            $message = Utils::buildError('markProduct', $e);
            $this->response($message, 500);            
        }
    }
}