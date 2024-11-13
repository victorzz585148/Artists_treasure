$(document).ready(function(){
    $('#category').on('change', function() {
        var selectedValue = $(this).val();
        if (selectedValue === 'COLLECTION') {
            $('.extra_fields').removeClass('hidden');
            $('#REPRESENTATIVE option[value="1"]').prop('disabled', true);
            $('#REPRESENTATIVE').val('0').trigger('change');
        } else {
            $('.extra_fields').addClass('hidden');
            $('#REPRESENTATIVE option[value="1"]').prop('disabled', false);
        }
    });
    $('#editstate').select2({
        placeholder: "請選擇交易狀態",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
    $('#editREPRESENTATIVE').select2({
        placeholder: "請選擇交易狀態",
        minimumResultsForSearch: Infinity,
        width: '150px'
    });
})
document.addEventListener('DOMContentLoaded', function () {
    loadItems();
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------------
//edit
const editModal = document.getElementById('editModal');
editModal.addEventListener('show.bs.modal', async function (event) {
    const button = event.relatedTarget;
    const artworkId = button.getAttribute('data-id');
    const category = document.getElementById('category').value;

    if (category === 'artwork') {
        document.querySelectorAll('.collection-field').forEach(field => field.classList.add('hidden'));
    } else if (category === 'collection') {
        document.querySelectorAll('.collection-field').forEach(field => field.classList.remove('hidden'));
    }
    try {
        const response = await fetch('php/get_artwork.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `id=${artworkId}&category=${category}`
        });

        if (response.ok) {
            const data = await response.json();
            if (!data.error) {
                if(category === 'artwork'){
                    document.getElementById('editArtworkId').value = artworkId;
                    document.getElementById('editName').value = data.data.AK_NAME;
                    document.getElementById('editMaterial').value = data.data.AK_MATERIAL;
                    const sizeParts = data.data.AK_SIZE.split(",");
                    const length = sizeParts[0] ? sizeParts[0] : '';
                    const width = sizeParts[1] ? sizeParts[1] : '';
                    document.getElementById('editLength').value = length;
                    document.getElementById('editWidth').value = width;
                    document.getElementById('editYear').value = data.data.AK_SIGNATURE_Y;
                    document.getElementById('editMonth').value = data.data.AK_SIGNATURE_M;
                    document.getElementById('editTheme').value = data.data.AK_THEME;
                    document.getElementById('editIntroduce').value = data.data.AK_INTRODUCE;
                    document.getElementById('editLocation').value = data.data.AK_LOCATION;
                }else if(category === 'collection'){
                    document.getElementById('editArtist').value = data.data.COL_ARTIST;
                    document.getElementById('editArtworkId').value = artworkId;
                    document.getElementById('editName').value = data.data.COL_NAME;
                    document.getElementById('editMaterial').value = data.data.COL_MATERIAL;
                    const sizeParts = data.data.COL_SIZE.split(",");
                    const length = sizeParts[0] ? sizeParts[0] : '';
                    const width = sizeParts[1] ? sizeParts[1] : '';
                    document.getElementById('editLength').value = length;
                    document.getElementById('editWidth').value = width;
                    document.getElementById('editYear').value = data.data.COL_SIGNATURE_Y;
                    document.getElementById('editMonth').value = data.data.COL_SIGNATURE_M;
                    document.getElementById('editTheme').value = data.data.COL_THEME;
                    document.getElementById('editDate').value = data.data.COL_GET_DATE;
                    document.getElementById('editPrice').value = data.data.COL_PRICE;
                    document.getElementById('editIntroduce').value = data.data.COL_INTRODUCE;
                    document.getElementById('editLocation').value = data.data.COL_LOCATION;
                }
            } else {
                alert('無法獲取畫作訊息：' + data.message);
            }
        } else {
            alert('無法獲取畫作訊息');
        }
    } catch (error) {
        console.error('獲取畫作訊息失敗', error);
    }
    bindDeleteButtonEvent();
});

// 編輯表單提交
document.getElementById('editForm').addEventListener('submit', async function (event) {
    event.preventDefault();
    const artworkId = document.getElementById('editArtworkId').value;
    const category = document.getElementById('category').value;
    
    let bodyData = `id=${artworkId}`;
    if (category === 'artwork') {
        const artworkName = document.getElementById('editName').value;
        const artworkMaterial = document.getElementById('editMaterial').value;
        const artworkLength = document.getElementById('editLength').value;
        const artworkWidth = document.getElementById('editWidth').value;
        const artworkSize = `${artworkLength},${artworkWidth}`;
        const artworkYear = document.getElementById('editYear').value;
        const artworkMonth = document.getElementById('editMonth').value;
        const artworkTheme = document.getElementById('editTheme').value;
        const artworkIntroduce = document.getElementById('editIntroduce').value;
        const artworkLocation = document.getElementById('editLocation').value;
        const artworkMedia = document.getElementById('editMedia').value;
        const artworkRemark = document.getElementById('editRemark').value;

        if (artworkName) bodyData += `&name=${encodeURIComponent(artworkName)}`;
        if (artworkSize) bodyData += `&size=${encodeURIComponent(artworkSize)}`;
        if (artworkMaterial) bodyData += `&material=${encodeURIComponent(artworkMaterial)}`;
        if (artworkYear) bodyData += `&year=${encodeURIComponent(artworkYear)}`;
        if (artworkMonth) bodyData += `&month=${encodeURIComponent(artworkMonth)}`;
        if (artworkTheme) bodyData += `&theme=${encodeURIComponent(artworkTheme)}`;
        if (artworkIntroduce) bodyData += `&introduce=${encodeURIComponent(artworkIntroduce)}`;
        if (artworkLocation) bodyData += `&location=${encodeURIComponent(artworkLocation)}`;
        if (artworkMedia) bodyData += `&media=${encodeURIComponent(artworkMedia)}`;
        if (artworkRemark) bodyData += `&remark=${encodeURIComponent(artworkRemark)}`;
    } else if (category === 'collection') {
        const artworkName = document.getElementById('editName').value;
        const artworkMaterial = document.getElementById('editMaterial').value;
        const artworkLength = document.getElementById('editLength').value;
        const artworkWidth = document.getElementById('editWidth').value;
        const artworkSize = `${artworkLength},${artworkWidth}`;
        const artworkYear = document.getElementById('editYear').value;
        const artworkMonth = document.getElementById('editMonth').value;
        const artworkTheme = document.getElementById('editTheme').value;
        const artworkIntroduce = document.getElementById('editIntroduce').value;
        const artworkLocation = document.getElementById('editLocation').value;
        const artworkArtist = document.getElementById('editArtist').value;
        const artworkDate = document.getElementById('editDate').value;
        const artworkPrice = document.getElementById('editPrice').value;
        const artworkRemark = document.getElementById('editRemark').value;

        if (artworkName) bodyData += `&name=${encodeURIComponent(artworkName)}`;
        if (artworkSize) bodyData += `&size=${encodeURIComponent(artworkSize)}`;
        if (artworkMaterial) bodyData += `&material=${encodeURIComponent(artworkMaterial)}`;
        if (artworkYear) bodyData += `&year=${encodeURIComponent(artworkYear)}`;
        if (artworkMonth) bodyData += `&month=${encodeURIComponent(artworkMonth)}`;
        if (artworkTheme) bodyData += `&theme=${encodeURIComponent(artworkTheme)}`;
        if (artworkIntroduce) bodyData += `&introduce=${encodeURIComponent(artworkIntroduce)}`;
        if (artworkLocation) bodyData += `&location=${encodeURIComponent(artworkLocation)}`;
        if (artworkArtist) bodyData += `&artist=${encodeURIComponent(artworkArtist)}`;
        if (artworkDate) bodyData += `&date=${encodeURIComponent(artworkDate)}`;
        if (artworkPrice) bodyData += `&price=${encodeURIComponent(artworkPrice)}`;
        if (artworkRemark) bodyData += `&remark=${encodeURIComponent(artworkRemark)}`;
    }

    try {
        const response = await fetch('php/update_artwork.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: bodyData
        });

        if (response.ok) {
            alert('保存成功');
            // 重新加載畫作項目
            loadItems();
            $('#editModal').modal('hide');
        } else {
            alert('保存失敗');
        }
    } catch (error) {
        console.error('保存失敗', error);
    }
});
});
let isSubmitting = false; // 用來標誌是否正在進行請求

async function loadItems() {
    if (isSubmitting) {
        return; // 如果已經在提交，則不再發送請求
    }

    isSubmitting = true; // 設置為正在提交狀態

    // 獲取當前選擇的類別
    const category = document.getElementById("category").value;

    // 創建要傳送的資料物件
    const formData = new FormData();
    formData.append("category", category);

    console.log("Sending request with category:", category);

    try {
        // 發送 POST 請求
        const response = await fetch('php/display_artwork.php', {
            method: 'POST',
            body: formData
        });

        // 檢查回應狀態
        if (!response.ok) {
            throw new Error(`Request failed with status ${response.status}`);
        }

        // 解析伺服器的回應內容
        const html = await response.text();

        // 更新畫面
        const itemsContainer = document.getElementById("items");
        itemsContainer.innerHTML = ""; // 清空已有的內容，防止重複渲染
        itemsContainer.innerHTML = html; // 渲染新內容

        // 重新綁定卡片事件
        bindCardClickEvent();
        bindDeleteButtonEvent();
    } catch (error) {
        console.error('Error occurred:', error.message);
    } finally {
        isSubmitting = false; // 完成後重置提交狀態
    }
}

function bindDeleteButtonEvent() {
    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', async function () {
            const artworkId = this.getAttribute('data-id');
            const category = document.getElementById("category").value;
            if (confirm('確定要刪除這件作品嗎？')) {
                try {
                    const response = await fetch('php/delete_artwork.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: `id=${artworkId}&category=${category}`
                    });

                    if (response.ok) {
                        const data = await response.json();
                        if (data.success) {
                            alert('刪除成功');
                            loadItems(); // 刪除成功後重新加載畫作項目
                        } else {
                            alert('刪除失敗：' + data.message);
                        }
                    } else {
                        alert('無法刪除作品');
                    }
                } catch (error) {
                    console.error('刪除失敗', error);
                }
            }
        });
    });
}

// 綁定卡片上的點擊事件
function bindCardClickEvent() {
    // 在此加入你需要的卡片點擊事件邏輯
    console.log("Card click event bound.");
}
