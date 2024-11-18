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
                return {
                    searchTerm: params.term,
                    categorySelect: $('#categorySelect').val()
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

    // 加載展覽資料
    const urlParams = new URLSearchParams(window.location.search);
    const exhibitionId = urlParams.get('id');

    if (exhibitionId) {
        $.ajax({
            url: 'php/get_exhibition_details.php',
            type: 'POST',
            data: { id: exhibitionId },
            success: function(response) {
                const exhibition = JSON.parse(response);
                $('#exhibitionId').val(exhibitionId);
                $('#exhibitionName').val(exhibition.name);
                $('#exhibitionLocation').val(exhibition.location);
                $('#exhibitionOrganizer').val(exhibition.organizer);
                $('#exhibitionStart').val(exhibition.start_date);
                $('#exhibitionEnd').val(exhibition.end_date);
                $('#exhibitionInterduce').val(exhibition.introduce);
                $('#exhibitionRemark').val(exhibition.remark);

                // 填充參展作品
                let selectedArtworks = [];
                $('#exhibitionArtworks').empty();
                $('#selectedArtworksContainer').empty(); // 清空之前的顯示容器

                exhibition.artworks.forEach(function(artwork) {
                    $('#exhibitionArtworks').append(new Option(artwork.name, artwork.id, true, true));
                    selectedArtworks.push(artwork.id);

                    // 在容器中顯示作品，包括別名輸入框
                    $('#selectedArtworksContainer').append(`
                        <div class="artwork-item" id="artwork-${artwork.id}" style="margin-bottom: 10px;">
                            <span class="artwork-header">
                                <label>作品名稱：${artwork.name}</label>
                                <button type="button" class="btn btn-sm btn-outline-danger remove-artwork-btn" onclick="removeArtwork('${artwork.id}')">移除</button>
                            </span>
                            <br>
                            <input type="text" placeholder="輸入別名（可選）" name="alias[${artwork.id}]" value="${artwork.alias || ''}" style="margin-top: 5px;" autocomplete="off">
                        </div>
                    `);
                });
                $('#exhibitionArtworks').val(selectedArtworks).trigger('change');
            },
            error: function() {
                alert("無法加載展覽資料，請稍後再試。");
            }
        });
    }

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

    // 保存修改按鈕事件
    $('#saveEditExhibitionBtn').on('click', function() {
        // 讀取隱藏欄位中的展覽 ID
        var exhibitionId = $('#exhibitionId').val();
        if (!exhibitionId) {
            console.error("展覽 ID 未找到");
            alert("展覽 ID 缺失，無法保存更改。請刷新頁面並重試。");
            return; // 提前退出，避免進一步操作
        }
    
        // 構造確認信息的文本
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
            'exhibitionArtworks[]': '參展作品'
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
                console.log(`必填欄位未填寫: ${field.label}`);
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
            console.log('有未填寫的必填欄位');
            customAlert('部分必要欄位未填寫，請檢查並補充資料。');
            return; // 終止函數，避免進一步提交表單
        }
    
        // 顯示確認的自訂模態框
        console.log('所有必填欄位已填寫，顯示確認視窗');
        customConfirm(previewText.trim() + "<br><br>是否要繼續保存？", function(result) {
            if (result) {
                console.log('用戶確認保存');
                saveUpdatedExhibition();
            }
        });
    });
    
    // 保存展覽的函數
    function saveUpdatedExhibition() {
        var exhibitionId = $('#exhibitionId').val();
        var name = $('#exhibitionName').val();
        var start_date = $('#exhibitionStart').val();
        var end_date = $('#exhibitionEnd').val();
        var location = $('#exhibitionLocation').val();
        var organizer = $('#exhibitionOrganizer').val();
        var introduce = $('#exhibitionInterduce').val(); // 修正為與 HTML 相符
        var remark = $('#exhibitionRemark').val();
    
        var updatedExhibition = {
            id: exhibitionId,
            name: name,
            start_date: start_date,
            end_date: end_date,
            location: location,
            organizer: organizer,
            introduce: introduce,
            remark: remark,
            artworks: $('#exhibitionArtworks').val(),
            aliases: {}
        };
    
        // 收集別名信息
        $('#selectedArtworksContainer .artwork-item').each(function() {
            var artworkId = $(this).attr('id').replace('artwork-', '');
            var alias = $(this).find('input[name^="alias"]').val();
            if (alias) {
                updatedExhibition.aliases[artworkId] = alias;
            }
        });
    
        // 發送 AJAX 請求更新展覽信息
        $.ajax({
            url: 'php/update_exhibition.php',
            type: 'POST',
            contentType: 'application/json', // 設定請求內容類型為 JSON
            data: JSON.stringify(updatedExhibition), // 將資料轉為 JSON 字串
            success: function(response) {
                console.log(response);
                if (response.success) {
                    customAlert('展覽已成功更新！', function() {
                        // 成功更新後跳轉到 exhibition_search.html
                        window.location.href = `exhibition_search.html`;
                    });
                } else {
                    customAlert(response.message);
                }
            },
            error: function() {
                customAlert('更新失敗，請稍後再試。');
            }
        });
    }
    
    

    // 取消修改按鈕事件
    $('#cancelEditExhibitionBtn').on('click', function() {
        window.location.href = `exhibition_search.html`;
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
});

//--------------彈出視窗setting

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
    $('#modalMessage').text(message);
    $('#customModal').show();
    $('#confirmBtn').text('確定').show();
    $('#cancelBtn').hide();  // 隱藏取消按鈕
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        if (typeof callback === 'function') {
            callback();  // 確認後執行回調
        }
    });
}
