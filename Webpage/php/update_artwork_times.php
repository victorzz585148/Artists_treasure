<?php
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $artworkId = $_POST['id'];
    $increment = intval($_POST['increment']);

    // 根據 ID 前綴來確定是 AK 還是 COL
    if (strpos($artworkId, 'AK') === 0) {
        $query = "UPDATE artwork SET AK_TIMES = COALESCE(AK_TIMES, 0) + ? WHERE AK_ID = ?";
    } elseif (strpos($artworkId, 'COL') === 0) {
        $query = "UPDATE `collection` SET COL_TIMES = COALESCE(COL_TIMES, 0) + ? WHERE COL_ID = ?";
    } else {
        echo json_encode(['success' => false, 'message' => '無效的 ID']);
        exit;
    }

    $stmt = $conn->prepare($query);
    $stmt->bind_param("is", $increment, $artworkId);
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => '無法更新畫作次數']);
    }
}
?>
