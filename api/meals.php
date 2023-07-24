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
            default:
            $this->response('', 204);
                break;
        }
    }

    public function getMeals()
    {
        try {
            $mealId = null;
            if (isset($_GET['mealId'])) {
                $mealId = $_GET['authorId'];
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
            $this->response('', 204);
        } else {
            $this->buildResponse($meals);
        }
    }
}