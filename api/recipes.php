<?php

spl_autoload_register(function($filename)
{
    require_once strtolower($filename) . '.php';
});

class Recipes extends API
{
    public function callMethod($id)
    {        
        switch ($this->get_request_method()) {
            case 'GET':
                if ($id > 0) {
                    $this->getRecipe($id);
                } else {
                    $this->getRecipeList();
                }                
                break;
            case 'POST':                                
            case 'PUT':
                $this->saveRecipe();
                break;
            case 'DELETE':
                $this->deleteRecipe();
                break;                
            default:
                $this->response('', 204);
                break;
        }
    }

    public function getRecipe($recipeId)
    {
        try {
            if ($this->get_request_method() != "GET") {
                $this->response('', 406);
            }
    
            $request = $this->db->prepare("CALL RecipeDetail(?)");
            $request->bindParam(1, $recipeId);
            $request->execute();      
    
            if ($request->rowCount() > 0) { 
                $this->buildResponse($request);                     
            }
            $this->response('', 204);            
        } catch(Exception $e) {
            $message = Utils::buildError('getRecipe', $e);
            $this->response($message, 500);
        }
    }

    public function getRecipeList()
    {
        try {
            $request = $this->db->prepare('CALL RecipeData()');
            $request->execute();        
            
            if ($request->rowCount() > 0) {            
                $this->buildResponse($request);            
            }
            $this->response('', 204);  
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getRecipeList', $e);
            $this->response($message, 500);                        
        } catch (Exception $e) {
            $message = Utils::buildError('getRecipeList', $e);
            $this->response($message, 500);            
        }        
    }

    public function deleteRecipe()
    {
        try {
            $recipeId = Utils::getValue('recipeId', false);
            $request = $this->db->prepare('CALL RecipeDelete(?)');
            $request->bindParam(1, $recipeId);
            $request->execute();
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO deleteRecipe', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('deleteRecipe', $e);
            $this->response($message, 500);
        }
    }    

    public function saveRecipe()
    {
        try {            
            // Content in JSON array format
            $recipeData = Utils::getJsonContent();
            // Create strings with each part
            $tagIds = $this->buildStrings($recipeData, 'E', 'tagId');
            $imageNames = $this->buildStrings($recipeData, 'F', 'name');
            $ingredientIds = $this->buildStrings($recipeData, 'I', 'ingredientId');
            $ingredientNumbers = $this->buildStrings($recipeData, 'I', 'number');
            $ingredientNotes = $this->buildStrings($recipeData, 'I', 'ingredientNote');
            $notes = $this->buildStrings($recipeData, 'N', 'note');
            $steps = $this->buildStrings($recipeData, 'P', 'step');
            
            $recipeId = $recipeData['recipe']['recipeId'];
            $recipeName = $recipeData['recipe']['name'];
            $authorId = $recipeData['recipe']['authorId'];
            $difficultyId = $recipeData['recipe']['difficultyId'];
            $preparationMinutes = $recipeData['recipe']['preparationMinutes'];
            
            $request = $this->db->prepare('CALL RecipeSave(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
            $request->bindParam(1, $tagIds);
            $request->bindParam(2, $imageNames);
            $request->bindParam(3, $ingredientIds);
            $request->bindParam(4, $ingredientNumbers);
            $request->bindParam(5, $ingredientNotes);
            $request->bindParam(6, $notes);
            $request->bindParam(7, $steps);
            $request->bindParam(8, $recipeName);
            $request->bindParam(9, $authorId);
            $request->bindParam(10, $recipeId);
            $request->bindParam(11, $difficultyId);
            $request->bindParam(12, $preparationMinutes);
            $request->execute();

            if ($request) {
                $this->response('', 200);
            }
            $this->response('', 204);            
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveRecipe', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveRecipe', $e);
            $this->response($message, 500);
        }
    }

    private function buildStrings($recipeData, $area, $subArea)
    {
        $arr = array();

        switch ($area) {
            case 'E':
                $arr = $recipeData['tags'];                
                break;
            case 'I':
                $arr = $recipeData['ingredients'];                
                break;   
            case 'P':
                $arr = $recipeData['steps'];                
                break; 
            case 'N':
                $arr = $recipeData['notes'];                
                break;      
            case 'F':
                $arr = $recipeData['images'];                
                break;                                                               
        }   
        return $this->processObject($arr, $subArea);     
    }

    private function processObject($arr, $subArea)
    {
        $sep = '¬';
        $dataString = '';
        
        array_walk_recursive($arr, function($value, $key) use(&$dataString, &$sep, &$subArea){
            if ($key == $subArea){
                $dataString = $dataString . $value . $sep;
            }            
        });

        return $dataString;
    }
}