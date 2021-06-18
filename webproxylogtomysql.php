#!/usr/bin/php
<?php
/****************************************************************************
*                                                                           *
*    MikroTik Proxylizer, Web-proxy log analyzer                            *
*    Copyright (C) 2009  MikroTik                                           *
*                                                                           *
*    This program is free software: you can redistribute it and/or modify   *
*    it under the terms of the GNU General Public License as published by   *
*    the Free Software Foundation, either version 3 of the License, or      *
*    (at your option) any later version.                                    *
*                                                                           *
*    This program is distributed in the hope that it will be useful,        *
*    but WITHOUT ANY WARRANTY; without even the implied warranty of         *
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
*    GNU General Public License for more details.                           *
*                                                                           *
*    You should have received a copy of the GNU General Public License      *
*    along with this program.  If not, see <http://www.gnu.org/licenses/>.  *
*                                                                           *
****************************************************************************/
if (isset($_SERVER['REQUEST_URI'])) return;
define("STARTED_FROM_INDEX", 2);
chdir(dirname($argv[0]));
if(!include("config_constants.php")) {
    echo date("Y-m-d H:i | ") . "No configuration written!\n";
} else {
    include('DB.php');
    while( true ) {
            $pid = pcntl_fork();
            if ($pid == -1) {
            die('could not fork');
        } else if ($pid) {
            pcntl_waitpid($pid, $status); //Protect against Zombie children
            sleep(1);
            continue;
        } else {
            set_time_limit(0);
            ob_implicit_flush();
            define("DEBUG", 0);
            define("IP_DIGIT", "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)");
            define("IP_REGEXP", "^" . IP_DIGIT . "\\." . IP_DIGIT . "\\." . IP_DIGIT . "\\." . IP_DIGIT . "$");
            $MYSQL_PIPE = "/home/mikrotik/mysql.pipe";
            // tell PEAR to write no backtrace
            $skiptrace = &PEAR::getStaticProperty('PEAR_Error', 'skiptrace');
            $skiptrace = true;
            
            /////////////////////////////////////
            
            //print_r($_SERVER);
            while (true) {
                $file = @fopen($MYSQL_PIPE, "r");
                if ($file == false) {
                echo date("Y-m-d H:i | ") . "Error : Can't open file {$MYSQL_PIPE}\n";
                sleep(1);
                continue;
                }
                if ($db = connectDB()) {
                    while ($line = fgets($file)) {
    		    $line = str_replace("\n", "", $line);
                        //echo "{$line}\n";
                        $rawlog = explode(" ", $line);
                        //interesting for me;
                        // $rawlog['0'] = Host;
                        //$rawlog['1'] = Date;
                        //$rawlog['2'] = Time;
                        //$rawlog['4'] = IP;
                        //$rawlog['6'] = URL;
                        //$rawlog['7'] = action;
                        //$rawlog['8'] = cache;
                        $date = $rawlog['1'];
                        $time = $rawlog['2'];
                        //$datetime = $date . " " . $time;
                        $date = strtotime($date);
                        $date = date("Y-m-d",$date);
                        $time = strtotime($time);
                        $time = date("H:i",$time);
                        if ($rawlog['3'] == 'web-proxy,account') {
                            $host = ip2long($rawlog['0']);
                            list(, $host) = unpack('l', pack('l', $host));
                            if ($host === false) echo date("Y-m-d H:i | ") .  "Invalid Host IP address";
                            $IP = eregIP($rawlog['4']);
                            if ($IP !== false) {
                                $IP = ip2long($rawlog['4']);
                                if ($IP !== false) {
                                    list(, $IP) = unpack('l', pack('l', $IP));
                                    parseURL($rawlog['6']);
                                    parseDomain($fulldomain);
                                    parseAction($rawlog['7']);
                                    parseCache($line);
                                    //echo "Action = {$action}\n";
                                    //echo "Cache = {$cache}\n";
                                    if(insertLine($db));
                                } else {
                                    echo date("Y-m-d H:i | ") . "Invalid IP address!!!\n";
                                }
                            } else {
                                echo date("Y-m-d H:i | ") . "Invalid IP address!!!\n";
                            }
                        } else {
                            echo date("Y-m-d H:i | ") . "Not valid web proxy log!!!\n";
                        }
                    }
                $db->disconnect();
                }
                fclose($file);
            }
        }
    }
}
function eregIP ($ip) {
    if (ereg(IP_REGEXP, $ip)) {
        return $ip;
    } else {
        return false;
    }
}

function connectDB() {
global $config_const;
    $DBpaswrd = $config_const['DB_PASSWORD'];
    if ($DBpaswrd != "") $DBpaswrd = ":" . $DBpaswrd;
    $dsn = "{$config_const['DB_TYPE']}://{$config_const['DB_USERNAME']}{$DBpaswrd}@{$config_const['DB_HOST']}/{$config_const['DB_NAME']}"; 
    $options = array(
    'debug'       => 2,
    'portability' => DB_PORTABILITY_ALL,
    );
    do {
        $db = & DB::connect($dsn, $options);
        if (PEAR::isError($db)) {
            echo "/1/ ";
            echo date("Y-m-d H:i | ") . "Code " . $errcode=$db->getcode() . " ";
            echo $db->getMessage() . "\n";
            if ($errcode == DB_ERROR_ACCESS_VIOLATION || $errcode == DB_ERROR_NOSUCHDB) {
                return false;
            }
            return false;
        } else {
            return $db;
        }
    } while (true);
}


function insertLine (& $db) {
global $subdomain, $domain, $topdomain, $domainid , $cofig_const ;
    $query = "INSERT INTO domain(subdomain, domain, topdomain)
                    VALUES ('{$subdomain}', '{$domain}', '{$topdomain}')";
        do {
            $insertdata = & $db->query($query);
            $iserror = false;
            if (PEAR::isError($insertdata)) {
                $msg = $insertdata->getMessage() . "\n";
                $errcode = $insertdata->getCode();
                if ($errcode = DB_ERROR_CONSTRAINT || $errcode = DB_ERROR_ALREADY_EXISTS) {
                    $testquery = "SELECT ID from domain WHERE subdomain = '{$subdomain}'
                                and domain = '{$domain}' and topdomain = '{$topdomain}'";
                    // domain exists
                    $res =& $db->query($testquery);
                    if (PEAR::isError($res)) {
                        $errorcode = $res->getCode();
                        if ($errorcode == DB_ERROR_ACCESS_VIOLATION || $errcode == DB_ERROR_NOSUCHDB || 
                            $errcode == DB_ERROR_NODBSELECTED || $errcode == DB_ERROR || 
                            $errcode == DB_ERROR_NODBSELECTED) {
                            // domain exists but connection lost
                            echo "/2/ ";
                            echo date("Y-m-d H:i | ") . "CODE: " . $res->getCode() . " ";
                            echo $res->getMessage() . " \n";
                            $iserror = true;
                            $db->disconnect();
                            $db = connectDB();
                        } else {
                            $iserror = false;
                        }
                    } else {
                        // domain exists, id selected
                        $row =& $res->fetchRow();
                        $domainid = $row['0'];
                        insertWebproxyTable($db);
                        $iserror = false;
                    }
                } elseif ($errcode == DB_ERROR_ACCESS_VIOLATION || $errcode == DB_ERROR_NOSUCHDB || 
                            $errcode == DB_ERROR_NODBSELECTED || $errcode == DB_ERROR ||
                            $errcode == DB_ERROR_NODBSELECTED) {
                    // no connection, etc
                    echo "/3/ ";
                    echo date("Y-m-d H:i | ") . "CODE: " . $res->getCode() . " ";
                    echo $res->getMessage() . " \n";
                    $iserror = false;
                    $db->disconnect();
                    $db = connectDB();
                } else {
                    echo "/4/ ";
                    echo date("Y-m-d H:i | ") . $insertdata->getMessage() . "\n";
                }
            } else {
                // domain inserted
                $querymaxid = "SELECT max(ID) FROM domain";
                $res =& $db->query($querymaxid);
                if (PEAR::isError($res)) {
                    echo "/5/ ";
                    echo date("Y-m-d H:i | ") . "CODE: " . $res->getCode() . " ";
                    echo $res->getMessage() . "\n";
                } else {
                    $row =& $res->fetchRow();
                    $domainid = $row['0'];
                    insertWebproxyTable($db);
                    $iserror = false;
                }
            }
        } while ($iserror ==true);
    }

function insertWebproxyTable (& $db) {
global $domainid, $host, $date, $time, $IP, $domainid, $path, $action, $cache, $iserror, $line;
    $query = "INSERT INTO webproxylog (host, event_date, event_time, IP, domain_id, path, action, cache)"
    . " VALUES ('{$host}', '{$date}', '{$time}', "
    . "'{$IP}', '{$domainid}', '{$path}', '{$action}', '{$cache}')";
    $insertdata = & $db->query($query);
    if (PEAR::isError($insertdata)) {
        echo "/6/ ";
        echo date("Y-m-d H:i | ") . $insertdata->getMessage() . "\n";
        $iserror = false;
    } else if (DEBUG) {
        $query = "SELECT MAX(id) FROM webproxylog";
        $res = & $db->query($query);
        if (!PEAR::isError($res)) {
            $row = $res->fetchRow();
            if ($row) {
                $logID = $row[0];
                $msg = str_replace("'", "''", $line);
                $query = "INSERT INTO msg (logid, msg) VALUES ({$logID}, '{$msg}')";
                $res = & $db->query($query);
            }
        }
    }
}

function parseDomain($d) {
global $subdomain, $domain, $topdomain;
    $is_ipv4 = ip2long($d);
    if ($is_ipv4 !== false) {
        $subdomain = "";
        $domain = $d;
        $topdomain = "";
    } else {
        $posoflastdot = strrpos($d, '.');
        if ($posoflastdot === false) {
            $subdomain = "";
            $domain = $d;
            $topdomain = "";
        } else {
            $topdomain = substr($d, $posoflastdot + 1);
            $rawdomain = substr($d, 0, $posoflastdot);
            $posofprelastdot = strrpos($rawdomain, '.');
            if ($posofprelastdot !== false) {
                $domain = substr($rawdomain, $posofprelastdot + 1);
                $subdomain = substr($rawdomain, 0, $posofprelastdot);
            } else {
                $domain = $rawdomain;
                $subdomain = "";
            }
        }
    }
}

function parseURL($u) {
global $fulldomain, $path;
    $posofquestion = strpos($u, '?');
    if ($posofquestion != false) {
        $u = substr($u, 0, $posofquestion);
    }
    $posofcolonslash = strpos($u, '://');
    $address = substr($u, $posofcolonslash + 3);
    $posofslash = strpos($address, '/');
    if ($posofslash != false) {
        $fulldomain = substr($address, 0, $posofslash);
        $path = substr($address, $posofslash + 1);
    } else {
        $fulldomain = $address;
        $path = "";
    }
}

function parseAction($a) {
global $action;
    $action = $a == 'action=allow' ? 1 : 0;
}

function parseCache($l) {
global $cache;
    $c = substr($l, -9);
    $cache = $c == 'cache=HIT' ? 1 : 0;
}?>
