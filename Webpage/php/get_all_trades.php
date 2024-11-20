<?php
header('Content-Type: application/json');

$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

// 檢查資料庫連接
if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

// 檢查請求是否為 POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    die(json_encode(["success" => false, "message" => "請求方法錯誤，僅支援 POST"]));
}

// DataTables 的基本參數
$draw = $_POST['draw'];
$start = $_POST['start'];
$length = $_POST['length'];
$searchValue = isset($_POST['search']['value']) ? $_POST['search']['value'] : '';

// 基本查詢語句，只查詢展覽的基本信息
$query = "
    SELECT 
        t.TDE_ID as id, 
        t.TDE_PLACE as place, 
        t.TDE_DATE as date, 
        t.TDE_BUYER as buyer,
        t.TDE_SELLER as seller,
        t.TDE_TOTAL_ITEM as item,
        t.TDE_TOTAL_PRICE as price,
        t.TDE_REMARK as remark
    FROM trade t
";

// 如果有搜尋條件，加入 WHERE 條件
if (!empty($searchValue)) {
    $query .= " WHERE t.TDE_PLACE LIKE ?";
}

// 加入排序、分頁參數
$query .= " ORDER BY t.TDE_ID DESC LIMIT ?, ?";

// 準備查詢
$stmt = $mysqli->prepare($query);

if (!empty($searchValue)) {
    $searchParam = "%" . $searchValue . "%";
    $stmt->bind_param("sii", $searchParam, $start, $length);
} else {
    $stmt->bind_param("ii", $start, $length);
}

$stmt->execute();
$result = $stmt->get_result();

// 獲取總的記錄數量
$totalRecordsQuery = "SELECT COUNT(*) AS total FROM trade";
$totalRecordsResult = $mysqli->query($totalRecordsQuery);
$totalRecords = $totalRecordsResult->fetch_assoc()['total'];

// 搜尋後的記錄數量
$totalFilteredRecords = $totalRecords;
if (!empty($searchValue)) {
    $totalFilteredQuery = "SELECT COUNT(*) AS total FROM trade WHERE TDE_PLACE LIKE ?";
    $stmtFiltered = $mysqli->prepare($totalFilteredQuery);
    $stmtFiltered->bind_param("s", $searchParam);
    $stmtFiltered->execute();
    $filteredResult = $stmtFiltered->get_result();
    $totalFilteredRecords = $filteredResult->fetch_assoc()['total'];
}

// 構建返回 DataTables 所需的數據格式
$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = [
        'id' => $row['id'],
        "place" => $row['place'],
        "date" => $row['date'],
        "buyer" => $row['buyer'],
        "seller" => $row['seller'],
        "item" => $row['item'],
        "price" => $row['price'],
        "remark" => $row['remark'],
        "details" => "<button class='btn btn-info view-details-btn' data-id='" . $row['id'] . "'>查看詳細</button>"
    ];
}

$response = [
    "draw" => intval($draw),
    "recordsTotal" => intval($totalRecords),
    "recordsFiltered" => intval($totalFilteredRecords),
    "data" => $data
];

// 返回 JSON 格式的數據
echo json_encode($response);

$mysqli->close();