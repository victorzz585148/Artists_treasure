$(document).ready(function() {
    // 初始化 Select2
    $('#exhibitionArtworks').select2({
        placeholder: '搜尋並選擇畫作',
        ajax: {
            url: './php/get_exhibition_artworks.php',
            type: 'POST',
            dataType: 'json',
            delay: 250,
            data: function(params) {
                let categorySelect = $('#categorySelect').val();
                return {
                    searchTerm: params.term,
                    categorySelect: categorySelect
                };
            },
            processResults: function(data) {
                return {
                    results: $.map(data, function(item) {
                        return {
                            id: item.id,
                            text: item.name
                        };
                    })
                };
            },
            cache: true
        }
    });

    // 展覽表單 - 選擇作品時添加至畫面
    $('#exhibitionArtworks').on('select2:select', function(e) {
        let selectedId = e.params.data.id;
        let selectedName = e.params.data.text;

        $('#selectedArtworksContainer').append(`
            <div class="artwork-item" id="artwork-${selectedId}" style="margin-bottom: 10px;">
                <span class="artwork-header">
                    <label>作品名稱：${selectedName}</label>
                    <button type="button" class="btn btn-sm btn-outline-danger remove-artwork-btn" onclick="removeArtwork('${selectedId}')">移除</button>
                </span>
                <br>
                <input type="text" placeholder="輸入別名（可選）" name="alias[${selectedId}]" style="margin-top: 5px;" autocomplete="off">
            </div>
        `);
    });

    // 移除作品
    window.removeArtwork = function(artworkId) {
        $(`#artwork-${artworkId}`).remove();
        let selectedItems = $('#exhibitionArtworks').val();
        selectedItems = selectedItems.filter(item => item !== artworkId);
        $('#exhibitionArtworks').val(selectedItems).trigger('change');
    };

    // 當取消選取時，移除相應的元素
    $('#exhibitionArtworks').on('select2:unselect', function(e) {
        let unselectedId = e.params.data.id;
        $(`#artwork-${unselectedId}`).remove();
    });

    // 確認送出按鈕的點擊事件
    $('#en-btn').on('click', function(event) {
        event.preventDefault(); // 阻止按鈕的預設提交行為
    
        console.log('送出按鈕被點擊'); // 這行可以確定按鈕的點擊是否被偵測
    
        let previewText = '請確認以下資料是否正確：<br><br>';
        let hasEmptyFields = false;
    
        // 定義欄位名稱的對應字典
        const fieldLabels = {
            'exhibitionName': '展覽名稱',
            'exhibitionLocation': '地點',
            'exhibitionOrganizer': '主辦單位',
            'exhibitionStart': '開始時間',
            'exhibitionEnd': '結束時間',
            'exhibitionInterduce': '展覽介紹', // 非必填
            'exhibitionRemark': '備註',         // 非必填
            'exhibitionArtworks[]': '參展作品',
        };
    
        // 檢查必填欄位是否填寫
        const requiredFields = [
            { selector: '#exhibitionName', label: '展覽名稱' },
            { selector: '#exhibitionLocation', label: '地點' },
            { selector: '#exhibitionOrganizer', label: '主辦單位' },
            { selector: '#exhibitionStart', label: '開始時間' },
            { selector: '#exhibitionEnd', label: '結束時間' }
        ];
    
        // 遍歷每個必填欄位，檢查是否為空
        requiredFields.forEach(function(field) {
            const value = $(field.selector).val().trim();
            if (value === '') {
                console.log(`必填欄位未填寫: ${field.label}`); // 這行可以檢查未填寫的欄位
                hasEmptyFields = true;
                previewText += `${field.label}: （未填寫）<br>`;
            } else {
                previewText += `${field.label}: ${value}<br>`;
            }
        });
    
        // 檢查參展作品是否選擇了至少一個
        const selectedArtworks = $('#exhibitionArtworks option:selected');
        if (!selectedArtworks || selectedArtworks.length === 0) {
            console.log('未選擇參展作品');
            hasEmptyFields = true;
            previewText += `參展作品: （未選擇）<br>`;
        } else {
            // 使用作品名稱
            const artworkNames = selectedArtworks.map(function() {
                return $(this).text();
            }).get();
            previewText += `參展作品: ${artworkNames.join(', ')}<br>`;
        }
    
        if (hasEmptyFields) {
            // 顯示未填寫的必填欄位提示
            console.log('有未填寫的必填欄位'); // 這行確認有未填的欄位
            customAlert('部分必要欄位未填寫，請檢查並補充資料。');
            return; // 終止函數，避免進一步提交表單
        }
    
        // 顯示確認的自訂模態框
        console.log('所有必填欄位已填寫，顯示確認視窗');
        customConfirm(previewText.trim() + "<br><br>是否要繼續送出？", function(result) {
            if (result) {
                console.log('用戶確認送出');
                $('#exhibitionForm').submit();
            }
        });
    });
        // 表單送出 AJAX 請求
        $('#exhibitionForm').on('submit', function(e) {
            e.preventDefault();
    
            // 再次檢查是否有選擇參展作品
            const selectedArtworks = $('#exhibitionArtworks').val();
            if (!selectedArtworks || selectedArtworks.length === 0) {
                customAlert('請至少選擇一個參展作品。');
                return; // 停止提交，避免發送空表單
            }
    
            $.ajax({
                url: 'php/save_exhibition.php',
                type: 'POST',
                data: $(this).serialize(),
                success: function(response) {
                    if (response) { // 確保有回傳值
                        customAlert('展覽儲存成功！', function() {
                            // 在確認彈出視窗後進行跳轉
                            window.location.href = 'exhibition_search.html';
                        });
                        $('#exhibitionForm')[0].reset();
                        $('#exhibitionArtworks').val(null).trigger('change');
                        $('#selectedArtworksContainer').empty();
                    } else {
                        customAlert('儲存失敗，伺服器未回傳資料，請再試一次。');
                    }
                },
                error: function() {
                    customAlert('儲存失敗，請再試一次。');
                }
            });
        }); 
        $('#cancelBtn').on('click', function() {
            // 當用戶按下取消按鈕時，跳轉回 exhibition_search.html
            window.location.href = 'exhibition_search.html';
        });   
});

// 時間判定
$('#exhibitionStart, #exhibitionEnd').on('change', function() {
    // 獲取開始和結束時間
    const startDate = new Date($('#exhibitionStart').val());
    const endDate = new Date($('#exhibitionEnd').val());

    // 檢查結束時間是否早於開始時間
    if (endDate < startDate) {
        customAlert('結束時間不能早於開始時間，請重新選擇。');
        $('#exhibitionEnd').val(''); // 清空結束時間的值
    }
});

//--------------彈出視窗設定

function customConfirm(message, callback) {
    // 設置模態框的訊息（使用 .html() 確保可以解析 HTML）
    $('#modalMessage').html(message); // 使用 .html() 來顯示訊息

    // 設置訊息為靠左對齊
    $('#modalMessage').css('text-align', 'left');

    // 顯示模態框
    $('#customModal').show();

    // 顯示取消按鈕和確定按鈕
    $('#confirmBtn').text('確定').show();
    $('#cancelBtn').text('取消').show();

    // 綁定確定按鈕的點擊事件
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        callback(true);  // 確定時回調 true
    });

    // 綁定取消按鈕的點擊事件
    $('#cancelBtn').off('click').on('click', function() {
        $('#customModal').hide();
        callback(false); // 取消時回調 false
    });
}



function customAlert(message, callback) {
    // 設置模態框的訊息
    $('#modalMessage').text(message);
    $('#customModal').show();

    // 設定確定按鈕文本並顯示
    $('#confirmBtn').text('確定').show();
    // 隱藏取消按鈕，因為這是一個簡單的警示視窗
    $('#cancelBtn').hide();

    // 綁定確定按鈕的點擊事件
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        if (typeof callback === 'function') {
            callback();  // 確認後執行回調
        }
    });
}

