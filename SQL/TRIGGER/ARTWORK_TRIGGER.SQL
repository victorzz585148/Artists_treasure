CREATE TABLE IF NOT EXISTS ak_sequence (
    seq INT NOT NULL PRIMARY KEY
)

DELIMITER //

CREATE TRIGGER before_insert_artwork
BEFORE INSERT ON ARTWORK
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM ak_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO ak_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'AK00001' 的 ID
    SET new_id = CONCAT('AK', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.AK_ID = new_id;
END //

CREATE TRIGGER before_delete_artwork
BEFORE DELETE ON ARTWORK
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM ak_sequence WHERE seq = SUBSTRING(OLD.AK_ID, 3);
END //

DELIMITER ;