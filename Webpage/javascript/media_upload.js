document.getElementById('savebutton').addEventListener('click', function() {
    var formData = new FormData(document.getElementById('uploadForm')); // 創建表單數據
    var xhr = new XMLHttpRequest();
    
    xhr.open('POST', 'php/upload_file.php', true); // 發送到 PHP 處理文件的地址
    xhr.onload = function() {
        if (xhr.status === 200) {
            // 處理回傳的文件路徑
            var response = JSON.parse(xhr.responseText);
            if (response.success) {
                alert("文件上傳成功，文件位置：" + response.filePath);
            } else {
                alert("文件上傳失敗：" + response.message);
            }
        }
    };
    
    xhr.send(formData); // 發送表單數據
});