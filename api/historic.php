<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Historic extends API
{
    public function callMethod()
    {
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getHistoric();
                break;
            default:
                $this->response('', 204);
                break;
        }
    }

    public function getHistoric()
    {
        try {
            $authorId = null;
            $days = -1;
            if (isset($_GET['authorId'])) {
                $authorId = $_GET['authorId'];
            }
            if (isset($_GET['days'])) {
                $days = $_GET['days'];
            }
            $request = $this->db->prepare('CALL HistoricData(?,?)');
            $request->bindValue(1, $authorId);
            $request->bindValue(2, $days);
            $request->execute();

            if ($request->rowCount() > 0) {
                $rows = array();

                while ($request->columnCount()) {
                    $rows[] = $request->fetchAll(PDO::FETCH_ASSOC);
                    $request->nextRowset();
                }
                $this->buildResponse($rows[0]);
            }
            return null;
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getHistoric', $e, $this->db);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('getHistoric', $e, $this->db);
            $this->response($message, 500);
        }
    }
}