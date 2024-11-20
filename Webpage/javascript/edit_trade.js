$(document).ready(function() {
    // Select2
    $('#tradeArtworks').select2({
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
    const tradeId = urlParams.get('id');
    let originalArtworks = []; // 原始參展畫作列表
    if (tradeId) {
        $.ajax({
            url: 'php/get_trade_details.php',
            type: 'POST',
            data: { id: tradeId },
            success: function(response) {
                const trade = JSON.parse(response);
                $('#tradeId').val(tradeId);
                $('#tradeplace').val(trade.place);
                $('#tradedate').val(trade.date);
                $('#tradebuyer').val(trade.buyer);
                $('#tradeseller').val(trade.seller);
                $('#tradeRemark').val(trade.remark);
                // 填充參展作品
                let selectedArtworks = [];
                $('#tradeArtworks').empty();
                $('#selectedArtworksContainer').empty(); // 清空之前的顯示容器
                // $('#tradeprice').val(trade.price)
                trade.artworks.forEach(function(artwork) {
                    $('#tradeArtworks').append(new Option(artwork.name, artwork.id, true, true));
                    selectedArtworks.push(artwork.id);

                    // 在容器中顯示作品，包括別名輸入框
                    $('#selectedArtworksContainer').append(`
                        <div class="artwork-item" id="artwork-${artwork.id}" style="margin-bottom: 10px;">
                            <span class="artwork-header">
                                <label>作品名稱：${artwork.name}</label>
                                <button type="button" class="btn btn-sm btn-outline-danger remove-artwork-btn" onclick="removeArtwork('${artwork.id}')">移除</button>
                            </span>
                            <br>
                            <input type="text" placeholder="輸入交易金額(新台幣），金額為零等同贈送" name="tradeprice[${artwork.id}]" value="${artwork.price || ''}" style="margin-top: 5px;" autocomplete="off">
                        </div>
                    `);
                });
                $('#tradeArtworks').val(selectedArtworks).trigger('change');
                // 初始化原始參展作品列表
                originalArtworks = [...selectedArtworks]; // 深拷貝以保存初始狀態
                console.log('初始化原始畫作列表:', originalArtworks);
            },
            error: function() {
                alert("無法加載展覽資料，請稍後再試。");
            }
        });
    }

    // 展覽表單 - 選擇作品時添加至畫面
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

    // 移除作品
    window.removeArtwork = function(artworkId) {
        $(`#artwork-${artworkId}`).remove();
        let selectedItems = $('#tradeArtworks').val();
        selectedItems = selectedItems.filter(item => item !== artworkId);
        $('#tradeArtworks').val(selectedItems).trigger('change');
    };

    // 當取消選取時，移除相應的元素
    $('#tradeArtworks').on('select2:unselect', function(e) {
        let unselectedId = e.params.data.id;
        $(`#artwork-${unselectedId}`).remove();
    });

    // 保存修改按鈕事件
    $('#saveEditExhibitionBtn').on('click', function() {
        // 讀取隱藏欄位中的展覽 ID
        var tradeId = $('#tradeId').val();
        if (!tradeId) {
            console.error("展覽 ID 未找到");
            alert("交易 ID 缺失，無法保存更改。請刷新頁面並重試。");
            return; // 提前退出，避免進一步操作
        }
    
        // 構造確認信息的文本
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
            { selector: '#tradeRemark', label: '註解' }
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
            if (value === '') {
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
            console.log('有未填寫的必填欄位');
            customAlert('部分必要欄位未填寫，請檢查並補充資料。');
            return; // 終止函數，避免進一步提交表單
        }
    
        // 顯示確認的自訂模態框
        console.log('所有必填欄位已填寫，顯示確認視窗');
        customConfirm(previewText.trim() + "<br><br>是否要繼續保存？", function(result) {
            if (result) {
                console.log('用戶確認保存');
                saveUpdatedtrade();
            }
        });
    });

    // 保存展覽的函數
    function saveUpdatedtrade() {
        var tradeId = $('#tradeId').val();
        var place = $('#tradeplace').val();
        var date = $('#tradedate').val();
        var buyer = $('#tradebuyer').val();
        var seller = $('#tradeseller').val();
        var remark = $('#tradeRemark').val();
    
        var updatedtrade = {
            id: tradeId,
            place: place,
            date: date,
            buyer: buyer,
            seller: seller,
            remark: remark,
            artworks: $('#tradeArtworks').val(),
            tradeprices: {}
        };
    
        // 收集別名信息
        $('#selectedArtworksContainer .artwork-item').each(function() {
            var artworkId = $(this).attr('id').replace('artwork-', '');
            var tradeprice = $(this).find('input[name^="tradeprice"]').val();
            
            if (tradeprice === "") {
                tradeprice = "0";
            }else {
                tradeprice = parseFloat(tradeprice); // 確保它是數字
            }
                updatedtrade.tradeprices[artworkId] = tradeprice;
        });
        // 檢查是否勾選了變更交易狀態的 checkbox
        const changeTradeState = $('#changeTradeState').is(':checked');
        const confirmChange = $('#confirmChange').is(':checked');
        console.log(confirmChange);
        if (changeTradeState && !confirmChange) {
            customAlert("您必須勾選確認框以改變交易狀態。");
            return;
        }else {
            $.ajax({
                url: 'php/update_trade.php',
                type: 'POST',
                contentType: 'application/json', // 設定請求內容類型為 JSON
                data: JSON.stringify(updatedtrade), // 將資料轉為 JSON 字串
                success: function(response) {
                    console.log(response);
                    if (response.success) {
                        customAlert('交易已成功更新！', function() {
                            // 成功更新後跳轉到 trade.html
                            window.location.href = `trade.html`;
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
        // 發送 AJAX 請求更新展覽信息
        
    }
    
    

    // 取消修改按鈕事件
    $('#cancelEditExhibitionBtn').on('click', function() {
        window.location.href = `trade.html`;
    });

    // // 時間判定
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
    $(document).on('change', '#changeTradeState', function() {
        if ($(this).is(':checked')) {
            customAlert('確定要改變交易狀態嗎?<br>改變後畫作無法再新增交易囉!<br>再點擊一次按鈕即可關閉');
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
    $('#modalMessage').html(message);
    $('#customModal').show();
    $('#confirmBtn').text('確定').show();
    $('#cccbtn').hide();  // 隱藏取消按鈕
    $('#confirmBtn').off('click').on('click', function() {
        $('#customModal').hide();
        if (typeof callback === 'function') {
            callback();  // 確認後執行回調
        }
    });
}
