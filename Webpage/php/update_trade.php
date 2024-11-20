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

// 檢查是否提供了 ID
if (!isset($data['id']) || empty($data['id'])) {
    $response["message"] = "沒有提供交易 ID";
    echo json_encode($response);
    exit;
}

// 取得其他數據
$tradeId = $data['id'];
$place = $data['place'] ?? null;
$date = $data['date'] ?? null;
$buyer = $data['buyer'] ?? null;
$seller = $data['seller'] ?? null;
$item = $data['item'] ?? null;
$price = $data['price'] ?? null;
$remark = $data['remark'] ?? null;
$artworks = isset($data['artworks']) ? $data['artworks'] : [];
$tradeprices = isset($data['tradeprices']) ? $data['tradeprices'] : [];
$totalPrice = 0;
foreach ($tradeprices as $artworkId => $price) {
    $totalPrice += $price;
}
// 確認必填欄位是否都存在
if (!$place || !$date || !$buyer) {
    $response["message"] = "部分必要欄位未填寫，請檢查表單。";
    echo json_encode($response);
    exit;
}

// 更新展覽的基本信息
$updatetradeQuery = "UPDATE TRADE SET TDE_PLACE = ?, TDE_DATE = ?, TDE_BUYER = ?, TDE_SELLER = ?, TDE_TOTAL_ITEM = ?, TDE_TOTAL_PRICE = ?, TDE_REMARK = ? WHERE TDE_ID = ?";
$stmt = $conn->prepare($updatetradeQuery);

if (!$stmt) {
    $response["message"] = "SQL 準備失敗：" . $conn->error;
    echo json_encode($response);
    exit;
}
$artworkCount = count($artworks);
$stmt->bind_param("ssssiiss", $place, $date, $buyer, $seller, $artworkCount, $totalPrice, $remark, $tradeId);

if ($stmt->execute()) {
    // 刪除現有的參展作品
    $deleteArtworksQuery = "DELETE FROM tradeDETAIL WHERE TDE_ID = ?";
    $stmtDelete = $conn->prepare($deleteArtworksQuery);

    if (!$stmtDelete) {
        $response["message"] = "無法刪除舊的交易作品：" . $conn->error;
        echo json_encode($response);
        exit;
    }

    $stmtDelete->bind_param("s", $tradeId);
    $stmtDelete->execute();

    // 新增更新後的參展作品
    foreach ($artworks as $artworkId) {
        $tradeprice = $tradeprices[$artworkId] ?? '';
    
        if (strpos($artworkId, 'AK') === 0) {
            // 插入作品 ID
            $stmtInsert = $conn->prepare("INSERT INTO `TRADEDETAIL` (TDE_ID, AK_ID, TDED_PRICE) VALUES (?, ?, ?)");
            if ($stmtInsert === false) {
                die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $conn->error]));
            }
            $stmtInsert->bind_param('ssi', $tradeId, $artworkId, $tradeprice);
        } elseif (strpos($artworkId, 'COL') === 0) {
            // 插入收藏 ID
            $stmtInsert = $conn->prepare("INSERT INTO `TRADEDETAIL` (TDE_ID, COL_ID, TDED_PRICE) VALUES (?, ?, ?)");
            if ($stmtInsert === false) {
                die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $conn->error]));
            }
            $stmtInsert->bind_param('ssi', $tradeId, $artworkId, $tradeprice);
        } else {
            die(json_encode(["success" => false, "message" => "無效的輸入：ID 必須以 AK 或 COL 開頭。"]));
        }
    
        // 執行插入語句
        if (!$stmtInsert->execute()) {
            die(json_encode(["success" => false, "message" => "插入展覽細節失敗：" . $stmtInsert->error]));
        }
    
        $stmtInsert->close();
    }
    $response["success"] = true;
    $response["message"] = "交易更新成功！";
} else {
    $response["message"] = "交易更新失敗，請稍後再試。";
}

// 關閉資料庫連接
$stmt->close();
$stmtDelete->close();
$conn->close();

// 返回 JSON 格式的響應
echo json_encode($response);