<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$artworkIds = $_POST['artworkIds'] ?? []; // 接收多個 artworkId

// 檢查傳入的作品 ID 是否為非空陣列
if (!is_array($artworkIds) || empty($artworkIds)) {
    die(json_encode(["success" => false, "message" => "沒有提供作品 ID"]));
}

// 將作品ID轉換成查詢中的佔位符
$placeholders = implode(',', array_fill(0, count($artworkIds), '?'));

// 動態生成 SQL 查詢，包含展覽和作品名稱
$query = "
    SELECT 
        e.EN_ID as id, 
        e.EN_NAME as name, 
        e.EN_LOCATION as location, 
        e.EN_ORGANIZER as orgnaizer, 
        e.EN_START as start_date, 
        e.EN_FINISH as end_date,
        COALESCE(a.AK_NAME, c.COL_NAME) as artwork_name  -- 取得作品名稱（創作品或收藏品）
    FROM exhibition e
    JOIN exhibitiondetail ed ON e.EN_ID = ed.EN_ID
    LEFT JOIN artwork a ON ed.AK_ID = a.AK_ID           -- 連接創作品表
    LEFT JOIN collection c ON ed.COL_ID = c.COL_ID      -- 連接收藏品表
    WHERE ed.AK_ID IN ($placeholders) OR ed.COL_ID IN ($placeholders)
";

// 準備查詢並綁定多個作品ID
$stmt = $mysqli->prepare($query);
$stmt->bind_param(str_repeat('s', count($artworkIds) * 2), ...$artworkIds, ...$artworkIds); // 綁定作品ID兩次
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$stmt->close();
$mysqli->close();
