<?php

spl_autoload_register(function($filename)
{
    require_once strtolower($filename) . '.php';
});

class Ingredients extends API
{
    public function callMethod()
    {        
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getIngredients();
                break;
            case 'POST':
                $this->saveIngredient(true);
                break;
            case 'PUT':
                $this->saveIngredient(false);
                break;
            case 'DELETE':
                $this->deleteIngredient();
                break;
            default:
                $this->response('', 204);
                break;
        }
    }

    public function getIngredients()
    {
        try {
            $request = $this->db->prepare('CALL IngredientsData()');
            $request->execute();        
            
            if ($request->rowCount() > 0) {            
                $this->buildResponse($request);            
            }
            $this->response('', 204);  
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getIngredients', $e);
            $this->response($message, 500);                        
        } catch (Exception $e) {
            $message = Utils::buildError('getIngredients', $e);
            $this->response($message, 500);            
        }
    }

    public function saveIngredient($isPost) 
    {
        try {
            $ingredientId = Utils::getValue('ingredientId', $isPost);
            $name = Utils::getValue('name', $isPost);
            $request = $this->db->prepare('CALL IngredientSave(?, ?)');
            $request->bindParam(1, $ingredientId);
            $request->bindParam(2, $name);
            $request->execute();

            if ($request) {
                $this->response('', 200);
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveIngredient', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveIngredient', $e);
            $this->response($message, 500);
        }
    }

    public function deleteIngredient()
    {
        try {
            $ingredientId = Utils::getValue('ingredientId', false);
            $request = $this->db->prepare('CALL IngredientDelete(?)');
            $request->bindParam(1, $ingredientId);
            $request->execute();
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO deleteIngredient', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('deleteIngredient', $e);
            $this->response($message, 500);
        }
    }
}