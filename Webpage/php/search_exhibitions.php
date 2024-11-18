<?php
$conn = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($conn->connect_error) {
    die("連接失敗: " . $conn->connect_error);
}
// 設定字元編碼，避免中文顯示問題
$conn->set_charset("utf8");

// 獲取 DataTables 的參數
$draw = $_POST['draw'] ?? 1;
$start = $_POST['start'] ?? 0;
$length = $_POST['length'] ?? 10;
$searchValue = $_POST['search']['value'] ?? '';

// 獲取搜尋參數
$searchCategory = $_POST['searchCategory'] ?? '';
$searchQuery = $_POST['searchQuery'] ?? '';

// 準備查詢資料的 SQL 語句
$sql = "SELECT ex.EN_ID AS id, ex.EN_NAME AS name, ex.EN_START AS start_date, ex.EN_FINISH AS end_date, 
        GROUP_CONCAT(DISTINCT ak.AK_NAME) AS artwork_names, GROUP_CONCAT(DISTINCT col.COL_NAME) AS collection_names 
        FROM EXHIBITION ex 
        LEFT JOIN EXHIBITIONDETAIL ed ON ex.EN_ID = ed.EN_ID 
        LEFT JOIN ARTWORK ak ON ed.AK_ID = ak.AK_ID 
        LEFT JOIN COLLECTION col ON ed.COL_ID = col.COL_ID 
        WHERE 1=1";

// 添加搜尋條件
$params = [];
if (!empty($searchCategory) && !empty($searchQuery)) {
    switch ($searchCategory) {
        case 'EN_NAME':
            $sql .= " AND ex.EN_NAME LIKE ?";
            $params[] = "%" . $searchQuery . "%";
            break;
        case 'EN_LOCATION':
            $sql .= " AND ex.EN_LOCATION LIKE ?";
            $params[] = "%" . $searchQuery . "%";
            break;
        case 'EN_ORGANIZER':
            $sql .= " AND ex.EN_ORGANIZER LIKE ?";
            $params[] = "%" . $searchQuery . "%";
            break;
        case 'EN_START':
            $sql .= " AND ex.EN_START = ?";
            $params[] = $searchQuery;
            break;
        case 'EN_FINISH':
            $sql .= " AND ex.EN_FINISH = ?";
            $params[] = $searchQuery;
            break;
        case 'AK_NAME':
            $sql .= " AND (ak.AK_NAME LIKE ? OR col.COL_NAME LIKE ?)";
            $params[] = "%" . $searchQuery . "%";
            $params[] = "%" . $searchQuery . "%";
            break;
        case 'END_NAME':
            $sql .= " AND ed.END_NAME LIKE ?";
            $params[] = "%" . $searchQuery . "%";
            break;
    }
}

// 使用 GROUP BY 確保每個展覽只返回一次
$sql .= " GROUP BY ex.EN_ID, ex.EN_NAME, ex.EN_START, ex.EN_FINISH";

// 獲取資料總數（不受分頁限制）
$count_sql = "SELECT COUNT(*) AS total FROM (" . $sql . ") AS count_query";
$stmt = $conn->prepare($count_sql);
if ($stmt === false) {
    die("SQL 準備失敗: " . $conn->error);
}
if (!empty($params)) {
    $stmt->bind_param(str_repeat("s", count($params)), ...$params);
}
$stmt->execute();
$count_result = $stmt->get_result();
$totalRecords = ($count_result->num_rows > 0) ? $count_result->fetch_assoc()['total'] : 0;
$stmt->close();

// 添加分頁參數
$sql .= " LIMIT ?, ?";
$params[] = (int)$start;
$params[] = (int)$length;

// 準備並執行最終查詢
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die("SQL 準備失敗: " . $conn->error);
}

$param_types = str_repeat("s", count($params) - 2) . "ii";
$stmt->bind_param($param_types, ...$params);
$stmt->execute();
$result = $stmt->get_result();

// 組裝返回結果
$data = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// 返回符合 DataTables 格式的 JSON 結果
$response = [
    "draw" => intval($draw),
    "recordsTotal" => intval($totalRecords),
    "recordsFiltered" => intval($totalRecords), // 如果有搜尋條件，可以額外計算被過濾的總數
    "data" => $data
];

header('Content-Type: application/json');
echo json_encode($response);

// 關閉資料庫連接
$stmt->close();
$conn->close();
