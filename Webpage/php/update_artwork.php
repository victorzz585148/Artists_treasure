<?php
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");
header('Content-Type: application/json; charset=utf-8');
// 驗證連線
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}
// 從 POST 取得資料
$category = $_POST['category'];
$artworkId = $_POST['id']; // 假設這是要更新的 ID
$NAME = $_POST['editName'] ?? null;
$MATERIAL = $_POST['editMaterial'] ?? null;
$LENGTH = $_POST['editLength'] ?? null;
$WIDTH = $_POST['editWidth'] ?? null;
$SIGNATURE_Y = $_POST['editYear'] ?? null;
$SIGNATURE_M = !empty($_POST['editMonth']) ? $_POST['editMonth'] : 0;
$THEME = $_POST['editTheme'] ?? null;
$INTRODUCE = $_POST['editIntroduce'] ?? null;
$LOCATION = $_POST['editLocation'] ?? null;
$GET_DATE = $_POST['editDate'] ?? null;
$PRICE = $_POST['editPrice'] ?? null;
$ARTIST = $_POST['editArtist'] ?? null;
$REMARK = $_POST['editRemark'] ?? null;
$STATE = $_POST['state_select'] ?? null;
$DATE = date('Y-m-d');
$SIZE = $LENGTH . "," . $WIDTH;
$MEDIA = $_POST['editMedia'] ?? null;
$REPRESENTATIVE = $_POST['representative'] ?? null; // 假設該欄位存在

$updateFields = [];
$paramTypes = '';
$params = [];

// 根據 category 判斷是 artwork 還是 collection
if ($category === 'artwork') {
    // 更新 artwork 的欄位
    if (!empty($DATE)) {
        $updateFields[] = "AK_DATE = ?";
        $paramTypes .= 's';
        $params[] = $DATE;
    }
    if (!empty($NAME)) {
        $updateFields[] = "AK_NAME = ?";
        $paramTypes .= 's';
        $params[] = $NAME;
    }
    if (!empty($MATERIAL)) {
        $updateFields[] = "AK_MATERIAL = ?";
        $paramTypes .= 's';
        $params[] = $MATERIAL;
    }
    if (!empty($SIZE)) {
        $updateFields[] = "AK_SIZE = ?";
        $paramTypes .= 's';
        $params[] = $SIZE;
    }
    if (!empty($SIGNATURE_Y)) {
        $updateFields[] = "AK_SIGNATURE_Y = ?";
        $paramTypes .= 'i';
        $params[] = $SIGNATURE_Y;
    }
    if (!empty($SIGNATURE_M)) {
        $updateFields[] = "AK_SIGNATURE_M = ?";
        $paramTypes .= 'i';
        $params[] = $SIGNATURE_M;
    }
    if (!empty($THEME)) {
        $updateFields[] = "AK_THEME = ?";
        $paramTypes .= 's';
        $params[] = $THEME;
    }
    if (!empty($INTRODUCE)) {
        $updateFields[] = "AK_INTRODUCE = ?";
        $paramTypes .= 's';
        $params[] = $INTRODUCE;
    }
    if (!empty($LOCATION)) {
        $updateFields[] = "AK_LOCATION = ?";
        $paramTypes .= 's';
        $params[] = $LOCATION;
    }
    if (!empty($MEDIA)) {
        $updateFields[] = "AK_MEDIA = ?";
        $paramTypes .= 's';
        $params[] = $MEDIA;
    }
    if (!empty($STATE)) {
        $updateFields[] = "AK_STATE = ?";
        $paramTypes .= 's';
        $params[] = $STATE;
    }
    if (!empty($REPRESENTATIVE)) {
        $updateFields[] = "REPRESENTATIVE = ?";
        $paramTypes .= 's';
        $params[] = $REPRESENTATIVE;
    }
    if (!empty($REMARK)) {
        $updateFields[] = "AK_REMARK = ?";
        $paramTypes .= 's';
        $params[] = $REMARK;
    }
} elseif ($category === 'collection') {
    // 更新 collection 的欄位
    if (!empty($ARTIST)) {
        $updateFields[] = "COL_ARTIST = ?";
        $paramTypes .= 's';
        $params[] = $ARTIST;
    }
    if (!empty($NAME)) {
        $updateFields[] = "COL_NAME = ?";
        $paramTypes .= 's';
        $params[] = $NAME;
    }
    if (!empty($MATERIAL)) {
        $updateFields[] = "COL_MATERIAL = ?";
        $paramTypes .= 's';
        $params[] = $MATERIAL;
    }
    if (!empty($SIZE)) {
        $updateFields[] = "COL_SIZE = ?";
        $paramTypes .= 's';
        $params[] = $SIZE;
    }
    if (!empty($SIGNATURE_Y)) {
        $updateFields[] = "COL_SIGNATURE_Y = ?";
        $paramTypes .= 'i';
        $params[] = $SIGNATURE_Y;
    }
    if (!empty($SIGNATURE_M)) {
        $updateFields[] = "COL_SIGNATURE_M = ?";
        $paramTypes .= 'i';
        $params[] = $SIGNATURE_M;
    }
    if (!empty($THEME)) {
        $updateFields[] = "COL_THEME = ?";
        $paramTypes .= 's';
        $params[] = $THEME;
    }
    if (!empty($GET_DATE)) {
        $updateFields[] = "COL_GET_DATE = ?";
        $paramTypes .= 's';
        $params[] = $GET_DATE;
    }
    if (!empty($PRICE)) {
        $updateFields[] = "COL_PRICE = ?";
        $paramTypes .= 'i';
        $params[] = $PRICE;
    }
    if (!empty($INTRODUCE)) {
        $updateFields[] = "COL_INTRODUCE = ?";
        $paramTypes .= 's';
        $params[] = $INTRODUCE;
    }
    if (!empty($LOCATION)) {
        $updateFields[] = "COL_LOCATION = ?";
        $paramTypes .= 's';
        $params[] = $LOCATION;
    }
    if (!empty($STATE)) {
        $updateFields[] = "COL_STATE = ?";
        $paramTypes .= 's';
        $params[] = $STATE;
    }
    if (!empty($REMARK)) {
        $updateFields[] = "COL_REMARK = ?";
        $paramTypes .= 's';
        $params[] = $REMARK;
    }
} else {
    echo json_encode(["success" => false, "message" => "無效的類別"]);
    exit;
}

// 檢查是否有需要更新的字段
if (!empty($updateFields)) {
    // 構建完整的 SQL 語句
    $tableName = ($category === 'artwork') ? 'artwork' : 'collection';
    $sql = "UPDATE $tableName SET " . implode(", ", $updateFields) . " WHERE " . ($category === 'artwork' ? "AK_ID" : "COL_ID") . " = ?";
    $paramTypes .= 's'; // 為 ID 添加參數類型
    $params[] = $artworkId; // 添加 artwork 或 collection ID 參數

    // 準備和執行 SQL 語句
    if ($stmt = $mysqli->prepare($sql)) {
        // 使用 bind_param 動態綁定參數
        $stmt->bind_param($paramTypes, ...$params);

        // 執行更新操作
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "更新成功"]);
        } else {
            echo json_encode(["success" => false, "message" => "更新失敗：" . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "SQL 準備失敗：" . $mysqli->error]);
    }
} else {
    echo json_encode(["success" => false, "message" => "沒有需要更新的字段"]);
}

$mysqli->close();
