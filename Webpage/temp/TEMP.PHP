<?php
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

            echo '<div class="col-12 col-md-4 col-xl-3" id="' . $id . '">';
            echo '<a style="text-decoration:none;color: black;" data-bs-toggle="offcanvas" href="#offcanvas' . $id . '" role="button" aria-controls="offcanvas' . $id . '">';
            echo '<div class="box">';
            echo '<img style="width: 100%; aspect-ratio: 1/1; object-fit: cover; object-position: center center; height: auto/ 100%;" src="' . $media . '" alt>';
            echo '<div class="textBox">';
            echo '<h2> ' . $name . ' </h2>';
            echo '</div></div></a>';
            echo '</div>';

            // Offcanvas 組件
            echo '<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas' . $id . '" aria-labelledby="offcanvasLabel' . $id . '">';
            echo '  <div class="offcanvas-header">';
            echo '    <h5 class="offcanvas-title" id="offcanvasLabel' . $id . '">' . $name . '</h5>';
            echo '    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>';
            echo '  </div>';
            echo '  <div class="offcanvas-body">';
            echo '    <img src="' . $media . '" alt="' . $name . '" style="width: 100%; object-fit: cover; margin-bottom: 20px;">';
            echo '    <p>創作日期: ' . $date . '</p>';
            echo '    <p>材質: ' . $row['AK_MATERIAL'] . '</p>';
            echo '    <p>尺寸: ' . $row['AK_SIZE'] . '</p>';
            echo '    <p>介紹: ' . (!empty($row['AK_INTRODUCE']) ? $row['AK_INTRODUCE'] : '無') . '</p>';
            echo '  </div>';
            echo '</div>';
        }

        if ($category == 'collection') {
            $id = $row['COL_ID'];
            $artist = $row['COL_ARTIST'];
            $name = $row['COL_NAME'];
            $old_media = isset($row['COL_MEDIA']) ? $row['COL_MEDIA'] : '';
            $media = str_replace('./', 'php/', $old_media);
            // 卡片顯示 (大圖示)

            echo '<div class="col-12 col-md-4 col-xl-3">';
            echo '<a style="text-decoration:none;color: black;" data-bs-toggle="offcanvas" href="#offcanvas' . $id . '" role="button" aria-controls="offcanvas' . $id . '">';
            echo '<div class="box">';
            echo '<img style="width: 100%; aspect-ratio: 1/1; object-fit: cover; object-position: center center; height: auto/ 100%;" src="' . $media . '" alt>';
            echo '<div class="textBox">';
            echo '<h2> ' . $name . ' </h2>';
            echo '<h3> ' . $artist . ' </h3>';
            echo '</div></div></a>';
            echo '</div>';

            // Offcanvas 組件
            echo '<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas' . $id . '" aria-labelledby="offcanvasLabel' . $id . '">';
            echo '  <div class="offcanvas-header">';
            echo '    <h5 class="offcanvas-title" id="offcanvasLabel' . $id . '">' . $name . '</h5>';
            echo '    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>';
            echo '  </div>';
            echo '  <div class="offcanvas-body">';
            echo '    <img src="' . $media . '" alt="' . $name . '" style="width: 100%; object-fit: cover; margin-bottom: 20px;">';
            echo '    <p>作者: ' . (!empty($artist) ? $artist : '無') . '</p>';
            echo '    <p>材質: ' . $row['COL_MATERIAL'] . '</p>';
            echo '    <p>尺寸: ' . $row['COL_SIZE'] . '</p>';
            echo '    <p>收藏日期: ' . (!empty($row['COL_GET_DATE']) ? $row['COL_GET_DATE'] : '無') . '</p>';
            echo '    <p>收藏價格: ' . (!empty($row['COL_PRICE']) ? $row['COL_PRICE'] : '無') . '</p>';
            echo '    <p>介紹: ' . (!empty($row['COL_INTRODUCE']) ? $row['COL_INTRODUCE'] : '無') . '</p>';
            echo '  </div>';
            echo '</div>';
        }
    }
    echo '</div>'; 
    echo '</div>';
    echo '</div>'; // Row end
}
