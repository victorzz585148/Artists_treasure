<?php
include_once 'db_connection.php';
$response = [
    "success" => false,
    "message" => "未知錯誤，請稍後再試。"
];

if (!isset($_POST['id']) || empty($_POST['id'])) {
    $response["message"] = "沒有提供作品 ID";
    echo json_encode($response);
    exit;
}

$artworkId = $_POST['id'];

// 根據 ID 選擇性查詢
if (strpos($artworkId, 'AK') === 0) {
    $query = "SELECT * FROM artwork WHERE AK_ID = ?";
} else if (strpos($artworkId, 'COL') === 0) {
    $query = "SELECT * FROM `collection` WHERE COL_ID = ?";
} else {
    $response["message"] = "無效的作品 ID";
    echo json_encode($response);
    exit;
}

$stmt = $conn->prepare($query);
$stmt->bind_param("s", $artworkId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $data = $result->fetch_assoc();
    if (isset($data['AK_MEDIA']) && !empty($data['AK_MEDIA'])) {
        // 修改這部分，讓圖片路徑正確
        $data['AK_MEDIA'] = str_replace('./uploads/', 'php/uploads/', $data['AK_MEDIA']);
    }else if (isset($data['COL_MEDIA']) && !empty($data['COL_MEDIA'])) {
        // 修改這部分，讓圖片路徑正確
        $data['COL_MEDIA'] = str_replace('./uploads/', 'php/uploads/', $data['COL_MEDIA']);
    }
    $response["success"] = true;
    $response["data"] = $data;
} else {
    $response["message"] = "找不到相關作品";
}

echo json_encode($response);
$stmt->close();
$conn->close();
