<?php

spl_autoload_register(function ($filename)
{
    require_once strtolower($filename) . '.php';
});

class Authors extends API
{
    public function callMethod()
    {
        switch ($this->get_request_method()) {
            case 'GET':
                $this->getAuthors();
                break;
            case 'POST':
                $this->saveAuthor(true);
                break;
            case 'PUT':
                $this->saveAuthor(false);
                break;
            case 'DELETE':
                
                break;
            default:
                $this->response('', 204);
                break;
        }
    }

    public function getAuthors()
    {
        try {
            $authorId = Utils::getValue('authorId', true);
            $request = $this->db->prepare('CALL AuthorData(?)');
            $request->bindValue(1, $authorId);
            $request->execute();
            
            if ($request->rowCount() > 0) {
                $rows = array();

                while ($request->columnCount()) {
                    $rows[] = $request->fetchAll(PDO::FETCH_ASSOC);
                    $request->nextRowset();
                }
                $this->buildResponse($rows[0]);
            }
            $this->response('', 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO getAuthors', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('getAuthors', $e);
            $this->response($message, 500);
        }
    }

    public function saveAuthor($isPost)
    {
        try {
            $authorId = Utils::getValue('authorId', $isPost);
            $name = Utils::getValue('name', $isPost);
            $image = Utils::getValue('image', $isPost);

            $uploadMessage = '';
            if ($authorId != null) {
                // Is an update. Get previous data to manage image
                $authorOld = $this->db->prepare('CALL AuthorData(?)');
                $authorOld->bindValue(1, $authorId);
                $authorOld->execute();
                $oldImage = $authorOld->fetchAll(PDO::FETCH_ASSOC)[0];
                if ($image != $oldImage['image']) {
                    $uploadResult = Utils::uploadImage();

                    switch ($uploadResult) {
                        case -1:
                            $uploadMessage = 'No se encontró el adjunto';
                            break;
                        case 0:
                            // Upload ok, delete previous file
                            $filenamePath = Config::$IMG_DIR . $authorOld->image;
                            unlink($filenamePath);
                            break;
                        case 1:
                            $uploadMessage = 'La imagen supera los ' . Config::$MAX_IMAGE_SIZE . ' bytes';
                            break;
                        case 2:
                            $uploadMessage = 'El archivo ha de ser de tipo imagen';
                            break;
                        default:
                            $uploadMessage = 'Opción desconocida';
                            break;
                    }
                }
            }

            $authorOld->closeCursor();
            $request = $this->db->prepare('CALL AuthorSave(?, ?, ?)');
            $request->bindParam(1, $authorId);
            $request->bindParam(2, $name);
            $request->bindParam(3, $image);

            $request->execute();

            if ($request) {
                $this->response($uploadMessage, 200);
            }
            $this->response($uploadMessage, 204);
        } catch (PDOException $e) {
            $message = Utils::buildError('PDO saveAuthor', $e);
            $this->response($message, 500);
        } catch (Exception $e) {
            $message = Utils::buildError('saveAuthor', $e);
            $this->response($message, 500);
        }
    }
}
