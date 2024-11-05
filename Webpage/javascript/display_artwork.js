document.addEventListener('DOMContentLoaded', function () {
    // 頁面加載時綁定事件
    document.getElementById("category").addEventListener("change", loadItems);
    document.querySelectorAll('input[name="view_mode"]').forEach(function (radio) {
        radio.addEventListener("change", loadItems);
    });

    // 頁面初始化時載入資料
    loadItems();
});

let isSubmitting = false; // 用來標誌是否正在進行請求

async function loadItems() {
    if (isSubmitting) {
        return; // 如果已經在提交，則不再發送請求
    }

    isSubmitting = true; // 設置為正在提交狀態

    // 獲取當前選擇的類別和顯示模式
    const category = document.getElementById("category").value;
    const viewMode = document.querySelector('input[name="view_mode"]:checked').value;

    // 創建要傳送的資料物件
    const formData = new FormData();
    formData.append("category", category);
    formData.append("view_mode", viewMode);

    console.log("Sending request with category:", category, "and viewMode:", viewMode);

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
    } catch (error) {
        console.error('Error occurred:', error.message);
    } finally {
        isSubmitting = false; // 完成後重置提交狀態
    }
}

// 綁定卡片上的點擊事件
function bindCardClickEvent() {
    // 在此加入你需要的卡片點擊事件邏輯
    console.log("Card click event bound.");
}
