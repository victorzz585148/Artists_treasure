$(document).ready(function() {
    // Select2
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
    // 確認送出
    $('#en-btn').on('click', function() {
        let formData = $('#exhibitionForm').serializeArray();
        let previewText = '請確認以下資料是否正確：\n\n';
        let hasEmptyFields = false;

        $.each(formData, function(_, field) {
            if (field.value.trim() === '') {
                hasEmptyFields = true;
                previewText += `${field.name}: （未填寫）\n`;
            } else {
                previewText += `${field.name}: ${field.value}\n`;
            }
        });
        if (hasEmptyFields) {
            customAlert ('部分必要欄位未填寫，請檢查並補充資料。');
            return; // 終止函數，避免進一步提交表單
        }

        customConfirm(previewText + "\n是否要繼續送出？", function(result) {
            if (result) {
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
                    customAlert('展覽儲存成功！');
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
});

//時間判定
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

//--------------彈出視窗setting

function customConfirm(message, callback) {
    // 設置模態框的訊息
    $('#modalMessage').text(message);

    // 顯示模態框
    $('#customModal').show();

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


function customAlert(message) {
    $('#modalMessage').text(message);
    $('#customModal').show();
    $('#confirmBtn').text('確定').show();
    $('#cancelBtn').hide();  // 隱藏取消按鈕
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
    });
}
