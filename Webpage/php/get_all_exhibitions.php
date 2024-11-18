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
        e.EN_ID as id, 
        e.EN_NAME as name, 
        e.EN_START as start_date, 
        e.EN_FINISH as end_date
    FROM exhibition e
";

// 如果有搜尋條件，加入 WHERE 條件
if (!empty($searchValue)) {
    $query .= " WHERE e.EN_NAME LIKE ?";
}

// 加入排序、分頁參數
$query .= " ORDER BY e.EN_START DESC LIMIT ?, ?";

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
$totalRecordsQuery = "SELECT COUNT(*) AS total FROM exhibition";
$totalRecordsResult = $mysqli->query($totalRecordsQuery);
$totalRecords = $totalRecordsResult->fetch_assoc()['total'];

// 搜尋後的記錄數量
$totalFilteredRecords = $totalRecords;
if (!empty($searchValue)) {
    $totalFilteredQuery = "SELECT COUNT(*) AS total FROM exhibition WHERE EN_NAME LIKE ?";
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
        "name" => $row['name'],
        "start_date" => $row['start_date'],
        "end_date" => $row['end_date'],
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