$(document).ready(function () {
    //select2
    $('#category').select2({
        placeholder: "請選擇藝品類別",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });

    $('#artworkSelect').select2({
        placeholder: '搜尋並選擇畫作',
        width: '50%',
        allowClear: true,
        multiple: true,
        ajax: {
            url: 'php/get_artworks_for_exhibition.php',
            type: 'POST',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                const selectedCategory = $('#category').val();
                return {
                    searchTerm: params.term,
                    category: selectedCategory
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
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
    // 初始化 DataTables (所有展覽)
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        const target = $(e.target).attr("href");
        if (target === "#all-exhibitions-tab") {
            $('#allExhibitionsTable').DataTable().columns.adjust().draw();}
    });
    const table = $('#allExhibitionsTable').DataTable({
        serverSide: true, // 啟用伺服器處理
        ajax: {
            url: 'php/get_all_trades.php', // 後端 API
            type: 'POST',
            data: function (d) {
                d.searchCategory = $('#searchCategory').val(); // 搜尋類別
                d.searchQuery = $('#searchQuery').val(); // 搜尋關鍵字
            }
        },
        columns: [
            { data: 'place', title: '販售地點' },
            { data: 'date', title: '販售日期' },
            { data: 'buyer', title: '收購人' },
            { 
                data: null,
                render: function (data, type, row) {
                    return `<button class="btn btn-info view-details-btn" data-id="${row.id}">查看詳細</button>`;
                }
            },
            {
                data: null,
                render: function (data, type, row) {
                    return `<button class="btn btn-warning edit-exhibition-btn" data-id="${row.id}">修改</button>`;
                }
            },
            {
                data: null,
                render: function (data, type, row) {
                    return `<button class="btn btn-danger delete-exhibition-btn" data-id="${row.id}">刪除</button>`;
                }
            }
        ],
        searching: false,
        ordering: false,
        dom: '<"top"l>rt<"bottom"ip><"clear">',
        "columnDefs": [
            {
                "targets": 0,
                "width": "30%"
            },
            {
                "targets": 1,
                "width": "20%"
            },
            {
                "targets": 2,
                "width": "20%"
            },
            {
                "targets": 3,
                "width": "10%"
            },  
            {
                "targets": 4,
                "width": "10%"
            },
            {
                "targets": 5,
                "width": "10%"
            }
        ],
        language: {
            search: "搜尋：",
            lengthMenu: "每頁顯示 _MENU_ 筆資料",
            infoEmpty: "顯示 0 至 0 筆，共 0 筆資料",
            info: "顯示 _START_ 到 _END_ 筆，共 _TOTAL_ 筆",
            infoFiltered: "",
            emptyTable: "無可顯示的數據",
            paginate: {
                first: "第一頁",
                last: "最後一頁",
                next: "下一頁",
                previous: "上一頁"
            }
        }
    });
    // 修改按鈕跳轉到 edit_trade.html
    $('#allExhibitionsTable').on('click', '.edit-exhibition-btn', function() {
        const tradeId = $(this).data('id');
        if (tradeId) {
            window.location.href = `edit_trade.html?id=${tradeId}`;
        }
    });
    // 搜尋按鈕功能
    $('#searchButton').on('click', function () {
        const searchQuery = $('#searchQuery').val().trim();
        const searchCategory = $('#searchCategory').val();
        const itemType = $('#itemType').val(); // 新增搜尋類型：exhibition 或 artwork
    
        if (searchQuery === '') {
            // 搜尋框為空時顯示所有展覽
            table.ajax.url('php/get_all_trades.php').load();
        } else {
            // 發送搜尋請求
            table.ajax.url('php/search_trades.php').load({
                searchCategory: searchCategory,
                searchQuery: searchQuery,
                itemType: itemType
            });
        }
    });
    

    // 搜尋框的清空監聽
    $('#searchQuery').on('input', function () {
        if ($(this).val().trim() === '') {
            // 搜尋框清空後顯示所有展覽
            table.ajax.url('php/get_all_trades.php').load();
        }
    });


    // 點擊詳細資料按鈕
    $('#allExhibitionsTable').on('click', '.view-details-btn', function() {
        const tradeId = $(this).data('id');
        if (!tradeId) {
            console.error('未提供展覽 ID');
            return;
        }
        
        // 調用函數載入展覽詳細資料
        loadtradeDetails(tradeId);
    });

    // 加載展覽詳細資料
    function loadtradeDetails(tradeId) {
        $.ajax({
            url: 'php/get_trade_details.php',
            type: 'POST',
            data: { id: tradeId },
            success: function (response) {
                console.log('伺服器回應:', response);  // 用於檢查伺服器返回的數據
    
                try {
                    // 如果回應是字符串，則需要解析成對象
                    const details = typeof response === "string" ? JSON.parse(response) : response;
    
                    // 確認回應不是空值，並且包含所需字段
                    if (details && details.place && details.date && details.buyer) {
                        displayExhibitionDetails(details);
                    } else {
                        alert('獲取的展覽資料不完整');
                    }
                } catch (error) {
                    console.error("回應資料解析失敗：", error);
                    alert("載入展覽詳細資料時發生錯誤，請稍後再試。");
                }
            },
            error: function () {
                console.error("無法加載展覽詳細資料");
                alert("無法加載展覽詳細資料，請稍後再試。");
            }
        });
    }   


    // 顯示展覽詳細資料
    function displayExhibitionDetails(details) {
        let detailHtml = `
            <p><strong>販售地點：</strong>${details.place || '未提供'}</p>
            <p><strong>販售日期：</strong>${details.date || '未提供'}</p>
            <p><strong>收購人：</strong>${details.buyer || '未提供'}</p>
            <p><strong>經手人：</strong>${details.seller || '未提供'}</p>
        `;
    
        // 加入備註信息
        detailHtml += `
            <p><strong>註解：</strong>${details.remark || '未提供備註'}</p>
            <h5><strong>參展畫作 (共${details.item || 0}件)：</strong></h5>
            <ul>
        `;
    
        // 遍歷畫作並顯示
        details.artworks.forEach(function (artwork) {
            const typeLabel = artwork.type === 'ARTWORK' ? '創作品' : '收藏品';
            detailHtml += `
                <li>[${typeLabel}] ${artwork.name}
                    <button class="btn btn-primary view-artwork-detail btn-sm" data-id="${artwork.id}">
                        查看詳細
                    </button>   
                </li><br>
            `;
        });
    
        detailHtml += '</ul>';
    
        // 將內容插入到模態框
        $('#exhibitionDetailBody').html(detailHtml);
        $('#exhibitionModal').modal('show');
    }

    // 綁定刪除按鈕點擊事件
    $('#allExhibitionsTable').on('click', '.delete-exhibition-btn', function () {
        const tradeId = $(this).data('id');
        if (!tradeId) {
            console.error('未提供交易 ID');
            return;
        }
    
        // 顯示確認刪除的彈出視窗
        customConfirm('確定要刪除此交易嗎？', function (confirmed) {
            if (confirmed) {
                // 先獲取展覽的參展畫作，然後再進行刪除
                $.ajax({
                    url: 'php/get_trade_details.php',
                    type: 'POST',
                    data: { id: tradeId },
                    success: function (response) {
                        try {
                            // 檢查回應是否為 JSON 格式，如果是字串則先解析
                            const details = typeof response === 'string' ? JSON.parse(response) : response;
                            // 輸出伺服器返回的展覽詳細資料，用於檢查
                            console.log("伺服器返回的展覽詳細資料:", details);
                            deletetrade(tradeId);
                        } catch (error) {
                            // 捕獲 JSON 解析失敗的錯誤
                            console.error('解析伺服器回應失敗：', error);
                            customAlert('無法獲取展覽詳細資料，請稍後再試。');
                        }
                    },
                    error: function () {
                        console.error('無法加載展覽詳細資料');
                        customAlert('無法加載展覽詳細資料，請稍後再試。');
                    }
                });
            }
        });
    });


    // 畫作詳細資料
    $('#exhibitionModal').on('click', '.view-artwork-detail', async function () {
        const artworkId = $(this).data('id');
    
        // Determine the type of artwork based on ID prefix
        let category = '';
        if (artworkId.startsWith('AK')) {
            category = 'artwork';
        } else if (artworkId.startsWith('COL')) {
            category = 'collection';
        }
    
        try {
            // Send request to PHP to get artwork or collection details
            const response = await fetch('php/display_exhibition_artwork_detail.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `id=${artworkId}`
            });
    
            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    // Display data in the offcanvas
                    document.getElementById('offcanvasName').textContent = data.data.AK_NAME || data.data.COL_NAME || 'N/A';
                    document.getElementById('offcanvasMaterial').textContent = data.data.AK_MATERIAL || data.data.COL_MATERIAL || 'N/A';
                    document.getElementById('offcanvasLength').textContent = data.data.AK_SIZE?.split(",")[0] || data.data.COL_SIZE?.split(",")[0] || 'N/A';
                    document.getElementById('offcanvasWidth').textContent = data.data.AK_SIZE?.split(",")[1] || data.data.COL_SIZE?.split(",")[1] || 'N/A';
                    document.getElementById('offcanvasYear').textContent = data.data.AK_SIGNATURE_Y || data.data.COL_SIGNATURE_Y || 'N/A';
                    document.getElementById('offcanvasMonth').textContent = data.data.AK_SIGNATURE_M || data.data.COL_SIGNATURE_M || 'N/A';
                    document.getElementById('offcanvasTheme').textContent = data.data.AK_THEME || data.data.COL_THEME || 'N/A';
                    document.getElementById('offcanvasIntroduce').textContent = data.data.AK_INTRODUCE || data.data.COL_INTRODUCE || 'N/A';
                    document.getElementById('offcanvasLocation').textContent = data.data.AK_LOCATION || data.data.COL_LOCATION || 'N/A';
                    document.getElementById('offcanvasArtist').textContent = data.data.COL_ARTIST || 'N/A';
                    document.getElementById('offcanvasGetDate').textContent = data.data.COL_GET_DATE || 'N/A';
                    document.getElementById('offcanvasPrice').textContent = data.data.COL_PRICE || 'N/A';
                    // Additional fields for detailed artwork information
                    document.getElementById('offcanvasExhibitCount').textContent = data.data.AK_TIMES || data.data.COL_TIMES || '0';
                    document.getElementById('offcanvasTransactionCount').textContent = data.data.AK_RACETIMES || '0';
                    document.getElementById('offcanvasTransactionStatus').textContent = data.data.TRANSACTION_STATUS || '未出售';
                    document.getElementById('offcanvasRemark').textContent = data.data.REMARK || '無';
    
                    // Display image
                    document.getElementById('offcanvasImage').src = data.data.AK_MEDIA || data.data.COL_MEDIA || 'default.png';
    
                    // 當你需要顯示或隱藏收藏品相關欄位時：
                    if (category === 'collection') {
                        // 顯示與收藏品相關的欄位
                        document.getElementById('collectionFields').classList.remove('hidden');
                        document.getElementById('collectiondate').classList.remove('hidden');
                        document.getElementById('collectionprice').classList.remove('hidden');
                    } else {
                        // 隱藏與收藏品相關的欄位
                        document.getElementById('collectionFields').classList.add('hidden');
                        document.getElementById('collectiondate').classList.add('hidden');
                        document.getElementById('collectionprice').classList.add('hidden');
                    }


    
                    // Hide the exhibition modal
                    $('#exhibitionModal').modal('hide');
    
                    // Show the offcanvas
                    const offcanvasElement = document.getElementById('artworkOffcanvas');
                    const offcanvas = new bootstrap.Offcanvas(offcanvasElement);
                    offcanvas.show();
    
                    // When the offcanvas is hidden, bring back the exhibition modal
                    offcanvasElement.addEventListener('hidden.bs.offcanvas', function () {
                        $('#exhibitionModal').modal('show');
                    });
                } else {
                    alert('無法獲取作品信息：' + data.message);
                }
            } else {
                alert('無法獲取作品信息，請稍後重試。');
            }
        } catch (error) {
            console.error('獲取作品信息失敗', error);
        }
    });

});
document.getElementById('searchCategory').addEventListener('change', function () {
    const searchCategory = this.value;
    const searchQueryInput = document.getElementById('searchQuery');
    const dataTable = $('#allExhibitionsTable').DataTable(); // 假設 DataTable 使用 ID 為 "allExhibitionsTable"

    // 清空輸入框
    searchQueryInput.value = '';

    // 根據選擇的類別設定輸入框類型
    if (searchCategory === 'TDE_DATE') {
        // 將輸入框切換為日期選擇器
        searchQueryInput.type = 'date';
    } else {
        // 將輸入框切換回文字輸入
        searchQueryInput.type = 'text';
    }

    // 重製 DataTable 顯示內容
    dataTable.clear().draw(); // 清空 DataTable 的數據並重新繪製
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


// 打開側邊欄
function openSidebar() {
    document.getElementById('artworkDetailSidebar').classList.add('open');
}

// 關閉側邊欄
function closeSidebar() {
    document.getElementById('artworkDetailSidebar').classList.remove('open');
}

function updateArtworkTimes(artworkId, increment) {
    $.ajax({
        url: 'php/update_artwork_times.php',
        type: 'POST',
        data: {
            id: artworkId,
            increment: increment
        },
        success: function(response) {
            console.log('畫作 ID:', artworkId, '展覽次數變化:', increment, '伺服器回應:', response);

            // 將伺服器返回的 JSON 字串轉換為對象（如果需要）
            try {
                const result = typeof response === 'string' ? JSON.parse(response) : response;
                if (result.success) {
                    customAlert(`畫作的展覽次數成功更新 ${increment > 0 ? '增加' : '減少'} 1 次`);
                } else {
                    customAlert(`畫作的展覽次數更新失敗：${result.message}`);
                }
            } catch (e) {
                console.error('解析伺服器回應失敗:', e);
                customAlert('無法解析伺服器回應，請檢查網路狀態或稍後再試。');
            }
        },
        error: function() {
            console.error('畫作次數更新失敗，畫作 ID:', artworkId);
            customAlert(`畫作 ${artworkId} 的展覽次數更新失敗，請稍後再試。`);
        }
    });
}
// 刪除展覽函數
function deletetrade(tradeId) {
    $.ajax({
        url: 'php/delete_trade.php',
        type: 'POST',
        data: { id: tradeId },
        success: function (response) {
            try {
                const res = typeof response === 'string' ? JSON.parse(response) : response;

                if (res.success) {
                    customAlert('展覽已成功刪除！');
                    $('#allExhibitionsTable').DataTable().ajax.reload(); // 重新加載表格
                } else {
                    customAlert(res.message || '刪除展覽失敗');
                }
            } catch (error) {
                console.error('解析伺服器回應失敗：', error);
                customAlert('刪除展覽時發生錯誤，請稍後再試。');
            }
        },
        error: function () {
            console.error('無法刪除展覽');
            customAlert('刪除展覽時發生錯誤，請稍後再試。');
        }
    });
}