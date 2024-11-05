var isSubmitting = false;  // 用來標誌是否正在進行請求

function loadItems() {
    if (isSubmitting) {
        return;  // 如果已經在提交，則不再發送請求
    }

    isSubmitting = true;  // 設置為正在提交狀態

    const category = document.getElementById("category").value;
    const viewMode = document.querySelector('input[name="view_mode"]:checked').value;

    // 創建 FormData 並加入選擇的類別和顯示模式
    const formData = new FormData();
    formData.append("category", category);
    formData.append("view_mode", viewMode);

    console.log("Sending request with category: ", category, "and viewMode: ", viewMode);

    // 發送 POST 請求以更新畫作或收藏品顯示
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "php/display_artwork.php", true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
            console.log('Status:', xhr.status);  // 打印狀態碼
            console.log('Response:', xhr.responseText);  // 打印伺服器回應
            if (xhr.status == 200) {
                document.getElementById("items").innerHTML = "";  // 清空已有的內容，防止重複渲染
                document.getElementById("items").innerHTML = xhr.responseText;  // 渲染新內容
                
                // 重新綁定刪除卡片事件
                bindCardClickEvent();
            } else {
                console.error('Request failed with status: ' + xhr.status);
            }

            isSubmitting = false;  // 完成後重置提交狀態
        }
    };

    xhr.onerror = function() {
        console.error('AJAX request failed');
        isSubmitting = false;  // 即使發生錯誤也重置提交狀態
    };

    xhr.send(formData);
}

// 頁面載入時初始化顯示
window.onload = function() {
    loadItems();
};

// 綁定類別選擇和顯示模式變更的事件
document.getElementById("category").addEventListener("change", loadItems);
document.querySelectorAll('input[name="view_mode"]').forEach(function(radio) {
    radio.addEventListener("change", loadItems);
});

// 刪除模式及卡片選取
document.addEventListener('DOMContentLoaded', function() {
    let isDeleteMode = false;
    let selectedCards = new Set();

    // 按下進入刪除模式按鈕
    document.getElementById('enterDeleteMode').addEventListener('click', function() {
        isDeleteMode = !isDeleteMode; // 切換刪除模式
        selectedCards.clear(); // 清空已選擇卡片
        document.getElementById('confirmDelete').style.display = isDeleteMode ? 'inline-block' : 'none';

        if (isDeleteMode) {
            alert("已進入刪除模式，請點擊卡片進行選取");
        } else {
            alert("已退出刪除模式");
        }
    });

    // 綁定卡片點擊事件
    function bindCardClickEvent() {
        document.querySelectorAll('.card').forEach(function(card) {
            card.addEventListener('click', function() {
                if (isDeleteMode) {
                    const cardId = card.getAttribute('data-id');
                    if (selectedCards.has(cardId)) {
                        selectedCards.delete(cardId);  // 取消選取
                        card.classList.remove('selected'); // 去掉選取樣式
                    } else {
                        selectedCards.add(cardId);  // 添加到選取列表
                        card.classList.add('selected'); // 添加選取樣式
                    }
                }
            });
        });
    }

    // 初次綁定
    bindCardClickEvent();

    // 確認刪除選取的卡片
    document.getElementById('confirmDelete').addEventListener('click', function() {
        if (selectedCards.size === 0) {
            alert("請選擇至少一張卡片進行刪除");
            return;
        }

        if (confirm("確定要刪除選中的卡片嗎？")) {
            // 將選取的卡片 ID 傳送到伺服器進行刪除
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'php/delete_artworks.php', true);
            xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            // 從前端移除刪除成功的卡片
                            selectedCards.forEach(function(id) {
                                var card = document.querySelector(`.card[data-id="${id}"]`);
                                if (card) {
                                    card.remove();
                                }
                            });
                            alert("選取的卡片已成功刪除！");
                        } else {
                            alert("刪除失敗：" + response.message);
                        }
                    } catch (e) {
                        alert("刪除失敗，無法解析伺服器回應。");
                    }
                } else {
                    alert("刪除失敗，伺服器返回錯誤狀態碼：" + xhr.status);
                }
                // 刪除操作完成後，退出刪除模式
                isDeleteMode = false;
                selectedCards.clear();
                document.getElementById('confirmDelete').style.display = 'none';
            };

            xhr.onerror = function() {
                alert("刪除失敗，請檢查網路連線。");
            };

            // 發送選中的卡片 ID 作為 JSON 數據
            xhr.send(JSON.stringify({ ids: Array.from(selectedCards) }));
        }
    });
});
