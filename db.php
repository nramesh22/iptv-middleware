<?php
$host='localhost';$user='iptvuser';$pass='password123';$db='iptv_middleware';
$conn=new mysqli($host,$user,$pass,$db);
if($conn->connect_error){die('DB Connection failed: '.$conn->connect_error);}
?>