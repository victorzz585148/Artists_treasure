let isZoomed = false;  // 標誌位，防止重複觸發圖片放大

// 圖片預覽變更事件
document.getElementById('MEDIA').addEventListener('change', function(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('preview');

    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';  // 顯示圖片
        };
        reader.readAsDataURL(file);
    } else {
        preview.src = "";  // 如果未選擇圖片，重置為空
        preview.style.display = 'none';  // 隱藏圖片
    }
});

// 圖片點擊事件，放大顯示圖片
document.getElementById('preview').addEventListener('click', function() {
    const preview = document.getElementById('preview');
    const overlay = document.getElementById('overlay');

    // 如果已經放大，或者圖片不存在，則返回
    if (!preview.src || isZoomed) return;

    isZoomed = true;

    let clone = document.getElementById('preview-clone');
    if (!clone) {
        clone = document.createElement('img');
        clone.id = 'preview-clone';
        document.body.appendChild(clone);
    }

    clone.src = preview.src;
    clone.style.display = 'block';
    overlay.style.display = 'block';

    // 設置 clone 圖片的大小
    clone.style.position = 'fixed';
    clone.style.top = '50%';
    clone.style.left = '50%';
    clone.style.transform = 'translate(-50%, -50%)';
    clone.style.width = '800px';
    clone.style.height = '600px';
    clone.style.maxWidth = '90%';
    clone.style.maxHeight = '90%';
    clone.style.zIndex = '1001';
    clone.style.boxShadow = '0 0 20px rgba(0, 0, 0, 0.5)';
    overlay.style.display = 'block';
    preview.title = "再次點擊可以縮小圖片";
});

// 點擊遮罩或 clone 圖片時，隱藏圖片和遮罩
document.getElementById('overlay').addEventListener('click', function() {
    const clone = document.getElementById('preview-clone');
    const overlay = document.getElementById('overlay');

    if (clone) {
        clone.style.display = 'none';  // 隱藏圖片
    }
    overlay.style.display = 'none';  // 隱藏背景遮罩
    isZoomed = false;  // 重置標誌位，允許下次放大
});

// 開啟時執行
$(document).ready(function() {
    $('#type_select').select2({
        placeholder: "請選擇類別",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
    $('#state_select').select2({
        placeholder: "請選擇交易狀態",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });

    // 根據類別顯示或隱藏額外字段
    $('#type_select').on('change', function() {
        var selectedValue = $(this).val();
        if (selectedValue === 'COLLECTION') {
            $('.extra_fields').removeClass('hidden');
        } else {
            $('.extra_fields').addClass('hidden');
        }
    });
});

var isSubmitting = false;

// 表單提交事件處理
document.getElementById('savebutton').addEventListener('click', function(event) {
    // 新增檢查邏輯
    var typeSelectValue = $('#type_select').val();
    var stateSelectValue = $('#state_select').val();
    if (!typeSelectValue && !stateSelectValue && !form.checkValidity()) {
        alert("請選擇藝品類別、交易狀態及必填欄位尚未填寫。");
        form.classList.add('was-validated');
        return;
    } else if (!typeSelectValue && !stateSelectValue) {
        alert("請選擇藝品類別及交易狀態。");
        return;
    } else if (!form.checkValidity() && !stateSelectValue) {
        alert("請選擇交易狀態及必填欄位尚未填寫。");
        form.classList.add('was-validated');
        return;
    } else if (!typeSelectValue && !form.checkValidity()) {
        alert("請選擇藝品類別及必填欄位尚未填寫。");
        form.classList.add('was-validated');
        return;
    } else if (!typeSelectValue) {
        alert("請選擇藝品類別。");
        return;
    } else if (!stateSelectValue) {
        alert("請選擇交易狀態。");
        return;
    } else if (!form.checkValidity()) {
        alert("部分必填欄位尚未填寫。");
        form.classList.add('was-validated'); // 加上 Bootstrap 驗證樣式，顯示錯誤提示
        return;
    }
    if (isSubmitting) return;  // 防止重複提交
    isSubmitting = true;  // 設置為正在提交

    var form = document.getElementById('uploadForm');
    var typeSelect = $('#type_select').val();
    var stateSelect = $('#state_select').val();
    
    if (typeSelect === "ARTWORK") {
        var fieldsToExclude = document.querySelectorAll('#ARTIST,#GET_DATE');
        fieldsToExclude.forEach(function(field) {
            field.removeAttribute('required');
        });
    } 
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

// 禁止輸入科學符號"E"到數字欄位
function preventE(event) {
    if (event.key === 'e' || event.key === 'E') {
        event.preventDefault();
    }
}