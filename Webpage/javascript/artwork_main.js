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
    $('#REPRESENTATIVE').select2({
        placeholder: "請選擇交易狀態",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });

    // 根據類別顯示或隱藏額外字段
    $('#type_select').on('change', function() {
        var selectedValue = $(this).val();
        if (selectedValue === 'COLLECTION') {
            $('.extra_fields').removeClass('hidden');
            $('#REPRESENTATIVE option[value="1"]').prop('disabled', true);
            $('#REPRESENTATIVE').val('0').trigger('change'); // 將作品狀態設為普通作品
        } else {
            $('.extra_fields').addClass('hidden');
            $('#REPRESENTATIVE option[value="1"]').prop('disabled', false);
        }
    });
    // 初始化 Select2 選單
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
        $('#REPRESENTATIVE').select2({
            placeholder: "請選擇交易狀態",
            minimumResultsForSearch: Infinity,
            width: '150px'
        });
    });
});
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
//取得POST資料
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('uploadForm');
    const saveButton = document.getElementById('savebutton');
    const typeSelect = document.getElementById('type_select');
    const artistFieldDiv = document.getElementById('ARTIST').parentElement;
    const getDateFieldDiv = document.getElementById('GET_DATE').parentElement;
    const artistField = document.getElementById('ARTIST');
    const getDateField = document.getElementById('GET_DATE');
    const extraFields = document.querySelectorAll('.extra_fields');

    saveButton.addEventListener('click', function(event) {
        console.log('type_select:', $('#type_select').val());
        console.log('state_select:', $('#state_select').val());
        event.preventDefault(); // 阻止默認提交行為，先進行驗證
        // 依據類別進行必填屬性的動態設置
        const selectedType = typeSelect.value;
        if (selectedType === 'COLLECTION') {
            // 設置「收藏品」的必填屬性
            artistField.setAttribute('required', 'required');
            getDateField.setAttribute('required', 'required');
        } else if (selectedType === 'ARTWORK') {
            // 移除「創作品」不需要的必填屬性
            artistField.removeAttribute('required');
            getDateField.removeAttribute('required');
        }
    // 初始化選擇類別後的必填邏輯
    typeSelect.addEventListener('change', function() {
        const selectedType = typeSelect.value;

        if (selectedType === 'COLLECTION') {
            // 收藏品類別 - 顯示並設置收藏品相關欄位的必填屬性
            extraFields.forEach(function(field) {
                field.classList.remove('hidden'); // 顯示相關欄位
                const inputs = field.querySelectorAll('input');
                inputs.forEach(function(input) {
                    input.setAttribute('required', 'required'); // 添加必填屬性
                });
            });
        } else if (selectedType === 'ARTWORK') {
            // 創作品類別 - 隱藏並取消收藏品相關欄位的必填屬性
            extraFields.forEach(function(field) {
                field.classList.add('hidden'); // 隱藏相關欄位
                const inputs = field.querySelectorAll('input');
                inputs.forEach(function(input) {
                    input.removeAttribute('required'); // 移除必填屬性
                });
            });
        }
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
        // 新增檢查邏輯
        var typeSelectValue = $('#type_select').val();
        var stateSelectValue = $('#state_select').val();
        var REPRESENTATIVEValue = $('#REPRESENTATIVE').val();
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
        //定義key的名稱
        const fieldNames = {
            'ARTIST': '作者',
            'NAME': '名稱',
            'MATERIAL': '材質',
            'LENGTH': '長',
            'WIDTH': '寬',
            'SIGNATURE_Y': '落款年',
            'SIGNATURE_M': '落款月',
            'THEME': '主題',
            'GET_DATE': '收藏日期',
            'PRICE': '收藏價格',
            'INTRODUCE': '介紹',
            'LOCATION': '存放位置',
            'REMARK': '備註'
        };
        // 使用 FormData 對象來獲取表單所有數據
        const formData = new FormData(form);
        
        // 構建表單輸入值的訊息
        let form_message = "請確認輸入的資料是否正確。\n";
        // 顯示藝品類別
        if (typeSelectValue === 'ARTWORK') {
            form_message += "藝品類別: 創作品\n";
        } else if (typeSelectValue === 'COLLECTION') {
            form_message += "藝品類別: 收藏品\n";
        }
        // 顯示交易狀態
        if (stateSelectValue === '1') {
            form_message += "交易狀態: 已出售\n";
        } else if (stateSelectValue === '0') {
            form_message += "交易狀態: 未出售\n";
        }
        // 顯示作品狀態
        if (REPRESENTATIVEValue === '1') {
            form_message += "作品狀態: 代表作品\n";
        } else if (REPRESENTATIVEValue === '0') {
            form_message += "交易狀態: 普通作品\n";
        }

        if (typeSelectValue === 'ARTWORK') {
            formData.forEach((value, key) => {
                if (key !== 'REPRESENTATIVE' && key !== 'state_select' && key !== 'type_select' && key !== 'MEDIA' && key !== 'ARTIST' && key !== 'GET_DATE' && key !== 'PRICE') {
                    const fieldName = fieldNames[key] ? fieldNames[key] : key;
                    form_message += `${fieldName}: ${value ? value : '無'}\n`;
                }
            });
        } else if (typeSelectValue === 'COLLECTION') {
            formData.forEach((value, key) => {
                if (key !== 'REPRESENTATIVE' && key !== 'state_select' && key !== 'type_select' && key !== 'MEDIA') {  // 排除 MEDIA 本身的內容
                    const fieldName = fieldNames[key] ? fieldNames[key] : key;
                    form_message += `${fieldName}: ${value ? value : '無'}\n`;
                }
            });
        }

        // 獲取 MEDIA 檔案名稱
        const mediaInput = document.getElementById('MEDIA');
        if (mediaInput && mediaInput.files.length > 0) {
            const mediaFileName = mediaInput.files[0].name; // 獲取上傳的檔案名稱
            form_message += `預覽圖: ${mediaFileName}\n`; // 顯示檔案名稱
        } else {
            form_message += `預覽圖: 無\n`; // 如果沒有上傳檔案，顯示「無」
        }
        // 顯示確認框以確認資料是否正確
        const dataConfirmation = confirm(form_message);
        if (dataConfirmation) {
            // 如果資料正確，進一步詢問是否送出表單
            const finalConfirmation = confirm("資料已確認，是否要送出表單？");
            if (finalConfirmation) {
                // 清除表單緩存並提交表單
                form.submit();
                clearFormData();
            }
    }
});

    // 禁止表單的緩存，防止在返回上一頁或重整頁面時顯示舊資料
    function clearFormData() {
        // 清空所有表單字段
        form.reset();
        // 清除 Select2 的選擇
        $('#type_select').val(null).trigger('change');
        $('#state_select').val(null).trigger('change');
        $('#REPRESENTATIVE').val(null).trigger('change');
    }

    // 每次重整網頁或返回頁面時，清空表單的值
    window.addEventListener("pageshow", function(event) {
        if (event.persisted) {
            form.reset();
            $('#type_select').val(null).trigger('change');
            $('#state_select').val(null).trigger('change');
            $('#REPRESENTATIVE').val(null).trigger('change');
        }
    }); 
});
// 禁止輸入科學符號"E"到數字欄位
function preventE(event) {
    if (event.key === 'e' || event.key === 'E') {
        event.preventDefault();
    }
}