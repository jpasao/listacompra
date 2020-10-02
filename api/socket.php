<?php

spl_autoload_register(function($filename)
{
    require_once strtolower($filename) . '.php';
});

class Socket
{
    public static function beginConnection()
    {
        try {
            // Allow wait for connections
            set_time_limit(0);
            // Activate implicit flush
            ob_implicit_flush();
                        
            $address = SOCKET_URL;
            $port = SOCKET_PORT;
    
            if (($sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) === false){
                echo 'socket_create() falló: ' . socket_strerror(socket_last_error()) . '\n';
            }
            if (socket_bind($sock, $address, $port) === false) {
                echo 'socket_bind() falló: ' . socket_strerror(socket_last_error($sock)) . '\n';
            }            
            if (socket_listen($sock, 5) === false) {
                echo 'socket_listen() falló: ' . socket_strerror(socket_last_error($sock)) . '\n';
            }
            Socket::handleConnections($sock);
        }
        catch (Exception $e) {
            echo Utils::buildError('Sockets beginConnection', $e);
        }
    }

    public static function handleConnections($sock)
    {
        try {

            $clients = array();
    
            do {
                $read = array();
                $read[] = $sock;
                
                $read = array_merge($read, $clients);
        
                // if(socket_select($read,$write = NULL, $except = NULL, $tv_sec = 5) < 1)
                // {
                //     // SocketServer::debug("Problem blocking socket_select?");
                //     continue;
                // }
    
                if (in_array($sock, $read)) {
    
                    if (($msgsock = socket_accept($sock)) === false) {
                        echo 'socket_accept() falló: ' . socket_strerror(socket_last_error($sock)) . '\n';
                        break;
                    }
    
                    $clients[] = $msgSock;
                    $key = array_keys($clients, $msgSock);
                    $msg = "\nBienvenido al Servidor De Prueba de PHP. \n" .
                    "Usted es el cliente numero: {$key[0]}\n" .
                    "Para salir, escriba 'quit'. Para cerrar el servidor escriba 'shutdown'.\n";
                    socket_write($msgsock, $msg, strlen($msg));
                }
    
                foreach ($clients as $key => $client) {      
                    if (in_array($client, $read)) {
                        if (false === ($buf = socket_read($client, 2048, PHP_NORMAL_READ))) {
                            echo 'socket_read() falló: ' . socket_strerror(socket_last_error($client)) . '\n';
                            break 2;
                        }
                        if (!$buf = trim($buf)) {
                            continue;
                        }
                        if ($buf == 'quit') {
                            unset($clients[$key]);
                            socket_close($client);
                            break;
                        }
                        if ($buf == 'shutdown') {
                            socket_close($client);
                            break 2;
                        }
                        $talkback = "Cliente {$key}: Usted dijo '$buf'.\n";
                        socket_write($client, $talkback, strlen($talkback));
                        echo "$buf\n";
                    }               
                }    
            } while (true);
    
            socket_close($sock);
        } 
        catch (Exception $e) {
            echo Utils::buildError('Sockets handleConnections', $e);
        }         
    }
}