
<?php
// 連接到資料庫
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

// 驗證連線
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// 獲取檢視模式和選擇的分類（使用 POST 方式）
$view_mode = isset($_POST['view_mode']) ? $_POST['view_mode'] : 'grid';
$category = isset($_POST['category']) ? $_POST['category'] : 'artwork';

// 根據選擇的分類查詢對應的資料表
if ($category == 'artwork') {
    // 查詢 artwork 資料表
    $query = "SELECT DISTINCT AK_ID,AK_DATE, AK_NAME, AK_MATERIAL, AK_SIZE, AK_SIGNATURE_Y, AK_SIGNATURE_M, AK_THEME, AK_INTRODUCE, AK_LOCATION, AK_MEDIA, AK_STATE, AK_REMARK FROM `artwork`";
} elseif ($category == 'collection') {
    // 查詢 collection 資料表
    $query = "SELECT DISTINCT COL_ID,COL_DATE, COL_ARTIST, COL_NAME, COL_MATERIAL, COL_SIZE, COL_SIGNATURE_Y, COL_SIGNATURE_M, COL_THEME, COL_GET_DATE, COL_PRICE, COL_INTRODUCE, COL_LOCATION, COL_MEDIA, COL_STATE, COL_REMARK FROM `collection`";
}

$result = $mysqli->query($query);

if ($result->num_rows > 0) {
    if ($view_mode == 'grid') {
        echo '<div class="row">';
        while ($row = $result->fetch_assoc()) {
            if ($category == 'artwork') {
                $id = $row['AK_ID'];
                $date = $row['AK_DATE'];
                $name = $row['AK_NAME'];
                $material = $row['AK_MATERIAL'];
                $size = $row['AK_SIZE'];
                $signature_y = $row['AK_SIGNATURE_Y'];
                $signature_m = $row['AK_SIGNATURE_M'];
                $theme = $row['AK_THEME'];
                $introduce = $row['AK_INTRODUCE'];
                $location = $row['AK_LOCATION'];
                $old_media = isset($row['AK_MEDIA']) ? $row['AK_MEDIA'] : '';
                $media = str_replace('./', 'php/', $old_media);
                $state = $row['AK_STATE'];
                $remark = $row['AK_REMARK'];
                // 卡片顯示 (大圖示)
                if ($state == 1) {
                    $state = '已出售';
                } else if ($state == 0) {
                    $state = '未出售';
                };

                echo '<div class="col-lg-4 col-md-6 mb-4">';
                echo '<div class="card" data-id="' . $id . '">';
                echo '<img src="' . $media . '" class="card-img-top" alt="Artwork Image">';
                echo '<div class="card-body">';
                echo '<h5 class="card-title">' . $name . '</h5>';
                echo '<p class="card-text">'. $state .'</p>';
                echo '<p class="card-text">' . $introduce . '</p>';
                echo '</div>';
                echo '</div>'; // Card end
                echo '</div>'; // Column end


            } elseif ($category == 'collection') {
                $date = $row['COL_DATE'];
                $artist = $row['COL_ARTIST'];
                $name = $row['COL_NAME'];
                $material = $row['COL_MATERIAL'];
                $size = $row['COL_SIZE'];
                $signature_y = $row['COL_SIGNATURE_Y'];
                $signature_m = $row['COL_SIGNATURE_M'];
                $theme = $row['COL_THEME'];
                $get_date = $row['COL_GET_DATE'];
                $price = $row['COL_PRICE'];
                $introduce = $row['COL_INTRODUCE'];
                $location = $row['COL_LOCATION'];
                $old_media = isset($row['COL_MEDIA']) ? $row['COL_MEDIA'] : '';
                $media = str_replace('./', 'php/', $old_media);
                $state = $row['COL_STATE'];
                $remark = $row['COL_REMARK'];  
            }
                // 卡片顯示 (大圖示)
                if ($state == 1) {
                    $state = '已出售';
                } else if ($state == 0) {
                    $state = '未出售';
                };
                echo '<div class="col-lg-4 col-md-6 mb-4">';
                echo '<div class="card">';
                echo '<img src="' . $media . '" class="card-img-top" alt="Artwork Image">';
                echo '<div class="card-body">';
                echo '<h5 class="card-title">' . $name . '</h5>';
                echo '<p class="card-text">'. $state .'</p>';
                echo '<p class="card-text">' . $introduce . '</p>';
                echo '</div>';
                echo '</div>'; // Card end
                echo '</div>'; // Column end

        }
        echo '</div>'; // Row end
    } elseif ($view_mode == 'list') {
        // 清單顯示
        echo '<ul class="list-group">';
        while ($row = $result->fetch_assoc()) {
            if ($category == 'artwork') {
                $id = $row['AK_ID'];
                $date = $row['AK_DATE'];
                $name = $row['AK_NAME'];
                $material = $row['AK_MATERIAL'];
                $size = $row['AK_SIZE'];
                $sizearray = explode(",", $size);
                $length = floatval($sizeArray[0]);
                $width = floatval($sizeArray[1]);
                $signature_y = $row['AK_SIGNATURE_Y'];
                $signature_m = $row['AK_SIGNATURE_M'];
                $theme = $row['AK_THEME'];
                $introducce = $row['AK_INTRODUCE'];
                $times = $row['AK_TIMES'];
                $racetimes = $row['AK_RACETIMES'];
                $location = $row['AK_LOCATION'];
                $media = $row['AK_MEDIA'];
                $state = $row['AK_STATE'];
                $remark = $row['AK_REMARK'];

                // 第一列：欄位名稱
                echo '<tr>';
                echo '<th>創作品編號</th>';
                echo '<th>建檔日期</th>';
                echo '<th>名稱</th>';
                echo '<th>材質</th>';
                echo '<th>長 (公分)</th>';
                echo '<th>寬 (公分)</th>';
                echo '<th>落款年</th>';
                echo '<th>落款月</th>';
                echo '<th>主題</th>';
                echo '<th>介紹</th>';
                echo '<th>已展覽次數</th>';
                echo '<th>已比賽次數</th>';
                echo '<th>存放位置</th>';
                echo '<th>備註</th>';
                echo '<th>圖片預覽</th>';
                echo '</tr>';

                // 第二列：欄位值
                echo '<tr>';
                echo '<td>' . htmlspecialchars($id, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($date, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($name, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($material, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($length, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($width, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($signature_y, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($signature_m, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($theme, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($introduce, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($times, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($racetimes, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($location, ENT_QUOTES) . '</td>';
                echo '<td>' . htmlspecialchars($remark, ENT_QUOTES) . '</td>';
                echo '<td><img src="php/uploads/' . htmlspecialchars($row['COL_MEDIA'], ENT_QUOTES) . '" alt="Artwork Image" style="width: 100px; height: auto;"></td>';
                echo '</tr>';

                echo '</table>';
            } elseif ($category == 'collection') {
                $date = $row['COL_DATE'];
                $artist = $row['COL_ARTIST'];
                $name = $row['COL_NAME'];
                $material = $row['COL_MATERIAL'];
                $size = $row['COL_SIZE'];
                $signature_y = $row['COL_SIGNATURE_Y'];
                $signature_m = $row['COL_SIGNATURE_M'];
                $theme = $row['COL_THEME'];
                $get_date = $row['COL_GET_DATE'];
                $price = $row['COL_PRICE'];
                $introduce = $row['COL_INTRODUCE'];
                $location = $row['COL_LOCATION'];
                $media = $row['COL_MEDIA'];
                $state = $row['COL_STATE'];
                $remark = $row['COL_REMARK'];

                echo '<li class="list-group-item">';
                echo '<h5>' . $title . '</h5>';
                echo '<p>' . $description . '</p>';
                echo '</li>';
            }
        }
        echo '</ul>';
    }
} else {
    echo "<p>無任何資料。</p>";
}

//刪除

$data = json_decode(file_get_contents('php://input'), true);
if (isset($data['ids']) && is_array($data['ids'])) {
    $ids = $data['ids'];

    // 使用佔位符來防止 SQL 注入
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $sql = "DELETE FROM artwork WHERE id IN ($placeholders)";
    $stmt = $conn->prepare($sql);

    // 動態綁定所有 ID 參數
    $stmt->bind_param(str_repeat('i', count($ids)), ...$ids);

    if ($stmt->execute()) {
        echo json_encode(array("success" => true));
    } else {
        echo json_encode(array("success" => false, "message" => "刪除操作失敗：" . $stmt->error));
    }

    $stmt->close();
} else {
    echo json_encode(array("success" => false, "message" => "未提供有效的 ID 列表"));
}

$mysqli->close();


