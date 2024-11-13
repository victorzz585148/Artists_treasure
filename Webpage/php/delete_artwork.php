<?php
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");
header('Content-Type: application/json; charset=utf-8');

// 驗證連線
if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 獲取 POST 的參數
$id = $_POST['id'] ?? null;
$category = $_POST['category'] ?? null;

if ($id === null) {
    die(json_encode(["success" => false, "message" => "未提供作品ID"]));
}

if ($category === null) {
    die(json_encode(["success" => false, "message" => "未提供作品類別"]));
}

// 根據類別選擇要刪除的表
if ($category === 'artwork') {
    $stmt = $mysqli->prepare("DELETE FROM `artwork` WHERE AK_ID = ?");
} else if ($category === 'collection') {
    $stmt = $mysqli->prepare("DELETE FROM `collection` WHERE COL_ID = ?");
} else {
    die(json_encode(["success" => false, "message" => "無效的作品類別"]));
}

// 確保 $stmt 被成功初始化
if (!$stmt) {
    die(json_encode(["success" => false, "message" => "準備刪除語句時失敗：" . $mysqli->error]));
}

// 綁定參數並執行語句
$stmt->bind_param("s", $id);
if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "作品已成功刪除"]);
} else {
    echo json_encode(["success" => false, "message" => "刪除失敗：" . $stmt->error]);
}

$stmt->close();
$mysqli->close();