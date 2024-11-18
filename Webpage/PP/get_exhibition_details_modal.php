<?php
// 連接資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 獲取 POST 的展覽 ID
$exhibitionId = $_POST['exhibitionId'] ?? null;
if (!$exhibitionId) {
    echo json_encode(["success" => false, "message" => "展覽 ID 未提供"]);
    exit;
}

// 查詢展覽基本資料
$stmt = $mysqli->prepare("SELECT EN_NAME as name, EN_LOCATION as location, EN_ORGANIZER as organizer, EN_START as start_date, EN_FINISH as end_date, EN_INTRODUCE as introduce FROM exhibition WHERE EN_ID = ?");
$stmt->bind_param('s', $exhibitionId);
$stmt->execute();
$stmt->bind_result($name, $location, $organizer, $start_date, $end_date, $introduce);
$stmt->fetch();
$stmt->close();

if (!$name) {
    echo json_encode(["success" => false, "message" => "找不到展覽資料"]);
    exit;
}

// 查詢參展畫作
$stmtArtworks = $mysqli->prepare("SELECT AK_ID as id, AK_NAME as name FROM artwork JOIN exhibitiondetail ON artwork.AK_ID = exhibitiondetail.AK_ID WHERE EN_ID = ?");
$stmtArtworks->bind_param('s', $exhibitionId);
$stmtArtworks->execute();
$resultArtworks = $stmtArtworks->get_result();

$artworks = [];
while ($row = $resultArtworks->fetch_assoc()) {
    $artworks[] = $row;
}
$stmtArtworks->close();

// 組裝詳細資料
$details = [
    "name" => $name,
    "location" => $location,
    "organizer" => $organizer,
    "start_date" => $start_date,
    "end_date" => $end_date,
    "introduce" => $introduce,
    "artworks" => $artworks
];

echo json_encode(["success" => true, "data" => $details]);

$mysqli->close();
