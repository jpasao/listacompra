<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Others extends API
{
    public function callMethod()
    {
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getOthersList();
                break;
            case 'POST':
                $this->saveOther();
                break;
            case 'DELETE':
                $this->deleteOther();
                break;
            default:
            $this->response('', 204);
                break;
        }
    }

    public function getOthersList()
    {
        try {
            $others = [];
            $request = $this->db->prepare('CALL OthersData()');
            $request->execute();

            if ($request->rowCount() > 0) {
                $rows = array();

                while ($request->columnCount()) {
                    $rows[] = $request->fetchAll(PDO::FETCH_ASSOC);
                    $request->nextRowset();
                }
                $others = $rows[0];
            }

            if ($others == null) {
                $defaultResponse = array();
                $this->response(json_encode($defaultResponse), 200);
            } else {
                $this->buildResponse($others);
            }
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getOthersList', $e, $this->db);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('getOthersList', $e, $this->db);
            $this->response($message, 500);
        }
    }

    public function saveOther()
    {
        try {
            $id = Utils::getValue('Id', true);
            $parentId = Utils::getValue('parentId', true);
            $name = Utils::getValue('name', true);
            $check = Utils::getValue('check', true);
            $authorId = Utils::getValue('authorId', true);

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
            $id = (int)$id;

            $request = $this->db->prepare('CALL OthersSave(?, ?, ?, ?)');
            $request->bindParam(1, $id);
            $request->bindParam(2, $parentId);
            $request->bindParam(3, $name);
            $request->bindParam(4, $check);

            $request->execute();

            if ($request) {
                $notification = new Message();
                $notification->buildNoDataMessage($authorId, Config::$OTHER_TOPIC);
                $this->response('', 200);
            }

        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveOther', $e, $this->db);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveOther', $e, $this->db);
            $this->response($message, 500);
        }
    }

    public function deleteOther()
    {
        try {
            $params = Utils::getDELETEValues();
            $otherId = $params[4];
            $authorId = $params[5];
            $sql = "DELETE FROM otherschild WHERE id = :otherId";
            $params = array(':otherId' => $otherId);
            $query = $this->db->prepare($sql);
            $query->execute($params);

            if ($query) {
                $notification = new Message();
                $notification->buildNoDataMessage($authorId, Config::$OTHER_TOPIC);

                $this->getOthersList();
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO deleteOther', $e, $this->db);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('deleteOther', $e, $this->db);
            $this->response($message, 500);
        }
    }
}