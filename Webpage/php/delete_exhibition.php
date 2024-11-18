<?php
header('Content-Type: application/json');

// 引入數據庫連接
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['id'])) {
        $exhibitionId = $_POST['id'];

        // 先刪除 exhibitiondetail 中的紀錄
        $sqlDetail = "DELETE FROM exhibitiondetail WHERE EN_ID = ?";
        $stmtDetail = $conn->prepare($sqlDetail);

        if (!$stmtDetail) {
            echo json_encode(['success' => false, 'message' => 'SQL 準備錯誤: ' . $conn->error]);
            $conn->close();
            exit();
        }

        $stmtDetail->bind_param("s", $exhibitionId);

        if (!$stmtDetail->execute()) {
            echo json_encode(['success' => false, 'message' => '無法刪除展覽詳細紀錄: ' . $stmtDetail->error]);
            $stmtDetail->close();
            $conn->close();
            exit();
        }

        $stmtDetail->close();

        // 再刪除 exhibition 表中的紀錄
        $sqlExhibition = "DELETE FROM exhibition WHERE EN_ID = ?";
        $stmtExhibition = $conn->prepare($sqlExhibition);

        if (!$stmtExhibition) {
            echo json_encode(['success' => false, 'message' => 'SQL 準備錯誤: ' . $conn->error]);
            $conn->close();
            exit();
        }

        $stmtExhibition->bind_param("s", $exhibitionId);

        if ($stmtExhibition->execute()) {
            // 刪除成功
            echo json_encode(['success' => true]);
        } else {
            // 刪除 exhibition 表失敗
            echo json_encode(['success' => false, 'message' => '無法刪除展覽: ' . $stmtExhibition->error]);
        }

        $stmtExhibition->close();
        $conn->close();
    } else {
        echo json_encode(['success' => false, 'message' => '未提供展覽 ID']);
    }
} else {
    echo json_encode(['success' => false, 'message' => '請求方法不正確']);
}

exit();
