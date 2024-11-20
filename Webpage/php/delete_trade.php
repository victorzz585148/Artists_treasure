<?php
header('Content-Type: application/json');

// 引入數據庫連接
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['id'])) {
        $tradeId = $_POST['id'];

        // 先刪除 tradedetail 中的紀錄
        $sqlDetail = "DELETE FROM TRADEDETAIL WHERE TDE_ID = ?";
        $stmtDetail = $conn->prepare($sqlDetail);

        if (!$stmtDetail) {
            echo json_encode(['success' => false, 'message' => 'SQL 準備錯誤: ' . $conn->error]);
            $conn->close();
            exit();
        }

        $stmtDetail->bind_param("s", $tradeId);

        if (!$stmtDetail->execute()) {
            echo json_encode(['success' => false, 'message' => '無法刪除展覽詳細紀錄: ' . $stmtDetail->error]);
            $stmtDetail->close();
            $conn->close();
            exit();
        }

        $stmtDetail->close();

        // 再刪除 trade 表中的紀錄
        $sqltrade = "DELETE FROM TRADE WHERE TDE_ID = ?";
        $stmttrade = $conn->prepare($sqltrade);

        if (!$stmttrade) {
            echo json_encode(['success' => false, 'message' => 'SQL 準備錯誤: ' . $conn->error]);
            $conn->close();
            exit();
        }

        $stmttrade->bind_param("s", $tradeId);

        if ($stmttrade->execute()) {
            // 刪除成功
            echo json_encode(['success' => true]);
        } else {
            // 刪除 trade 表失敗
            echo json_encode(['success' => false, 'message' => '無法刪除展覽: ' . $stmttrade->error]);
        }

        $stmttrade->close();
        $conn->close();
    } else {
        echo json_encode(['success' => false, 'message' => '未提供交易 ID']);
    }
} else {
    echo json_encode(['success' => false, 'message' => '請求方法不正確']);
}

exit();
