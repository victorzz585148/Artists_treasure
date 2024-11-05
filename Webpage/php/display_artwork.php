<?php
// header("Access-Control-Allow-Origin: *");
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

// 驗證連線
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

//check view_mode
$view_mode = isset($_POST['view_mode']) ? $_POST['view_mode'] : 'grid';
$category = isset($_POST['category']) ? $_POST['category'] : 'artwork';

if ($category == 'artwork') {
    // 查詢 artwork 資料表
    $query = "SELECT DISTINCT AK_ID,AK_DATE, AK_NAME, AK_MATERIAL, AK_SIZE, AK_SIGNATURE_Y, AK_SIGNATURE_M, AK_THEME, AK_INTRODUCE, AK_LOCATION, AK_MEDIA, AK_STATE, AK_REMARK FROM `artwork`";
} elseif ($category == 'collection') {
    // 查詢 collection 資料表
    $query = "SELECT DISTINCT COL_ID,COL_DATE, COL_ARTIST, COL_NAME, COL_MATERIAL, COL_SIZE, COL_SIGNATURE_Y, COL_SIGNATURE_M, COL_THEME, COL_GET_DATE, COL_PRICE, COL_INTRODUCE, COL_LOCATION, COL_MEDIA, COL_STATE, COL_REMARK FROM `collection`";
}

$result = $mysqli->query($query);//check y/n get infomation

if ($result->num_rows > 0) {
    if ($view_mode == 'grid') {
        echo '<div class="row">';
        echo '<div class="col-12 col-md-9 col-xl-10 b">';
        echo '<div class="row row-gap-4">';
        while ($row = $result->fetch_assoc()) {
            if ($category == 'artwork') {
                $id = $row['AK_ID'];
                $date = $row['AK_DATE'];
                $name = $row['AK_NAME'];
                $old_media = isset($row['AK_MEDIA']) ? $row['AK_MEDIA'] : '';
                $media = str_replace('./', 'php/', $old_media);
                // 卡片顯示 (大圖示)

                echo '<div class="col-12 col-md-4 col-xl-3">';
                echo '<a style="text-decoration:none;color: black;" href="./open_images.html"><div class="box">';
                echo '<img src="' . $media .'" alt>';
                echo '<div class="textBox">';
                echo '<h2> '. $name .' </h2>';
                echo '</div></a>';
                echo '</div>';
                echo '</div>';

            }
            if ($category == 'collection') {
                $artist = $row['COL_ARTIST'];
                $name = $row['COL_NAME'];
                $old_media = isset($row['COL_MEDIA']) ? $row['COL_MEDIA'] : '';
                $media = str_replace('./', 'php/', $old_media);
                // 卡片顯示 (大圖示)
                echo '<div class="col-12 col-md-4 col-xl-3">';
                echo '<a style="text-decoration:none;color: black;" href="./open_images.html"><div class="box">';
                echo '<img src="' . $media .'" alt>';
                echo '<div class="textBox">';
                echo '<h2> '. $name .' </h2>';
                echo '<h3> '. $artist .' </h3>';
                echo '</div></a>';
                echo '</div>';
                echo '</div>';
            }


        }
        echo '</div>'; 
        echo '</div>';
        echo '</div>';// Row end
    } elseif ($view_mode == 'list') {
        // 清單顯示
        
        }
} else {
    echo "<p>無任何資料。</p>";
}

$mysqli->close();
