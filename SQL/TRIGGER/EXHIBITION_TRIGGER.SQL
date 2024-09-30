CREATE TABLE IF NOT EXISTS en_sequence ( 
    seq INT NOT NULL PRIMARY KEY
);

DELIMITER //

CREATE TRIGGER before_insert_exhibition
BEFORE INSERT ON EXHIBITION
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM en_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO en_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'EN00001' 的 ID
    SET new_id = CONCAT('EN', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.EN_ID = new_id;
END //

CREATE TRIGGER before_delete_exhibition
BEFORE DELETE ON EXHIBITION
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM en_sequence WHERE seq = SUBSTRING(OLD.EN_ID, 3);
END //

DELIMITER ;