<?php
$mysqli = new mysqli("localhost", "root", "Caidsjim2999!", "artists_treasure");

if ($mysqli->connect_error) {
    die(json_encode(["success" => false, "message" => "資料庫連接失敗：" . $mysqli->connect_error]));
}

$artworkId = $_POST['artworkId'] ?? '';
$stmt = $mysqli->prepare("SELECT AK_NAME as name, AK_MATERIAL as material, AK_SIZE as size, AK_INTRODUCE as introduce FROM artwork WHERE AK_ID = ?");
$stmt->bind_param('s', $artworkId);
$stmt->execute();
$stmt->bind_result($name, $material, $size, $introduce);
$stmt->fetch();

$details = [
    'name' => $name,
    'material' => $material,
    'size' => $size,
    'introduce' => $introduce
];

echo json_encode($details);
$stmt->close();
$mysqli->close();