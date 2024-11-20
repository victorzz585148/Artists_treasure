<?php
// PHP 文件：get_exhibition_details.php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 獲取交易 ID
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 檢查 POST 數據

    $tradeId = isset($_POST['id']) ? $_POST['id'] : null;

    if (!$tradeId) {
        echo json_encode(['success' => false, 'message' => '沒有提供交易 ID']);
        exit();
    }

// 查找展覽基本資料
$stmt = $mysqli->prepare("
    SELECT TDE_PLACE as place, TDE_DATE as date, TDE_BUYER as buyer, TDE_seller as seller, 
           TDE_TOTAL_ITEM as item, TDE_TOTAL_PRICE as price, TDE_REMARK as remark
    FROM trade
    WHERE TDE_ID = ?
");
$stmt->bind_param('s', $tradeId);
$stmt->execute();
$stmt->bind_result($place, $date, $buyer, $seller, $item, $price, $remark);
$stmt->fetch();
$stmt->close();

// 組裝展覽詳細資料
$details = [
    'place' => $place,
    'date' => $date,
    'buyer' => $buyer,
    'seller' => $seller,
    'item' => $item,
    'price' => $price,
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
        tradedetail ON artwork.AK_ID = tradedetail.AK_ID
    WHERE 
        tradedetail.TDE_ID = ?
    UNION
    SELECT 
        collection.COL_ID as id, 
        collection.COL_NAME as name, 
        'COLLECTION' as type
    FROM 
        collection
    JOIN 
        tradedetail ON collection.COL_ID = tradedetail.COL_ID
    WHERE 
        tradedetail.TDE_ID = ?
";

$stmtArtworks = $mysqli->prepare($query);
$stmtArtworks->bind_param('ss', $tradeId, $tradeId);
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

//抓單件金額
$queryAdditional = "
SELECT 
    tded.AK_ID AS id, 
    tded.TDED_PRICE AS price 
FROM 
    TRADEDETAIL tded
WHERE 
    tded.TDE_ID = ?
UNION
SELECT 
    tded.COL_ID AS id, 
    tded.TDED_PRICE AS price 
FROM 
    TRADEDETAIL tded
WHERE 
    tded.TDE_ID = ?
";
$stmtAdditional = $mysqli->prepare($queryAdditional);
if ($stmtAdditional === false) {
    die(json_encode(["success" => false, "message" => "SQL 語句準備失敗：" . $mysqli->error]));
}
$stmtAdditional->bind_param('ss', $tradeId, $tradeId);
$stmtAdditional->execute();
$resultArtworks = $stmtAdditional->get_result();
while ($row = $resultArtworks->fetch_assoc()) {
    // 將新的別名數據加入已有的 artworks 陣列中
    foreach ($artworks as &$artwork) {
        if ($artwork['id'] === $row['id']) {
            $artwork['price'] = $row['price'];
        }
    }
}
}
$details['artworks'] = $artworks;
// 返回 JSON 結果
echo json_encode($details);

// 關閉資源
$stmtArtworks->close();
$mysqli->close();
