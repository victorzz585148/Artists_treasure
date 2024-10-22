<?php
$servername = "localhost";
$username = "root";
$password = "Caidsjim2999!";
$dbname = "artists_treasure";

$conn = new mysqli($servername, $username, $password, $dbname);

// 檢查連接是否成功
if ($conn->connect_error) {
    die("連接失敗: " . $conn->connect_error);
}

// 指定儲存檔案的資料夾
$uploadDir = './uploads/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);  // 如果資料夾不存在，則創建
}

// 檢查是否上傳了文件
if (isset($_FILES['MEDIA']) && $_FILES['MEDIA']['error'] === 0) {
    // 取得所有文件名
    $files = scandir($uploadDir);
    $fileCount = count($files) - 2;  // 減去 "." 和 ".." 這兩個系統目錄
    
    // 生成新的文件名 (01, 02, 03, ...)
    $newFileName = str_pad($fileCount + 1, 2, '0', STR_PAD_LEFT) . '.' . pathinfo($_FILES['MEDIA']['name'], PATHINFO_EXTENSION);
    $uploadFilePath = $uploadDir . $newFileName;

    // 將文件移動到指定資料夾
    if (move_uploaded_file($_FILES['MEDIA']['tmp_name'], $uploadFilePath)) {
        // 返回文件路徑
        echo json_encode([
            'success' => true,
            'filePath' => $uploadFilePath
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => '文件移動失敗'
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => '無效的文件或上傳錯誤'
    ]);
}



//從 POST 接收表單資料
$TYPE_SELECT = $_POST['type_select'];
$NAME = $_POST['NAME'];
$MATERIAL = $_POST['MATERIAL'];
$LENGTH = $_POST['LENGTH'];
$WIDTH = $_POST['WIDTH'];
$SIGNATURE_Y = $_POST['SIGNATURE_Y'];
$SIGNATURE_M = $_POST['SIGNATURE_M'];
$THEME = $_POST['THEME'];
$INTRODUCE = $_POST['INTRODUCE'];
$LOCALTION = $_POST['LOCALTION'];
$GET_DATE = $_POST['GET_DATE'];
$PRICE = $_POST['PRICE'];
$ARTIST = $_POST['ARTIST'];
$REMARK = $_POST['REMARK'];
$STATE = $_POST['STATE'];
$DATE = date('Y-M-D');
$SIZE = $LENGHT . "," . $WIDTH;
$MEDIA = $uploadFilePath;

//準備 SQL 查詢
if($TYPE_SELECT === "ARTWORK") {
    $sql = "INSERT INTO `ARTWORK` (AK_DATE, AK_NAME, AK_MATERIAL, AK_SIZE, AK_SIGNATURE_Y, AK_SIGNATURE_M, AK_THEME, AK_INTRODUCE, AK_LOCATION, AK_MEDIA, AK_STATE, AK_REMARK) 
        VALUES ('$DATE', '$NAME', '$MATERIAL', '$SIZE', '$SIGNATURE_Y', '$SIGNATURE_M', '$THEME', '$INTRODUCE', '$LOCATION', '$MEDIA', '$STATE', '$REMARK')";
} elseif ($TYPE_SELECT === "CCOLLECTION") {
    $sql = "INSERT INTO `COLLECTION` (COL_DATE, COL_ARTIST, COL_NAME, COL_MATERIAL, COL_SIZE, COL_SIGNATURE_Y, COL_SIGNATURE_M, COL_THEME, COL_GET_DATE, COL_PRICE, COL_INTRODUCE, COL_LOCATION, COL_MEDIA, COL_STATE, COL_REMARK) 
        VALUES ('$DATE', '$ARTIST','$NAME', '$MATERIAL', '$SIZE', '$SIGNATURE_Y', '$SIGNATURE_M', '$THEME', '$GET_DATE', 'PRICE', '$INTRODUCE', '$LOCATION', '$MEDIA', '$STATE', '$REMARK')";
}
//執行 SQL 查詢
if ($conn->query($sql) === TRUE) {
    echo "新記錄插入成功!";
} else {
    echo "錯誤: " . $sql . "<br>" . $conn->error;
}

//關閉連接
$conn->close();
?>
