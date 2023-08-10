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
                $this->getMeals();
                break;
            case 'PATCH':
                $this->checkMeal();
                break;
                case 'POST':
                    $this->saveMeal(true);
                    break;
                case 'PUT':
                    $this->saveMeal(false);
                    break;
            default:
            $this->response('', 204);
                break;
        }
    }

    public function getMeals()
    {
        try {
            $isAllowed = Utils::CheckWhitelist();
            if($isAllowed) {
                $mealId = null;
                if (isset($_GET['mealId'])) {
                    $mealId = $_GET['mealId'];
                }
                
                if ($mealId == null) {
                    $this->getMealList();
                } else {
                    $this->getMealData($mealId);
                }
            } else {
                $this->response('', 401);
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
            $this->response('', 204);
        } else {
            $this->buildResponse($meals);
        }
    }
    
    public function saveMeal($isPost)
    {
        $sql = '';
        try {
            $name = Utils::getValue('name', $isPost);
            $isLunch = Utils::getValue('isLunch', $isPost);
            $isLunch = $isLunch == 2 ? 0 : 1;
            $mealId = -1;
            if ($isPost) {
                $sql = 'INSERT INTO meals (name, isLunch, isChecked) VALUES (:name, :isLunch, 1)';
                $params = array(':name' => $name, ':isLunch' => $isLunch);
            } else {
                $mealId = Utils::getValue('mealId', $isPost);
                $params = array(':name' => $name, ':isLunch' => $isLunch, ':mealId' => $mealId);
                $sql = 'UPDATE meals SET name = :name, isLunch = :isLunch WHERE mealId = :mealId';
            }
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
            $mealId = Utils::getValue('mealId', false);
            $check = Utils::getPATCHValue('check');
            if ($check == null) {
                $check = 1;
            } else {
                $check = (int)$check;
                if ($check == 1) {
                    $check = 0;
                } else {
                    $check = 1;
                }
            }
            $mealId = (int)$mealId;

            $sql = "UPDATE meals SET isChecked = :check WHERE mealId = :mealId";
            $params = array(':check' => $check, ':mealId' => $mealId);
            $query = $this->db->prepare($sql);
            $query->execute($params);

            if ($query) {
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