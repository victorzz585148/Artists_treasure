var typeSelect = $('#type_select').val();
var stateSelect = $('#state_select').val();
if(!typeSelect && !stateSelect &&  !form.checkValidity()) {
    alert("請選擇藝品類別、交易狀態及部分必填欄位尚未填寫。")
}else if(!typeSelect && !stateSelect) {
    alert("請選擇藝品類別及交易狀態。");
    return;
}else if(!typeSelect) {
    alert("請選擇藝品類別。");
    return;
}else if(!stateSelect) {
    alert("請選擇交易狀態。");
    return;
}else if(!form.checkValidity()){
    alert("部分必填欄位尚未填寫。");
    return;
}