<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // 接收來自表單的資料
    $artwork_name = $_POST['artwork_name'];
    $artist_name = $_POST['artist_name'];
    $creation_year = $_POST['creation_year'];
    $medium = $_POST['medium'];
    $description = $_POST['description'];

    // 連接資料庫
    $conn = new mysqli('localhost', 'username', 'password', 'database_name');

    // 檢查連接
    if ($conn->connect_error) {
        die("資料庫連接失敗: " . $conn->connect_error);
    }

    // 構建插入 SQL 語句
    $sql = "INSERT INTO ARTWORK (artwork_name, artist_name, creation_year, medium, description) 
            VALUES ('$artwork_name', '$artist_name', '$creation_year', '$medium', '$description')";

    // 執行 SQL 語句
    if ($conn->query($sql) === TRUE) {
        echo "<div class='alert alert-success'>資料新增成功</div>";
    } else {
        echo "<div class='alert alert-danger'>錯誤: " . $sql . "<br>" . $conn->error . "</div>";
    }

    // 關閉資料庫連接
    $conn->close();
}
?>
