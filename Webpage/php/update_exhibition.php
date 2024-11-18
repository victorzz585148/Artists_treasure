<?php
header('Content-Type: application/json');

// 引入資料庫連接配置文件
include_once 'db_connection.php';

$response = [
    "success" => false,
    "message" => "未知錯誤，請稍後再試。"
];

// 從 PHP 的請求體中接收 JSON 數據
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// 調試：打印接收到的數據
error_log(print_r($data, true));

// 檢查是否提供了展覽 ID
if (!isset($data['id']) || empty($data['id'])) {
    $response["message"] = "沒有提供展覽 ID";
    echo json_encode($response);
    exit;
}

// 取得其他數據
$exhibitionId = $data['id'];
$name = $data['name'] ?? null;
$startDate = $data['start_date'] ?? null;
$endDate = $data['end_date'] ?? null;
$location = $data['location'] ?? null;
$organizer = $data['organizer'] ?? null;
$introduce = $data['introduce'] ?? null;
$remark = $data['remark'] ?? null;
$artworks = isset($data['artworks']) ? $data['artworks'] : [];
$aliases = isset($data['aliases']) ? $data['aliases'] : [];

// 確認必填欄位是否都存在
if (!$name || !$startDate || !$endDate || !$location || !$organizer) {
    $response["message"] = "部分必要欄位未填寫，請檢查表單。";
    echo json_encode($response);
    exit;
}

// 更新展覽的基本信息
$updateExhibitionQuery = "UPDATE exhibition SET EN_NAME = ?, EN_START = ?, EN_FINISH = ?, EN_LOCATION = ?, EN_ORGANIZER = ?, EN_INTRODUCE = ?, EN_REMARK = ? WHERE EN_ID = ?";
$stmt = $conn->prepare($updateExhibitionQuery);

if (!$stmt) {
    $response["message"] = "SQL 準備失敗：" . $conn->error;
    echo json_encode($response);
    exit;
}

$stmt->bind_param("ssssssss", $name, $startDate, $endDate, $location, $organizer, $introduce, $remark, $exhibitionId);

if ($stmt->execute()) {
    // 刪除現有的參展作品
    $deleteArtworksQuery = "DELETE FROM EXHIBITIONDETAIL WHERE EN_ID = ?";
    $stmtDelete = $conn->prepare($deleteArtworksQuery);

    if (!$stmtDelete) {
        $response["message"] = "無法刪除舊的參展作品：" . $conn->error;
        echo json_encode($response);
        exit;
    }

    $stmtDelete->bind_param("s", $exhibitionId);
    $stmtDelete->execute();

    // 新增更新後的參展作品
    $insertArtworkQuery = "INSERT INTO EXHIBITIONDETAIL (EN_ID, AK_ID, END_NAME) VALUES (?, ?, ?)";
    $stmtInsert = $conn->prepare($insertArtworkQuery);

    if (!$stmtInsert) {
        $response["message"] = "無法準備插入參展作品：" . $conn->error;
        echo json_encode($response);
        exit;
    }

    foreach ($artworks as $artworkId) {
        $alias = isset($aliases[$artworkId]) ? $aliases[$artworkId] : null;
        $stmtInsert->bind_param("sss", $exhibitionId, $artworkId, $alias);
        $stmtInsert->execute();
    }

    $response["success"] = true;
    $response["message"] = "展覽更新成功！";
} else {
    $response["message"] = "展覽更新失敗，請稍後再試。";
}

// 關閉資料庫連接
$stmt->close();
$stmtDelete->close();
$stmtInsert->close();
$conn->close();

// 返回 JSON 格式的響應
echo json_encode($response);