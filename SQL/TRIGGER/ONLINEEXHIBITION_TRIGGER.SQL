CREATE TABLE IF NOT EXISTS oen_sequence ( 
    seq INT NOT NULL PRIMARY KEY
);

DELIMITER //

CREATE TRIGGER before_insert_onlineexhibition
BEFORE INSERT ON ONLINEEXHIBITION
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM oen_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO oen_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'OEN00001' 的 ID
    SET new_id = CONCAT('OEN', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.OEN_ID = new_id;
END //

CREATE TRIGGER before_delete_onlineexhibition
BEFORE DELETE ON ONLINEEXHIBITION
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM oen_sequence WHERE seq = SUBSTRING(OLD.OEN_ID, 4);
END //

DELIMITER ;