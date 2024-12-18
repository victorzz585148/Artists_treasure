<?php
// PHP 文件：get_exhibition_details.php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 獲取展覽 ID
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 檢查 POST 數據

    $exhibitionId = isset($_POST['id']) ? $_POST['id'] : null;

    if (!$exhibitionId) {
        echo json_encode(['success' => false, 'message' => '沒有提供展覽 ID']);
        exit();
    }

// 查找展覽基本資料
$stmt = $mysqli->prepare("
    SELECT EN_NAME as name, EN_LOCATION as location, EN_ITEM as item, EN_INTRODUCE as introduce, 
           EN_ORGANIZER as organizer, EN_START as start_date, EN_FINISH as end_date, EN_REMARK as remark
    FROM exhibition 
    WHERE EN_ID = ?
");
$stmt->bind_param('s', $exhibitionId);
$stmt->execute();
$stmt->bind_result($name, $location, $item, $introduce, $organizer, $start_date, $end_date, $remark); // 包含 organizer
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
    'remark' => $remark,
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
$artworks = [];
    while ($row = $resultArtworks->fetch_assoc()) {
        $artworks[] = [
            'id' => $row['id'],
            'name' => $row['name'],
            'type' => $row['type']
        ];
    }
//抓別名
    $queryAdditional = "
    SELECT 
        ed.AK_ID AS id, 
        ed.END_NAME AS alias 
    FROM 
        exhibitiondetail ed
    WHERE 
        ed.EN_ID = ?
    UNION
    SELECT 
        ed.COL_ID AS id, 
        ed.END_NAME AS alias 
    FROM 
        exhibitiondetail ed
    WHERE 
        ed.EN_ID = ?
";
$stmtAdditional = $mysqli->prepare($queryAdditional);
if ($stmtAdditional === false) {
    die(json_encode(["success" => false, "message" => "SQL 語句準備失敗：" . $mysqli->error]));
}
$stmtAdditional->bind_param('ss', $exhibitionId, $exhibitionId);
$stmtAdditional->execute();
$resultAdditional = $stmtAdditional->get_result();
while ($row = $resultAdditional->fetch_assoc()) {
    // 將新的別名數據加入已有的 artworks 陣列中
    foreach ($artworks as &$artwork) {
        if ($artwork['id'] === $row['id']) {
            $artwork['alias'] = $row['alias'];
        }
    }
}
}

$details['artworks'] = $artworks;
// 返回 JSON 結果
echo json_encode($details);

// 關閉資源
$stmtAdditional->close();
$stmtArtworks->close();
$mysqli->close();
