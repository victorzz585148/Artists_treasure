<?php
$host = 'localhost';
$user = 'root';
$password = '';
$dbname = 'your_database_name';

$conn = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");
if ($conn->connect_error) {
    die("資料庫連接失敗: " . $conn->connect_error);
}
