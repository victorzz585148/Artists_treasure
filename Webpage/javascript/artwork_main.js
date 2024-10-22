let isZoomed = false;  // 標誌位，防止重複觸發

document.getElementById('MEDIA').addEventListener('change', function(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('preview');
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';  // 顯示圖片 A
        };
        reader.readAsDataURL(file);
    } else {
        preview.src = "";  // 如果未選擇圖片，重置為空
        preview.style.display = 'none';  // 隱藏圖片 A
    }
});


// 當點擊圖片 A 時，創建並顯示圖片 B
document.getElementById('preview').addEventListener('click', function() {
    const preview = document.getElementById('preview');
    const overlay = document.getElementById('overlay');
    
    // 檢查是否已經選擇了圖片，未選擇則不執行後續代碼
    if (!preview.src || isZoomed) return;

    isZoomed = true;  // 設置標誌位，避免重複觸發

    // 創建圖片 B 並設置為和 A 相同的圖片
    let clone = document.getElementById('preview-clone');
    if (!clone) {
        clone = document.createElement('img');
        clone.id = 'preview-clone';
        document.body.appendChild(clone);
    }
    
    clone.src = preview.src;
    clone.style.display = 'block';  // 顯示圖片 B
    overlay.style.display = 'block';  // 顯示背景遮罩


    // 設置 clone 圖片的大小
    clone.style.position = 'fixed';
    clone.style.top = '50%';
    clone.style.left = '50%';
    clone.style.transform = 'translate(-50%, -50%)';
    clone.style.width = '800px';  // 設定固定寬度
    clone.style.height = '600px';  // 設定固定高度
    clone.style.maxWidth = '90%';  // 限制最大寬度
    clone.style.maxHeight = '90%';  // 限制最大高度
    clone.style.zIndex = '1001';  // 保持在最上層
    clone.style.boxShadow = '0 0 20px rgba(0, 0, 0, 0.5)';  // 添加陰影效果
    overlay.style.display = 'block';  // 顯示背景遮罩
    preview.title = "再次點擊可以縮小圖片";  // 更改提示文字    
});


// 當點擊遮罩或圖片 B 時，隱藏圖片 B 和遮罩
document.getElementById('overlay').addEventListener('click', function() {
    const clone = document.getElementById('preview-clone');
    const overlay = document.getElementById('overlay');

    if (clone) {
        clone.style.display = 'none';  // 隱藏圖片 B
    }
    overlay.style.display = 'none';  // 隱藏背景遮罩
    isZoomed = false;  // 重置標誌位，允許下次觸發
});


//開啟時執行
$(document).ready(function() {
    //Select2 setting
    $('#type_select').select2({
        placeholder: "請選擇類別",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
    $('#state_select').select2({
        placeholder: "請選擇類別",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });

    //類別判定
    $('#type_select').on('change', function() {
        var selectedValue = $(this).val();
        if (selectedValue === 'COLLECTION') {
            $('.extra_fields').removeClass('hidden');
        } else {
            $('.extra_fields').addClass('hidden');
        }
    });
});


//表單送出必填欄位檢測
document.getElementById('savebutton').addEventListener('click', function(event) {
    var typeSelect = $('#type_select').val();
    var stateSelect = $('#state_select').val();
    var form = document.getElementById('uploadForm');
    if (!typeSelect || !stateSelect) {
        event.preventDefault();  // 阻止表單提交
        if (!typeSelect) {
            alert("請選擇藝品類別。");
        }else if (!stateSelect) {
            alert("請選擇交易狀態。");
        }
        return false;
    }
    // 檢查其他欄位的有效性
    if (!form.checkValidity()) {
        event.preventDefault();  // 阻止提交
        event.stopPropagation(); // 停止事件傳遞
        form.classList.add('was-validated');  // 加入 Bootstrap 驗證樣式
        return;
    }
   
    // 所有欄位有效，顯示確認對話框
    var confirmation = confirm("你確定要送出表單嗎？");
    if (confirmation) {
        // 使用者點擊了確認，提交表單
        alert("表單已儲存");
        document.getElementById('uploadForm').submit();
    } else if (!confirmation) {
        event.preventDefault();  // 如果使用者取消，則阻止表單提交
        alert("表單已取消儲存");
    }
});