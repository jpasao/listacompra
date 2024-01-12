<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Meals extends API
{
    public function callMethod()
    {
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getMealsOrIngredients();
                break;
            case 'PATCH':
                $this->checkMeal();
                break;
            case 'POST':
                $this->saveMeal(true);
                break;
            case 'PUT':
                $this->saveMealOrIngredients();
                break;
            default:
            $this->response('', 204);
                break;
        }
    }

    public function getMealsOrIngredients()
    {
        try {
            $mealId = null;
            if (isset($_GET['mealId'])) {
                $mealId = $_GET['mealId'];
            }
            
            if ($mealId == null) {
                $this->getMealList();
            } else {
                $this->getMealData($mealId);
            }
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getMeals', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('getMeals', $e);
            $this->response($message, 500);
        }
    }

    public function getMealData($mealId)
    {
        $mealData = [];
        $request = $this->db->prepare('CALL MealIngredientsData(?)');
        $request->bindValue(1, $mealId);
        $request->execute();

        if ($request->rowCount() > 0) {
            $rows = array();

            while ($request->columnCount()) {
                $rows[] = $request->fetchAll(PDO::FETCH_ASSOC);
                $request->nextRowset();
            }
            $mealData = $rows[0];
        }

        if ($mealData == null) {
            $this->response('', 204);
        } else {
            $this->buildResponse($mealData);
        }
    }

    public function getMealList()
    {
        $meals = [];
        $request = $this->db->prepare('CALL MealData()');

        $request->execute();
        
        if ($request->rowCount() > 0) {
            $rows = array();

            while ($request->columnCount()) {
                $rows[] = $request->fetchAll(PDO::FETCH_ASSOC);
                $request->nextRowset();
            }
            $meals = $rows[0];
        }

        if ($meals == null) {
            $defaultResponse = array();
            $this->response(json_encode($defaultResponse), 200);
        } else {
            $this->buildResponse($meals);
        }
    }

    public function saveMealOrIngredients()
    {
        try {
            $ingredients = Utils::getValue('ingredients', false);
            if (isset($ingredients)) {
                $this->saveIngredients($ingredients);
            } else {
                $this->saveMeal(false);
            }
        } catch (Exception $e) {
            $message = Utils::buildError('saveMealOrIngredients', $e);
            $this->response($message, 500);
        }
    }

    public function saveIngredients($ingredients)
    {
        $sql = '';
        $values = array();
        try {
            $mealId = Utils::getValue('mealId', false);
            $deleteOk = $this->deleteIngredients($mealId);

            if ($deleteOk) {
                $str_arr = preg_split ("/\,/", $ingredients);
                foreach($str_arr as $row) {
                    $values[] = '(' . $mealId . ', '. $row . ')';
                }
                $sql = 'INSERT INTO mealingredients (mealId, ingredientId) VALUES ' . implode(', ', $values);
                $query = $this->db->prepare($sql);
                $query->execute();
                if ($query) {
                    $this->getMealData($mealId);
                }
                $this->response('Ha fallado la inserción de los ingredientes de la comida', 500);
            } else {
                $this->response('Hubo un error al borrar los ingredientes antes de insertar los nuevos. No se ha realizado la inserción', 500);
            }
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveIngredients', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveIngredients', $e);
            $this->response($message, 500);
        }
    }

    public function deleteIngredients($mealId)
    {
        $sql = '';
        try {
            $sql = 'DELETE FROM mealingredients WHERE mealId = :mealId';
            $params = array(':mealId' => $mealId);
            
            $query = $this->db->prepare($sql);
            $query->execute($params);
            return $query;
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO deleteIngredients', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('deleteIngredients', $e);
            $this->response($message, 500);
        }
    }
    
    public function saveMeal($isPost)
    {
        $sql = '';
        try {
            $authorId = Utils::getValue('authorId', $isPost);
            $name = Utils::getValue('name', $isPost);
            $isLunch = Utils::getValue('isLunch', $isPost);
            $isLunch = $isLunch == 2 ? 0 : 1;
            $mealId = -1;

            $notification = new Message();

            if ($isPost) {
                $sql = 'INSERT INTO meals (name, isLunch, isChecked) VALUES (:name, :isLunch, 0)';
                $params = array(':name' => $name, ':isLunch' => $isLunch);
            } else {
                $mealId = Utils::getValue('mealId', $isPost);
                $params = array(':name' => $name, ':isLunch' => $isLunch, ':mealId' => $mealId);
                $sql = 'UPDATE meals SET name = :name, isLunch = :isLunch WHERE mealId = :mealId';
            }
            $notification->buildMessageByType(Config::$MEAL_TOPIC, $authorId, '', '');
            
            $query = $this->db->prepare($sql);
            $query->execute($params);
            if ($query) {
                $response = array(
                    'mealId' => $mealId,
                    'name' => $name,
                    'isLunch' => $isLunch);

                $res = json_encode($response);
                $this->response($res, 200);
            }
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveMeal', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveMeal', $e);
            $this->response($message, 500);
        }
    }

    public function checkMeal()
    {
        try {
            $authorId = Utils::getValue('authorId', false);
            $mealId = Utils::getValue('mealId', false);
            $check = Utils::getPATCHValue('check');
            $isLunch = Utils::getValue('isLunch', false);
            $oldRequest = $isLunch == null;
            $isLunch = $isLunch == 2 ? 1 : 0;

            if ($check == null) {
                $check = 1;
            } else {
                $check = (int)$check;
                $check--;
                if ($check == 1) {
                    $check = 0;
                } else {
                    $check = 1;
                }
            }
            $mealId = (int)$mealId;

            if ($oldRequest){
                $sql = "UPDATE meals SET isChecked = :check WHERE mealId = :mealId";
                $params = array(':check' => $check, ':mealId' => $mealId);
            } else {
                $sql = "UPDATE meals SET isChecked = :check, isLunch = :isLunch WHERE mealId = :mealId";
                $params = array(':check' => $check, ':isLunch' => $isLunch, ':mealId' => $mealId);
            }
            $query = $this->db->prepare($sql);
            $query->execute($params);

            if ($query) {
                $notification = new Message();
                $notification->buildMessageByType(Config::$MEAL_TOPIC, $authorId, '', '');
                $this->getMealList();
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO checkMeal', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('checkMeal', $e);
            $this->response($message, 500);
        }
    }
}