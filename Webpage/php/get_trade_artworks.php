<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$searchTerm = $_POST['searchTerm'] ?? '';
$categorySelect = $_POST['categorySelect'] ?? 'artwork'; // 默認為 artwork，如果沒有提供 categorySelect

// 輸出 searchTerm 和 categorySelect 進行調試
error_log("searchTerm: " . $searchTerm);
error_log("categorySelect: " . $categorySelect);

// 根據 categorySelect 決定查詢哪個表
if ($categorySelect === 'artwork') {
    $stmt = $mysqli->prepare("SELECT AK_ID as id, AK_NAME as name, AK_STATE as state  FROM `artwork` WHERE AK_NAME LIKE ?");
} elseif ($categorySelect === 'collection') {
    $stmt = $mysqli->prepare("SELECT COL_ID as id, COL_NAME as name, COL_STATE as state FROM `collection` WHERE COL_NAME LIKE ?");
} else {
    // 如果 categorySelect 的值無效，返回錯誤
    die(json_encode(["success" => false, "message" => "無效的類別選擇"]));
}

if ($stmt === false) {
    die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
}

$likeTerm = '%' . $searchTerm . '%';
$stmt->bind_param('s', $likeTerm);
$stmt->execute();

if ($stmt->errno) {
    die(json_encode(["success" => false, "message" => "SQL 執行失敗：" . $stmt->error]));
}

$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

// 檢查是否有資料返回
if (empty($data)) {
    echo json_encode(["success" => false, "message" => "未找到符合條件的資料"]);
} else {
    echo json_encode($data);
}

$stmt->close();
$mysqli->close();