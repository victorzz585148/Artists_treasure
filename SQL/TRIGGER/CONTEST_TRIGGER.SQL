-- Active: 1727416347752@@127.0.0.1@3306@artists_treasure
CREATE TABLE IF NOT EXISTS CT_sequence (
    seq INT NOT NULL PRIMARY KEY
)

DELIMITER //

CREATE TRIGGER before_insert_CONTEST
BEFORE INSERT ON CONTEST
FOR EACH ROW
BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);

    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM CT_sequence;

    -- 插入輔助表以存儲新的序號
    INSERT INTO CT_sequence (seq) VALUES (new_seq);

    -- 使用新序號生成格式為 'CT00001' 的 ID
    SET new_id = CONCAT('CT', LPAD(new_seq, 5, '0'));

    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.CT_ID = new_id;
END //

CREATE TRIGGER after_delete_CONTEST
BEFORE DELETE ON CONTEST
FOR EACH ROW
BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM CT_sequence WHERE seq = SUBSTRING(OLD.CT_ID, 3);
END //

DELIMITER ;