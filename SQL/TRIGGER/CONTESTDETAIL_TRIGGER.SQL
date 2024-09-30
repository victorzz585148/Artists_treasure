CREATE TABLE IF NOT EXISTS ctd_sequence (
    seq INT NOT NULL PRIMARY KEY
);

DELIMITER //

CREATE TRIGGER before_insert_contestdetail
BEFORE INSERT ON CONTESTDETAIL
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM ctd_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO ctd_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'CTD00001' 的 ID
    SET new_id = CONCAT('CTD', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.CTD_ID = new_id;
END //

CREATE TRIGGER before_delete_contestdetail
BEFORE DELETE ON CONTESTDETAIL
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM ctd_sequence WHERE seq = SUBSTRING(OLD.CTD_ID, 4);
END //

DELIMITER ;