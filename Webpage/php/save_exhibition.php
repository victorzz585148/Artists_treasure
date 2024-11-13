<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$exhibitionName = $_POST['exhibitionName'] ?? '';
$exhibitionLocation = $_POST['exhibitionLocation'] ?? '';
$exhibitionStart = $_POST['exhibitionStart'] ?? '';
$exhibitionEnd = $_POST['exhibitionEnd'] ?? '';
$exhibitionInterduce = $_POST['exhibitionInterduce'] ?? '';
$exhibitionRemark = $_POST['exhibitionRemark'] ?? '';
$exhibitionOrganizer = $_POST['exhibitionOrganizer'] ?? '';
$artworks = $_POST['exhibitionArtworks'] ?? 0;
$aliases = $_POST['alias'] ?? '';

// $exhibitionId = 'EN' . str_pad(rand(1, 999999), 5, '0', STR_PAD_LEFT);
// $stmt = $mysqli->prepare("INSERT INTO exhibition (EN_ID, EN_NAME, EN_LOCATION, EN_START, EN_FINISH, EN_ITEM) VALUES (?, ?, ?, ?, ?, ?)");
$stmt = $mysqli->prepare("INSERT INTO exhibition (EN_LOCATION, EN_ORGANIZER, EN_NAME, EN_START, EN_FINISH, EN_ITEM, EN_INTRODUCE, EN_REMARK) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$artworkCount = count($artworks);
$stmt->bind_param('sssssiss', $exhibitionLocation, $exhibitionOrganizer, $exhibitionName, $exhibitionStart, $exhibitionEnd, $artworkCount, $exhibitionInterduce, $exhibitionRemark);
if (!$stmt->execute()) {
    die(json_encode(["success" => false, "message" => "插入展覽失敗：" . $stmt->error]));
}

// foreach ($artworks as $artworkId) {
//     $alias = $aliases[$artworkId] ?? '';
//     $stmtArt = $mysqli->prepare("INSERT INTO exhibition_details (EN_ID, AK_ID, END_NAME) VALUES (?, ?, ?)");
//     if ($stmtArt === false) {
//         die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
//     }
//     $stmtArt->bind_param('sss', $exhibitionId, $artworkId, $alias);
//     $stmtArt->execute();
//     $stmtArt->close();
// }
// 查找剛插入的 EN_ID（如果無法使用 insert_id 獲取）
$stmtGetId = $mysqli->prepare("SELECT EN_ID FROM exhibition WHERE EN_NAME = ? AND EN_LOCATION = ? AND EN_START = ?");
if ($stmtGetId === false) {
    die(json_encode(["success" => false, "message" => "SQL 查找語句失敗：" . $mysqli->error]));
}

$stmtGetId->bind_param('sss', $exhibitionName, $exhibitionLocation, $exhibitionStart);
$stmtGetId->execute();
$stmtGetId->bind_result($exhibitionId);
$stmtGetId->fetch();
$stmtGetId->close();

// 檢查是否成功獲取 EN_ID
if (!$exhibitionId) {
    die(json_encode(["success" => false, "message" => "無法獲取新插入的展覽 ID"]));
}

// 插入到 exhibitiondetail 表中
foreach ($artworks as $artworkId) {
    $alias = $aliases[$artworkId] ?? '';

    if (strpos($artworkId, 'AK') === 0) {
        // 插入作品 ID
        $stmtArt = $mysqli->prepare("INSERT INTO `EXHIBITIONDETAIL` (EN_ID, AK_ID, END_NAME) VALUES (?, ?, ?)");
        if ($stmtArt === false) {
            die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
        }
        $stmtArt->bind_param('sss', $exhibitionId, $artworkId, $alias);
    } elseif (strpos($artworkId, 'COL') === 0) {
        // 插入收藏 ID
        $stmtArt = $mysqli->prepare("INSERT INTO `EXHIBITIONDETAIL` (EN_ID, COL_ID, END_NAME) VALUES (?, ?, ?)");
        if ($stmtArt === false) {
            die(json_encode(["success" => false, "message" => "SQL 準備語句失敗：" . $mysqli->error]));
        }
        $stmtArt->bind_param('sss', $exhibitionId, $artworkId, $alias);
    } else {
        die(json_encode(["success" => false, "message" => "無效的輸入：ID 必須以 AK 或 COL 開頭。"]));
    }

    // 執行插入語句
    if (!$stmtArt->execute()) {
        die(json_encode(["success" => false, "message" => "插入展覽細節失敗：" . $stmtArt->error]));
    }

    $stmtArt->close();
}

$mysqli->close();
echo json_encode(["success" => true, "message" => "展覽儲存成功！"]);