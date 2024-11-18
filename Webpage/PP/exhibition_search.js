$(document).ready(function () {
    // 初始化 DataTables (所有展覽)
    $('#allExhibitionsTable').DataTable({
        ajax: {
            url: 'php/get_all_exhibitions.php', // 後端提供的展覽數據接口
            type: 'POST',
            dataSrc: 'data' // 後端返回的數據屬性名稱
        },
        columns: [
            { data: 'name' }, // 展覽名稱
            { data: 'start_date' }, // 開始日期
            { data: 'end_date' }, // 結束日期
            {
                data: null, // 詳細資料按鈕
                render: function (data, type, row) {
                    return `<button class="btn btn-info view-details-btn" data-id="${row.id}">查看詳細</button>`;
                }
            }
        ],
        paging: true,
        searching: true,
        ordering: true,
        language: {
            search: "搜尋：",
            lengthMenu: "每頁顯示 _MENU_ 筆資料",
            info: "顯示 _START_ 到 _END_ 筆，共 _TOTAL_ 筆",
            emptyTable: "無可顯示的數據",
            paginate: {
                first: "第一頁",
                last: "最後一頁",
                next: "下一頁",
                previous: "上一頁"
            }
        }
    });

    // 初始化 DataTables (特定展覽)
    $('#exhibitionTable').DataTable({
        ajax: {
            url: 'php/get_exhibitions_by_artwork.php', // 後端提供的藝術作品對應展覽數據接口
            type: 'POST',
            dataSrc: 'data'
        },
        columns: [
            { data: 'artwork_names' }, // 作品名稱
            { data: 'name' }, // 展覽名稱
            { data: 'start_date' }, // 開始日期
            { data: 'end_date' }, // 結束日期
            {
                data: null,
                render: function (data, type, row) {
                    return `<button class="btn btn-info view-details-btn" data-id="${row.id}">查看詳細</button>`;
                }
            }
        ],
        paging: true,
        searching: true,
        ordering: true
    });

    // 查看詳細資料按鈕事件處理
    $('#allExhibitionsTable, #exhibitionTable').on('click', '.view-details-btn', function () {
        const exhibitionId = $(this).data('id');
        loadExhibitionDetails(exhibitionId);
    });

    // 加載展覽詳細資料
    function loadExhibitionDetails(exhibitionId) {
        $.ajax({
            url: 'php/get_exhibition_details.php',
            type: 'POST',
            data: { exhibitionId },
            success: function (response) {
                const details = JSON.parse(response);
                displayExhibitionDetails(details);
            },
            error: function () {
                console.error("無法加載展覽詳細資料");
            }
        });
    }

    // 顯示展覽詳細資料
    function displayExhibitionDetails(details) {
        const detailHtml = `
            <h4>${details.name || '未定義展覽名稱'}</h4>
            <p><strong>展覽地點：</strong>${details.location || '未提供'}</p>
            <p><strong>主辦單位：</strong>${details.organizer || '未提供'}</p>
            <p><strong>開始日期：</strong>${details.start_date || '未提供'}</p>
            <p><strong>結束日期：</strong>${details.end_date || '未提供'}</p>
            <p><strong>展覽介紹：</strong>${details.introduce || '未提供介紹'}</p>
        `;
        $('#exhibitionDetailBody').html(detailHtml);
        $('#exhibitionModal').modal('show');
    }
});
