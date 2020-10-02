<?php

spl_autoload_register(function($filename) 
{
    require_once strtolower($filename) . '.php';
});

class Tags extends API
{
    public function callMethod()
    {        
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getTags();
                break;
            case 'POST':
                $this->saveTag(true);
                break;                
            case 'PUT':
                $this->saveTag(false);
                break;
            case 'DELETE':
                $this->deleteTag();
                break;
            default:
                $this->response('', 204);
                break;
        }
    }

    public function getTags()
    {
        try {
            $request = $this->db->prepare('CALL TagsData()');
            $request->execute();        
            
            if ($request->rowCount() > 0) {            
                $this->buildResponse($request);             
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getTags', $e);
            $this->response($message, 500);              
        } catch (Exception $e) {
            $message = Utils::buildError('getTags', $e);
            $this->response($message, 500);
        }
    }

    public function saveTag($isPost)
    { 
        try {
            $tagId = Utils::getValue('tagId', $isPost);
            $name = Utils::getValue('name', $isPost);
            $request = $this->db->prepare('CALL TagSave(?, ?)');
            $request->bindParam(1, $tagId);
            $request->bindParam(2, $name);
            $request->execute();
            
            if ($request) {
                $this->response('', 200);     
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveTag', $e);
            $this->response($message, 500);                   
        } catch (Exception $e) {
            $message = Utils::buildError('saveTag', $e);
            $this->response($message, 500);
        }
    }

    public function deleteTag()
    {
        try {
            $tagId = Utils::getValue('tagId', false);
            $request = $this->db->prepare('CALL TagDelete(?)');
            $request->bindParam(1, $tagId);
            $request->execute();
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO deleteTag', $e);
            $this->response($message, 500);                   
        } catch (Exception $e) {
            $message = Utils::buildError('deleteTag', $e);
            $this->response($message, 500);
        }
    }
}