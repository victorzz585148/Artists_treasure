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

$(document).ready(function() {
    // 初始化 Select2
    $('#type_select').select2({
        placeholder: "請選擇類別",
        allowClear: true, // 允許清除選擇
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
    $('#state_select').select2({
        placeholder: "請選擇類別",
        allowClear: true, // 允許清除選擇
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
    $('#type_select').on('change', function() {
        var selectedValue = $(this).val();
        if (selectedValue === 'COLLECTION') {
            $('.extra_fields').removeClass('hidden');
        } else {
            $('.extra_fields').addClass('hidden');
        }
    });
});

//確認必填欄位
document.getElementById('savebutton').addEventListener('click', function(event) {
    // 取得表單中的值
    //必填欄位
    var ARTIST = document.getElementById('ARTIST').value.trim();
    var NAME = document.getElementById('NAME').value.trim();
    var SIGNATURE_Y = document.getElementById('SIGNATURE_Y').value.trim();
    var LOCALTION = document.getElementById('LOCALTION').value.trim();
    var MATERIAL = document.getElementById('MATERIAL').value.trim();
    var LENGTH = document.getElementById('LENGTH').value.trim();
    var WIDTH = document.getElementById('WIDTH').value.trim();
    var GET_DATE = document.getElementById('GET_DATE').value.trim();
    var type_select = $('#type_select').val();  // Select2 下拉選單的值--type
    var state_select = $('#state_select').val();  // Select2 下拉選單的值--state
    

    // 檢查必填欄位是否有填寫
    if (type_select === "" || state_select === "") {
        alert("請選取下拉選單之選項");
    } else if (type_select === "ARTWORK") {
        if (NAME === "" || SIGNATURE_Y === "" || LOCALTION === "" || MATERIAL === "" || LENGTH === "" || WIDTH === "") {
            alert("請填寫所有必填欄位");
        }
    } else if (type_select === "COLLECTION") {
        if (ARTIST === "" || NAME === "" || SIGNATURE_Y === "" || LOCALTION === "" || MATERIAL === "" || LENGTH === "" || WIDTH === "" || GET_DATE === "") {
            alert("請填寫所有必填欄位");
        }
    } else {
        // 彈出確認對話框
        var confirmation = confirm("你確定要送出表單嗎？");

        if (confirmation) {
            // 使用者點擊了確認，提交表單
            document.getElementById('myForm').submit();
        } else {
            // 使用者點擊了取消，不送出表單
            alert("表單已取消送出");
        }}
});

document.getElementById('savebutton').addEventListener('click', function(event) {
    // 最終提交表單
    var form = document.getElementById('myForm');
    form.submit();  // 提交表單
});