CREATE TABLE IF NOT EXISTS pe_sequence ( 
    seq INT NOT NULL PRIMARY KEY
);

DELIMITER //

CREATE TRIGGER before_insert_place
BEFORE INSERT ON PLACE
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM pe_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO pe_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'PE00001' 的 ID
    SET new_id = CONCAT('PE', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.PE_ID = new_id;
END //

CREATE TRIGGER before_delete_place
BEFORE DELETE ON PLACE
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM pe_sequence WHERE seq = SUBSTRING(OLD.PE_ID, 3);
END //

DELIMITER ;