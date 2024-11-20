$(document).ready(function() {
    
    // 初始化 Select2 DC-finish
    $('#tradeArtworks').select2({
        placeholder: '搜尋並選擇畫作',
        ajax: {
            url: './php/get_trade_artworks.php',
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
                        if (item.state !== 1) {
                            return {
                                id: item.id,
                                text: item.name
                            };
                        }
                    })
                };
            },
            cache: true
        }
    });

    // 交易表單 - 選擇作品時添加至畫面finish
    $('#tradeArtworks').on('select2:select', function(e) {
        let selectedId = e.params.data.id;
        let selectedName = e.params.data.text;

        $('#selectedArtworksContainer').append(`
            <div class="artwork-item" id="artwork-${selectedId}" style="margin-bottom: 10px;">
                <span class="artwork-header">
                    <label>作品名稱：${selectedName}</label>
                    <button type="button" class="btn btn-sm btn-outline-danger remove-artwork-btn" onclick="removeArtwork('${selectedId}')">移除</button>
                </span>
                <br>
                <input type="text" placeholder="輸入交易金額(新台幣），金額為零等同贈送" name="tradeprice[${selectedId}]" style="margin-top: 5px;" autocomplete="off">
            </div>
        `);
    });

    // 移除作品finish
    window.removeArtwork = function(artworkId) {
        $(`#artwork-${artworkId}`).remove();
        let selectedItems = $('#tradeArtworks').val();
        selectedItems = selectedItems.filter(item => item !== artworkId);
        $('#tradeArtworks').val(selectedItems).trigger('change');
    };

    // 當取消選取時，移除相應的元素DC-finish
    $('#tradeArtworks').on('select2:unselect', function(e) {
        let unselectedId = e.params.data.id;
        $(`#artwork-${unselectedId}`).remove();
    });

    // 確認送出按鈕的點擊事件finish
    $('#en-btn').on('click', function(event) {
        event.preventDefault(); // 阻止按鈕的預設提交行為
    
        console.log('送出按鈕被點擊'); // 這行可以確定按鈕的點擊是否被偵測
    
        let previewText = '請確認以下資料是否正確：<br><br>';
        let hasEmptyFields = false;
    
        // 檢查必填欄位是否填寫
        // 定義必填欄位
        const requiredFields = [
            { selector: '#tradeplace', label: '販售地點' },
            { selector: '#tradedate', label: '販售日期' },
            { selector: '#tradebuyer', label: '收購人' }
        ];

        // 定義所有需要顯示的欄位（包括非必填）
        const allFields = [
            { selector: '#tradeplace', label: '販售地點' },
            { selector: '#tradedate', label: '販售日期' },
            { selector: '#tradebuyer', label: '收購人' },
            { selector: '#tradeseller', label: '經手人' },
            { selector: '#tradeRemark', label: '註解' },
            { selector: '#changeTradeState', label: '改變交易狀態' }
        ];

        // 遍歷每個必填欄位，檢查是否為空
        requiredFields.forEach(function(field) {
            const value = $(field.selector).val().trim();
            if (value === '') {
                console.log(`必填欄位未填寫: ${field.label}`); // 這行可以檢查未填寫的欄位
                hasEmptyFields = true;
            }
        });

        // 遍歷所有欄位，生成預覽文字
        allFields.forEach(function(field) {
            const value = $(field.selector).val().trim();
            if (value === 'change_state'){
                previewText += `${field.label}: 是<br>`;
            }else if (value === '') {
                previewText += `${field.label}: 無<br>`;
            } else {
                previewText += `${field.label}: ${value}<br>`;
            }
        });
    
        // 檢查交易作品是否選擇了至少一個
        const selectedArtworks = $('#tradeArtworks option:selected');
        if (selectedArtworks && selectedArtworks.length > 0) {
            previewText += "交易作品: <br>";
            selectedArtworks.each(function() {
                const artworkId = $(this).val(); // 取得選擇的作品 ID
                const artworkName = $(this).text(); // 取得作品名稱（顯示的文本）
        
                // 找到對應 artworkId 的價格輸入框，並取得其值
                const artworkPriceInput = $(`input[name='tradeprice[${artworkId}]']`);
                
                // 確保輸入框存在並且已經找到
                if (artworkPriceInput.length > 0) {
                    let artworkPrice = artworkPriceInput.val();
                    
                    // 確保價格存在，如果不存在或者為空，設為 "0"
                    if (artworkPrice === undefined || artworkPrice.trim() === '') {
                        artworkPrice = '0';
                    } else {
                        artworkPrice = artworkPrice.trim(); // 移除額外的空白
                    }
        
                    // 生成預覽文本
                    previewText += `${artworkName} (${artworkPrice}元)<br>`;
                } else {
                    console.log(`未找到對應價格輸入框: tradeprice[${artworkId}]`);
                }
            });
        } else {
            console.log('未選擇交易作品');
            hasEmptyFields = true;
            previewText += `交易作品: （未選擇）<br>`;
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
    // 偵測變更交易狀態的按鈕被點擊，並新增確認 HTML 區塊
    $('#changeTradeState').on('change', function() {
        if ($(this).is(':checked')) {
            console.log('Checkbox is checked, adding confirmation section.');
            
            // 新增確認的 HTML 區塊到選擇交易作品區域下方
            $('#selectedArtworksContainer').after(`
                <div class="ckb2">
                    <div class="checkbox-wrapper-19">
                        <input type="checkbox" id="confirmChange" />
                        <label for="confirmChange" class="check-box"></label>
                    </div>
                    <span><strong>我確認要改變交易狀態且知道不可以再新增畫作於其他交易</strong></span>
                </div>
            `);
        } else {
            console.log('Checkbox is unchecked, removing confirmation section.');
            
            // 移除該區塊
            $('.ckb2').remove();
        }
    });
        // 表單送出 AJAX 請求
        $('#exhibitionForm').on('submit', function(e) {
            e.preventDefault();
            
            // 再次檢查是否有選擇參展作品
            const selectedArtworks = $('#tradeArtworks').val();
            if (!selectedArtworks || selectedArtworks.length === 0) {
                customAlert('請至少選擇一個交易作品。');
                return; // 停止提交，避免發送空表單
            }
            // 檢查是否勾選了變更交易狀態的 checkbox
            const changeTradeState = $('#changeTradeState').is(':checked');
            const confirmChange = $('#confirmChange').is(':checked');
            console.log(confirmChange);
            if (changeTradeState && !confirmChange) {
                customAlert("您必須勾選確認框以改變交易狀態。");
                return;
            }else {
                // 將交易狀態加入到表單資料中
                $.ajax({
                    url: 'php/save_trade.php',
                    type: 'POST',
                    data: $(this).serialize(),
                    success: function(response) {
                        if (response) { // 確保有回傳值
                            //增加展覽次數
                            customAlert('展覽儲存成功！', function() {
                                // 在確認彈出視窗後進行跳轉
                                window.location.href = 'trade.html';
                            });
                            $('#exhibitionForm')[0].reset();
                            $('#tradeArtworks').val(null).trigger('change');
                            $('#selectedArtworksContainer').empty();
                        } else {
                            customAlert('儲存失敗，伺服器未回傳資料，請再試一次。');
                        }
                    },
                    error: function() {
                        customAlert('儲存失敗，請再試一次。');
                    }
                });
            }

        }); 
        $('#cancelBtn').on('click', function() {
            window.location.href = 'trade.html';
        });  
        $(document).on('change', '#changeTradeState', function() {
            if ($(this).is(':checked')) {
                customAlert('確定要改變交易狀態嗎?<br>改變後畫作無法再新增交易囉!<br>再點擊一次按鈕即可關閉');
            }
        });
        
});

// 時間判定
// $('#exhibitionStart, #exhibitionEnd').on('change', function() {
//     // 獲取開始和結束時間
//     const startDate = new Date($('#exhibitionStart').val());
//     const endDate = new Date($('#exhibitionEnd').val());

//     // 檢查結束時間是否早於開始時間
//     if (endDate < startDate) {
//         customAlert('結束時間不能早於開始時間，請重新選擇。');
//         $('#exhibitionEnd').val(''); // 清空結束時間的值
//     }
// });

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
    $('#cccbtn').text('取消').show();

    // 綁定確定按鈕的點擊事件
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        callback(true);  // 確定時回調 true
    });

    // 綁定取消按鈕的點擊事件
    $('#cccbtn').off('click').on('click', function() {
        $('#customModal').hide();
        callback(false); // 取消時回調 false
    });
}



function customAlert(message, callback) {
    // 設置模態框的訊息
    $('#modalMessage').html(message);
    $('#customModal').show();

    // 設定確定按鈕文本並顯示
    $('#confirmBtn').text('確定').show();
    // 隱藏取消按鈕，因為這是一個簡單的警示視窗
    $('#cccbtn').hide()

    // 綁定確定按鈕的點擊事件   
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        if (typeof callback === 'function') {
            callback();  // 確認後執行回調
        }
    });
}

