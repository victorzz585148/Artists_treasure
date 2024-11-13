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

    // 過濾出有效的文件，並計算現有文件的數量
    $fileCount = 0;
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..' && is_file($uploadDir . $file)) {
            $fileCount++;
        }
    }

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
$REPRESENTATIVE = $_POST['REPRESENTATIVE'];
$ARTIST = $_POST['ARTIST'];
$NAME = $_POST['NAME'];
$MATERIAL = $_POST['MATERIAL'];
$LENGTH = $_POST['LENGTH'];
$WIDTH = $_POST['WIDTH'];
$SIGNATURE_Y = $_POST['SIGNATURE_Y'];
$SIGNATURE_M = !empty($_POST['SIGNATURE_M']) ? $_POST['SIGNATURE_M'] : 0;
$THEME = $_POST['THEME'];
$GET_DATE = $_POST['GET_DATE'];
$PRICE = $_POST['PRICE'];
$INTRODUCE = $_POST['INTRODUCE'];
$LOCATION = $_POST['LOCATION'];
$REMARK = $_POST['REMARK'];
$STATE = $_POST['state_select'];
$DATE = date('Y-m-d');
$SIZE = $LENGTH . "," . $WIDTH;
$MEDIA = $uploadFilePath;

//準備 SQL 查詢
if ($TYPE_SELECT === "ARTWORK") {
    $sql = "INSERT INTO `ARTWORK` (AK_DATE, AK_NAME, AK_MATERIAL, AK_SIZE, AK_SIGNATURE_Y, AK_SIGNATURE_M, AK_THEME, AK_INTRODUCE, AK_LOCATION, AK_MEDIA, AK_STATE, REPRESENTATIVE, AK_REMARK) 
            VALUES ('$DATE', '$NAME', '$MATERIAL', '$SIZE', '$SIGNATURE_Y', '$SIGNATURE_M', '$THEME', '$INTRODUCE', '$LOCATION', '$MEDIA', '$STATE', '$REPRESENTATIVE', '$REMARK')";
} elseif ($TYPE_SELECT === "COLLECTION") {
    $sql = "INSERT INTO `COLLECTION` (COL_DATE, COL_ARTIST, COL_NAME, COL_MATERIAL, COL_SIZE, COL_SIGNATURE_Y, COL_SIGNATURE_M, COL_THEME, COL_GET_DATE, COL_PRICE, COL_INTRODUCE, COL_LOCATION, COL_MEDIA, COL_STATE, COL_REMARK) 
            VALUES ('$DATE', '$ARTIST', '$NAME', '$MATERIAL', '$SIZE', '$SIGNATURE_Y', '$SIGNATURE_M', '$THEME', '$GET_DATE', '$PRICE', '$INTRODUCE', '$LOCATION', '$MEDIA', '$STATE', '$REMARK')";
}


// 執行 SQL 查詢
if ($conn->query($sql) === TRUE) {
    echo "新記錄插入成功！";
    $formSubmittedSuccessfully = true;  // 成功插入時設置為 true
} else {
    echo "錯誤：" . $sql . "<br>" . $conn->error;
    $formSubmittedSuccessfully = false;  // 插入失敗時設置為 false
}

// 關閉連接
$conn->close();

// 檢查表單提交是否成功
if (isset($formSubmittedSuccessfully) && $formSubmittedSuccessfully === true) {
    // 表單處理成功，重定向到 artwork_main.html 頁面
    header("Location: /artwork_main.html");
    exit();  // 確保後續代碼不會執行
} else {
    // 處理失敗，顯示錯誤訊息或其他操作
    echo "表單提交失敗，請重試。";
}