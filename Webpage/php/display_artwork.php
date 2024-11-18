<?php
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");
header('Content-Type: application/json; charset=utf-8');
// 驗證連線
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

//check view_mode
$view_mode = isset($_POST['view_mode']) ? $_POST['view_mode'] : 'grid';
$category = isset($_POST['category']) ? $_POST['category'] : 'artwork';

if ($category == 'artwork') {
    // 查詢 artwork 資料表
    $query = "SELECT DISTINCT * FROM `artwork`";
} elseif ($category == 'collection') {
    // 查詢 collection 資料表
    $query = "SELECT DISTINCT * FROM `collection`";
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
                $size = $row['AK_SIZE'];
                $size_parts = explode(",", $size);
                $length = isset($size_parts[0]) ? $size_parts[0] : '未知';
                $width = isset($size_parts[1]) ? $size_parts[1] : '未知';
                // 卡片顯示 (大圖示)

                echo '<div class="col-12 col-md-4 col-xl-3" id = "'. $id .'">';
                echo '<a style="text-decoration:none;color: black;" data-bs-toggle="offcanvas" href="#offcanvas' . $id . '" role="button" aria-controls="offcanvas' . $id . '"><div class="box">';
                echo '<img style="width: 100%;aspect-ratio: 1/1;object-fit: cover;object-position: center center;height: auto/ 100%;" src="' . $media .'" alt>';
                echo '<div class="textBox">';
                echo '<h2> '. $name .' </h2>';
                echo '</div>';
                echo '</a>';
                echo '<button class="btn btn-primary edit-btn" data-bs-toggle="modal" data-bs-target="#editModal" data-id="'. $id .'">修改</button>';
                echo '<button class="btn btn-danger delete-btn" data-id="' . $id . '">刪除</button>';
                echo '</div>';
                echo '</div>';

                // 右滑欄位
                echo '<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas' . $id . '" aria-labelledby="offcanvasLabel' . $id . '">';
                echo '  <div class="offcanvas-header">';
                echo '    <h5 class="offcanvas-title" id="offcanvasLabel' . $id . '">' . $name . '</h5>';
                echo '    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>';
                echo '  </div>';
                echo '  <div class="offcanvas-body">';
                echo '    <img src="' . $media . '" alt="' . $name . '" style="width: 100%; object-fit: cover; margin-bottom: 20px;">';
                echo '    <p>建檔日期: ' . $date . '</p>';
                echo '    <p>材質: ' . $row['AK_MATERIAL'] . '</p>';
                echo '    <p>尺寸: 長 ' . $length . ' cm, 寬 ' . $width . ' cm</p>';
                echo '    <p>落款年: '. (!empty($row['AK_SIGNATURE_Y']) ? $row['AK_SIGNATURE_Y'] . '年' : '無') .'</p>';
                echo '    <p>落款月: '. (!empty($row['AK_SIGNATURE_M']) ? $row['AK_SIGNATURE_M'] . '月' : '無') .'</p>';
                echo '    <p>主題:'. (!empty($row['AK_THEME']) ? $row['AK_THEME'] : '無') .'</p>';
                echo '    <p class = "introduce">介紹: ' . (!empty($row['AK_INTRODUCE']) ? $row['AK_INTRODUCE'] : '無') . '</p>';
                echo '    <p>存放位置: '. (!empty($row['AK_LOCATION']) ? $row['AK_LOCATION'] : '未知') .'</p>';
                echo '    <p>已展覽次數: '. (!empty($row['AK_TIMES']) ? $row['AK_TIMES'] : 0) .'</p>';
                echo '    <p>已交易次數: '. (!empty($row['AK_RACETIMES']) ? $row['AK_RACETIMES'] : 0) .'</p>';
                echo '    <p>交易狀態: '. ($row['AK_STATE'] == 1 ? '已出售' : '未出售') .'</p>';
                echo '    <p class = "remark">註解: ' . (!empty($row['AK_REMARK']) ? $row['AK_REMARK'] : '無') . '</p>';
                echo '  </div>';
                echo '</div>';

            }
            if ($category == 'collection') {
                $id = $row['COL_ID'];
                $artist = $row['COL_ARTIST'];
                $name = $row['COL_NAME'];
                $old_media = isset($row['COL_MEDIA']) ? $row['COL_MEDIA'] : '';
                $media = str_replace('./', 'php/', $old_media);
                $size = $row['COL_SIZE'];
                $size_parts = explode(",", $size);
                $length = isset($size_parts[0]) ? $size_parts[0] : '未知';
                $width = isset($size_parts[1]) ? $size_parts[1] : '未知';
                // 卡片顯示 (大圖示)
                echo '<div class="col-12 col-md-4 col-xl-3">';
                echo '<a style="text-decoration:none;color: black;" data-bs-toggle="offcanvas" href="#offcanvas' . $id . '" role="button" aria-controls="offcanvas' . $id . '"><div class="box">';
                echo '<img style="width: 100%;aspect-ratio: 1/1;object-fit: cover;object-position: center center;height: auto/ 100%;" src="' . $media .'" alt>';
                echo '<div class="textBox">';
                echo '<h2> '. $name .' </h2>';
                echo '<h5> '. $artist .' </h5>';
                echo '</div></a>';
                echo '<button class="btn btn-primary edit-btn" data-bs-toggle="modal" data-bs-target="#editModal" data-id="'. $id .'">修改</button>';
                echo '<button class="btn btn-danger delete-btn" data-id="' . $id . '">刪除</button>';
                echo '</div>';
                echo '</div>';

                // 右滑欄位
                echo '<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas' . $id . '" aria-labelledby="offcanvasLabel' . $id . '">';
                echo '  <div class="offcanvas-header">';
                echo '    <h5 class="offcanvas-title" id="offcanvasLabel' . $id . '">' . $name . '</h5>';
                echo '    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>';
                echo '  </div>';
                echo '  <div class="offcanvas-body">';
                echo '    <img src="' . $media . '" alt="' . $name . '" style="width: 100%; object-fit: cover; margin-bottom: 20px;">';
                echo '    <p>建檔日期: ' . $row['COL_DATE'] . '</p>';
                echo '    <p>作者: ' . (!empty($artist) ? $artist : '無') . '</p>';
                echo '    <p>材質: ' . $row['COL_MATERIAL'] . '</p>';
                echo '    <p>尺寸: 長 ' . $length . ' cm, 寬 ' . $width . ' cm</p>';
                echo '    <p>落款年: '. (!empty($row['COL_SIGNATURE_Y']) ? $row['COL_SIGNATURE_Y'] . '年' : '無') .'</p>';
                echo '    <p>落款月: '. (!empty($row['COL_SIGNATURE_M']) ? $row['COL_SIGNATURE_M'] . '月' : '無') .'</p>';
                echo '    <p>收藏日期: ' . (!empty($row['COL_GET_DATE']) ? $row['COL_GET_DATE'] : '無') . '</p>';
                echo '    <p>收藏價格: ' . (!empty($row['COL_PRICE']) ? '新台幣 ' . $row['COL_PRICE'] . ' 元' : '未知') . '</p>';
                echo '    <p class = "introduce">介紹: ' . (!empty($row['COL_INTRODUCE']) ? $row['COL_INTRODUCE'] : '無') . '</p>';
                echo '    <p>已展覽次數: '. (!empty($row['COL_TIMES']) ? $row['COL_TIMES'] : 0) .'</p>';
                echo '    <p>已交易次數: '. (!empty($row['COL_RACETIMES']) ? $row['COL_RACETIMES'] : 0) .'</p>';
                echo '    <p>存放位置: '. (!empty($row['COL_LOCATION']) ? $row['COL_LOCATION'] : '未知') .'</p>';
                echo '    <p>交易狀態: '. ($row['COL_STATE'] == 1 ? '已出售' : '未出售') .'</p>';
                echo '    <p class = "remark">註解: ' . (!empty($row['COL_REMARK']) ? $row['COL_REMARK'] : '無') . '</p>';
                echo '  </div>';
                echo '</div>';
            }
        }
        echo '</div>'; 
        echo '</div>';
        echo '</div>';// Row end
    } 
} else {
    echo "<p>無任何資料。</p>";
}

$mysqli->close();
