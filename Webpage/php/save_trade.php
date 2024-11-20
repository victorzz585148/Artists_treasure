<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$tradeplace = $_POST['tradeplace'] ?? '';
$tradedate = $_POST['tradedate'] ?? '';
$tradebuyer = $_POST['tradebuyer'] ?? ''; 
$tradeseller = $_POST['tradeseller'] ?? '';
$tradeRemark = $_POST['tradeRemark'] ?? '';
$artworks = $_POST['tradeArtworks'] ?? 0;
$tradeprice = $_POST['tradeprice'] ?? '';
$state = $_POST['changeTradeState'] ?? 0;

$totalPrice = 0;
foreach ($tradeprice as $artworkId => $price) {
    $price = floatval($price); // 確保價格是數字
    $totalPrice += $price;
}
error_log("Current state: " . $state);
if ($state === 1) {
    // 獲取所有的交易作品資料
    if (isset($_POST['tradeArtworks']) && is_array($_POST['tradeArtworks'])) {

        // 開始遍歷每個交易作品 ID
        foreach ($artworks as $artworkId) {
            error_log("Artwork ID: " . $artworkId);
            // 檢查是否是 AK 或 COL 開頭的 ID，並根據其去更新對應的狀態
            if (strpos($artworkId, 'AK') === 0) {
                // 若 ID 以 AK 開頭，則從 tradedetail 中找 AK_ID 並更新 artwork 表的 AK_STATE
                error_log("Artwork ID starts with AK");
                $query = "SELECT AK_ID FROM tradedetail WHERE AK_ID = ?";
                $stmt = $mysqli->prepare($query);
                $stmt->bind_param("s", $artworkId);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    // 找到相應的 AK_ID，進行狀態更新
                    $updateQuery = "UPDATE artwork SET AK_STATE = 1 WHERE AK_ID = ?";
                    $updateStmt = $mysqli->prepare($updateQuery);
                    $updateStmt->bind_param("s", $artworkId);
                    if (!$updateStmt->execute()) {
                        error_log("Failed to update artwork state for AK_ID: " . $artworkId);
                    }
                    $updateStmt->close();
                }
                $stmt->close();
                
            } elseif (strpos($artworkId, 'COL') === 0) {
                // 若 ID 以 COL 開頭，則從 tradedetail 中找 COL_ID 並更新 collection 表的 COL_STATE
                error_log("Artwork ID starts with COL");
                $query = "SELECT COL_ID FROM tradedetail WHERE COL_ID = ?";
                $stmt = $mysqli->prepare($query);
                $stmt->bind_param("s", $artworkId);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    // 找到相應的 COL_ID，進行狀態更新
                    $updateQuery = "UPDATE collection SET COL_STATE = 1 WHERE COL_ID = ?";
                    $updateStmt = $mysqli->prepare($updateQuery);
                    $updateStmt->bind_param("s", $artworkId);
                    if (!$updateStmt->execute()) {
                        error_log("Failed to update collection state for COL_ID: " . $artworkId);
                    }
                    $updateStmt->close();
                }
                $stmt->close();
            } else {
                // 如果 ID 不符合 AK 或 COL 開頭，跳過該資料
                continue;
            }
        }
    }
}

$stmt = $mysqli->prepare("INSERT INTO trade (TDE_PLACE, TDE_DATE, TDE_BUYER, TDE_SELLER, TDE_TOTAL_ITEM, TDE_TOTAL_PRICE, TDE_REMARK) VALUES (?, ?, ?, ?, ?, ?, ?)");
$artworkCount = count($artworks);
$stmt->bind_param('ssssiis', $tradeplace, $tradedate, $tradebuyer, $tradeseller, $artworkCount, $totalPrice, $tradeRemark);
if (!$stmt->execute()) {
    die(json_encode(["success" => false, "message" => "插入交易失敗：" . $stmt->error]));
}


$tradeId = $mysqli->insert_id;
if ($tradeId === false) {
    die(json_encode(["success" => false, "message" => "SQL 查找語句失敗：" . $mysqli->error]));
}
//取得新 TDE_ID
$tradeIdStmt = $mysqli->prepare("SELECT TDE_ID FROM TRADE WHERE TDE_PLACE = ? AND TDE_DATE = ? AND TDE_BUYER = ?");
if ($tradeIdStmt === false) {
    die(json_encode(["success" => false, "message" => "SQL 查找語句失敗：" . $mysqli->error]));
}

$tradeIdStmt->bind_param('sss', $tradeplace, $tradedate, $tradebuyer);
$tradeIdStmt->execute();
$tradeIdStmt->bind_result($retrievedTradeId);
$tradeIdStmt->fetch();
$tradeIdStmt->close();

// 檢查是否成功獲取 TDE_ID
if (!$retrievedTradeId) {
    die(json_encode(["success" => false, "message" => "無法獲取新插入的交易 ID"]));
}

$tradeId = $retrievedTradeId;

// 插入到 TRADEDETAIL 表中
foreach ($tradeprice as $artworkId => $price) {
    // 根據 artworkId 的前綴來確定是 AK_ID 還是 COL_ID
    if (strpos($artworkId, 'AK') === 0) {
        // 插入作品 ID（AK_ID）
        $stmtArt = $mysqli->prepare("INSERT INTO TRADEDETAIL (TDE_ID, AK_ID, TDED_PRICE) VALUES (?, ?, ?)");
        if ($stmtArt === false) {
            die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
        }
        $stmtArt->bind_param('ssd', $tradeId, $artworkId, $price);      
    } elseif (strpos($artworkId, 'COL') === 0) {
        // 插入收藏 ID（COL_ID）
        $stmtArt = $mysqli->prepare("INSERT INTO TRADEDETAIL (TDE_ID, COL_ID, TDED_PRICE) VALUES (?, ?, ?)");
        if ($stmtArt === false) {
            die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
        }
        $stmtArt->bind_param('ssd', $tradeId, $artworkId, $price);
    } else {
        die(json_encode(["success" => false, "message" => "無效的輸入：ID 必須以 AK 或 COL 開頭。"]));
    }

    // 執行插入語句
    if (!$stmtArt->execute()) {
        die(json_encode(["success" => false, "message" => "插入交易細節失敗：" . $stmtArt->error]));
    }

    $stmtArt->close();
}


$mysqli->close();
echo json_encode(["success" => true, "message" => "展覽儲存成功！"]);