<?php
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");
header('Content-Type: application/json; charset=utf-8');

// 驗證連線
if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$id = $_POST['id'] ?? null;
$category = $_POST['category'] ?? null;

if ($id === null) {
    die(json_encode(["success" => false, "message" => "未提供畫作ID"]));
}
if ($category === null) {
    die(json_encode(["success" => false, "message" => "未提供畫作類別"]));
}

if($category === 'artwork') {
    $stmt = $mysqli->prepare("SELECT * FROM `artwork` WHERE AK_ID = ?");
}else if($category === 'collection') {
    $stmt = $mysqli->prepare("SELECT * FROM `collection` WHERE COL_ID = ?");
}

$stmt->bind_param("s", $id); 
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(["success" => true, "data" => $row]);
} else {
    echo json_encode(["success" => false, "message" => "畫作未找到"]);
}

$stmt->close();
$mysqli->close();
