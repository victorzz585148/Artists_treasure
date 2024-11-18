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
        //  else if (target === "#search-exhibitions") {
        //     $('#search-exhibitions-tab').DataTable().columns.adjust().draw();
        // }
    });
    const table = $('#allExhibitionsTable').DataTable({
        serverSide: true, // 啟用伺服器處理
        ajax: {
            url: 'php/get_all_exhibitions.php', // 後端 API
            type: 'POST',
            data: function (d) {
                d.searchCategory = $('#searchCategory').val(); // 搜尋類別
                d.searchQuery = $('#searchQuery').val(); // 搜尋關鍵字
            }
        },
        columns: [
            { data: 'name', title: '展覽名稱' },
            { data: 'start_date', title: '開始日期' },
            { data: 'end_date', title: '結束日期' },
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
    // 修改按鈕跳轉到 edit_exhibition.html
    $('#allExhibitionsTable').on('click', '.edit-exhibition-btn', function() {
        const exhibitionId = $(this).data('id');
        if (exhibitionId) {
            window.location.href = `edit_exhibition.html?id=${exhibitionId}`;
        }
    });
    // 搜尋按鈕功能
    $('#searchButton').on('click', function () {
        const searchQuery = $('#searchQuery').val().trim();
        const searchCategory = $('#searchCategory').val();
        const itemType = $('#itemType').val(); // 新增搜尋類型：exhibition 或 artwork
    
        if (searchQuery === '') {
            // 搜尋框為空時顯示所有展覽
            table.ajax.url('php/get_all_exhibitions.php').load();
        } else {
            // 發送搜尋請求
            table.ajax.url('php/search_exhibitions.php').load({
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
            table.ajax.url('php/get_all_exhibitions.php').load();
        }
    });


    // 點擊詳細資料按鈕
    $('#allExhibitionsTable').on('click', '.view-details-btn', function() {
        const exhibitionId = $(this).data('id');
        if (!exhibitionId) {
            console.error('未提供展覽 ID');
            return;
        }
        
        // 調用函數載入展覽詳細資料
        loadExhibitionDetails(exhibitionId);
    });

    // 加載展覽詳細資料
    function loadExhibitionDetails(exhibitionId) {
        $.ajax({
            url: 'php/get_exhibition_details.php',
            type: 'POST',
            data: { id: exhibitionId },
            success: function (response) {
                console.log('伺服器回應:', response);  // 用於檢查伺服器返回的數據
    
                try {
                    // 如果回應是字符串，則需要解析成對象
                    const details = typeof response === "string" ? JSON.parse(response) : response;
    
                    // 確認回應不是空值，並且包含所需字段
                    if (details && details.name && details.location && details.organizer && details.start_date && details.end_date) {
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
    // 選項卡切換時重新調整表格
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        const target = $(e.target).attr("href");
        if (target === "#all-exhibitions") {
            $('#allExhibitionsTable').show();
            $('#searchExhibitionsTable').hide();
        } else if (target === "#search-exhibitions") {
            $('#searchExhibitionsTable').show();
            $('#allExhibitionsTable').hide();
        }
    })


    // 顯示展覽詳細資料
    function displayExhibitionDetails(details) {
        let detailHtml = `
            <h4>${details.name || '未定義展覽名稱'}</h4>
            <p><strong>展覽地點：</strong>${details.location || '未提供'}</p>
            <p><strong>主辦單位：</strong>${details.organizer || '未提供'}</p>
            <p><strong>開始日期：</strong>${details.start_date || '未提供'}</p>
            <p><strong>結束日期：</strong>${details.end_date || '未提供'}</p>
            <p><strong>展覽介紹：</strong>${details.introduce || '未提供介紹'}</p>
        `;
    
        // 加入備註信息
        detailHtml += `
            <p><strong>備註：</strong>${details.remark || '未提供備註'}</p>
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
        const exhibitionId = $(this).data('id');
        if (!exhibitionId) {
            console.error('未提供展覽 ID');
            return;
        }
    
        // 顯示確認刪除的彈出視窗
        customConfirm('確定要刪除此展覽嗎？', function (confirmed) {
            if (confirmed) {
                // 發送 AJAX 請求到 delete_exhibition.php
                $.ajax({
                    url: 'php/delete_exhibition.php',
                    type: 'POST',
                    data: { id: exhibitionId },
                    success: function (response) {
                        try {
                            // 確保回應是 JSON 格式
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
        });
    });
});
document.getElementById('searchCategory').addEventListener('change', function () {
    const searchCategory = this.value;
    const searchQueryInput = document.getElementById('searchQuery');
    const dataTable = $('#allExhibitionsTable').DataTable(); // 假設 DataTable 使用 ID 為 "allExhibitionsTable"

    // 清空輸入框
    searchQueryInput.value = '';

    // 根據選擇的類別設定輸入框類型
    if (searchCategory === 'EN_START' || searchCategory === 'EN_FINISH') {
        // 將輸入框切換為日期選擇器
        searchQueryInput.type = 'date';
        searchQueryInput.placeholder = '選擇日期';
    } else {
        // 將輸入框切換回文字輸入
        searchQueryInput.type = 'text';
        searchQueryInput.placeholder = '輸入搜尋關鍵字';
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