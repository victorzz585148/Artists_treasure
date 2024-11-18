<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$searchTerm = $_POST['searchTerm'] ?? '';
$category = $_POST['category'] ?? 'ARTWORK'; // 預設為創作品

// 根據類別選擇查詢條件
if ($category === 'ARTWORK') {
    // 創作品
    $query = "SELECT AK_ID as id, AK_NAME as name FROM artwork WHERE AK_NAME LIKE ?";
} elseif ($category === 'COLLECTION') {
    // 收藏品
    $query = "SELECT COL_ID as id, COL_NAME as name FROM collection WHERE COL_NAME LIKE ?";
} else {
    die(json_encode(["success" => false, "message" => "無效的類別"]));
}

$stmt = $mysqli->prepare($query);
$likeTerm = '%' . $searchTerm . '%';
$stmt->bind_param('s', $likeTerm);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$stmt->close();
$mysqli->close();
