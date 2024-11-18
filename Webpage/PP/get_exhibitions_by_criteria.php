<?php
header('Content-Type: application/json');

include 'db_connection.php'; // 確保此檔案正確連接資料庫

$criteria = $_POST['criteria'] ?? ''; // 接收搜尋條件
$query = $_POST['query'] ?? '';       // 接收搜尋關鍵字

if (!$criteria || !$query) {
    echo json_encode(['success' => false, 'message' => '搜尋條件或關鍵字無效']);
    exit;
}

// 定義搜尋條件對應的資料庫欄位
$fieldMap = [
    'name' => 'exhibition_name',
    'location' => 'location',
    'organizer' => 'organizer',
    'start_date' => 'start_date',
    'end_date' => 'end_date'
];

$field = $fieldMap[$criteria] ?? null; // 確認條件是否合法
if (!$field) {
    echo json_encode(['success' => false, 'message' => '無效的搜尋條件']);
    exit;
}

// 準備 SQL 查詢
$stmt = $conn->prepare("SELECT * FROM exhibitions WHERE $field LIKE ?");
$searchTerm = '%' . $query . '%'; // 模糊匹配
$stmt->bind_param('s', $searchTerm);
$stmt->execute();
$result = $stmt->get_result();

// 格式化查詢結果
$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

// 返回 JSON 格式的資料
echo json_encode(['success' => true, 'data' => $data]);
?>
