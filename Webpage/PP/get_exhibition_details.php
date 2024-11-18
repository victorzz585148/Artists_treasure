<?php
// PHP 文件：get_exhibition_details.php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 獲取展覽 ID
$exhibitionId = $_POST['exhibitionId'] ?? '';
if (empty($exhibitionId)) {
    die(json_encode(["success" => false, "message" => "沒有提供展覽 ID"]));
}

// 查找展覽基本資料
$stmt = $mysqli->prepare("
    SELECT EN_NAME as name, EN_LOCATION as location, EN_ITEM as item, EN_INTRODUCE as introduce, 
           EN_ORGANIZER as organizer, EN_START as start_date, EN_FINISH as end_date 
    FROM exhibition 
    WHERE EN_ID = ?
");
$stmt->bind_param('s', $exhibitionId);
$stmt->execute();
$stmt->bind_result($name, $location, $item, $introduce, $organizer, $start_date, $end_date); // 包含 organizer
$stmt->fetch();
$stmt->close();

// 組裝展覽詳細資料
$details = [
    'name' => $name,
    'location' => $location,
    'organizer' => $organizer,
    'start_date' => $start_date,
    'end_date' => $end_date,
    'item' => $item,
    'introduce' => $introduce,
    'artworks' => []
];

// 查找該展覽的所有創作品和收藏品
$query = "
    SELECT 
        artwork.AK_ID as id, 
        artwork.AK_NAME as name, 
        'ARTWORK' as type
    FROM 
        artwork
    JOIN 
        exhibitiondetail ON artwork.AK_ID = exhibitiondetail.AK_ID
    WHERE 
        exhibitiondetail.EN_ID = ?
    UNION
    SELECT 
        collection.COL_ID as id, 
        collection.COL_NAME as name, 
        'COLLECTION' as type
    FROM 
        collection
    JOIN 
        exhibitiondetail ON collection.COL_ID = exhibitiondetail.COL_ID
    WHERE 
        exhibitiondetail.EN_ID = ?
";

$stmtArtworks = $mysqli->prepare($query);
$stmtArtworks->bind_param('ss', $exhibitionId, $exhibitionId);
$stmtArtworks->execute();
$resultArtworks = $stmtArtworks->get_result();

// 添加創作品和收藏品到展覽詳細資料中
while ($row = $resultArtworks->fetch_assoc()) {
    $details['artworks'][] = $row;
}

// 返回 JSON 結果
echo json_encode($details);

// 關閉資源
$stmtArtworks->close();
$mysqli->close();
