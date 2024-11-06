-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： localhost
-- 產生時間： 2024-11-06 15:21:41
-- 伺服器版本： 8.0.39
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `artists_treasure`
--
CREATE DATABASE IF NOT EXISTS `artists_treasure` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `artists_treasure`;

-- --------------------------------------------------------

--
-- 資料表結構 `ak_sequence`
--

CREATE TABLE `ak_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 傾印資料表的資料 `ak_sequence`
--

INSERT INTO `ak_sequence` (`seq`) VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- 資料表結構 `artwork`
--

CREATE TABLE `artwork` (
  `AK_ID` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `AK_DATE` date NOT NULL,
  `AK_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `AK_MATERIAL` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `AK_SIZE` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `AK_SIGNATURE_Y` decimal(4,0) NOT NULL,
  `AK_SIGNATURE_M` decimal(2,0) DEFAULT NULL,
  `AK_THEME` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `AK_INTRODUCE` text,
  `AK_TIMES` int DEFAULT NULL,
  `AK_RACETIMES` int DEFAULT NULL,
  `AK_LOCATION` varchar(30) NOT NULL,
  `AK_MEDIA` varchar(255) DEFAULT NULL,
  `AK_STATE` tinyint(1) NOT NULL,
  `REPRESENTATIVE` tinyint(1) NOT NULL DEFAULT '0',
  `AK_REMARK` text
) ;

--
-- 傾印資料表的資料 `artwork`
--

INSERT INTO `artwork` (`AK_ID`, `AK_DATE`, `AK_NAME`, `AK_MATERIAL`, `AK_SIZE`, `AK_SIGNATURE_Y`, `AK_SIGNATURE_M`, `AK_THEME`, `AK_INTRODUCE`, `AK_TIMES`, `AK_RACETIMES`, `AK_LOCATION`, `AK_MEDIA`, `AK_STATE`, `REPRESENTATIVE`, `AK_REMARK`) VALUES
('AK00001', '2024-11-05', '自畫像 ', '油畫', '65.1,50', 1888, 4, '自畫像', '這幅自畫像展現了梵谷對自身形象的探索，他用濃烈的色彩和粗獷的筆觸表達了自己的情感與精神狀態。', NULL, NULL, '梵谷博物館', './uploads/01.png', 0, 0, ''),
('AK00002', '2024-11-05', '夜晚露天咖啡座', '油畫', '80.7,65.3', 1888, 9, '夜晚', '此畫描繪了阿爾勒一家露天咖啡座的夜景，燈光和星空交相輝映，展現出生活中的溫馨與寧靜。', NULL, NULL, '庫勒穆勒博物館', './uploads/02.png', 1, 0, ''),
('AK00003', '2024-11-05', '向日葵', '油畫', '92.1,73', 1888, 8, '花卉', '向日葵系列是梵谷最著名的作品之一，色彩明亮，展現了花朵的生機與活力，象徵著希望與熱情。', NULL, NULL, '倫敦國家美術館', './uploads/03.png', 1, 0, ''),
('AK00004', '2024-11-05', '星夜', '油畫', '74,93', 1889, 6, '夜晚', '這幅畫描繪了梵谷在精神病院時的夜空，強烈的色彩與旋渦狀的星雲，傳達了他內心的波動與對宇宙的思索。', NULL, NULL, '現代藝術博物館', './uploads/04.png', 1, 0, ''),
('AK00005', '2024-11-05', '隆河上的星夜', '油畫', '72.5,92', 1888, 1, '夜晚', '此畫呈現了隆河的美景，星空的璀璨與河面的反射形成了夢幻般的畫面，展現了自然的和諧與寧靜。', NULL, NULL, '奧賽博物館', './uploads/05.png', 0, 0, ''),
('AK00006', '2024-11-06', '吃馬鈴薯的人', '油畫', '82,114', 1885, 2, '農村風景', '這幅畫描繪了農民的艱辛與日常生活，色調沉重，傳達了對勞動者的尊重和同情。', NULL, NULL, '梵谷博物館', './uploads/06.png', 0, 1, '');

--
-- 觸發器 `artwork`
--
DELIMITER $$
CREATE TRIGGER `before_delete_artwork` BEFORE DELETE ON `artwork` FOR EACH ROW BEGIN
    
    DELETE FROM ak_sequence WHERE seq = SUBSTRING(OLD.AK_ID, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_artwork` BEFORE INSERT ON `artwork` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM ak_sequence;
    
    INSERT INTO ak_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('AK', LPAD(new_seq, 5, '0'));
    
    SET NEW.AK_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `collection`
--

CREATE TABLE `collection` (
  `COL_ID` varchar(8) NOT NULL,
  `COL_DATE` date NOT NULL,
  `COL_ARTIST` varchar(255) DEFAULT NULL,
  `COL_NAME` varchar(255) DEFAULT NULL,
  `COL_MATERIAL` varchar(255) DEFAULT NULL,
  `COL_SIZE` varchar(20) NOT NULL,
  `COL_SIGNATURE_Y` decimal(4,0) NOT NULL,
  `COL_SIGNATURE_M` decimal(2,0) DEFAULT NULL,
  `COL_THEME` varchar(30) DEFAULT NULL,
  `COL_GET_DATE` date NOT NULL,
  `COL_PRICE` int DEFAULT NULL,
  `COL_INTRODUCE` text,
  `COL_TIMES` int DEFAULT NULL,
  `COL_LOCATION` text NOT NULL,
  `COL_MEDIA` varchar(255) DEFAULT NULL,
  `COL_STATE` tinyint(1) NOT NULL,
  `COL_REMARK` text
) ;

--
-- 傾印資料表的資料 `collection`
--

INSERT INTO `collection` (`COL_ID`, `COL_DATE`, `COL_ARTIST`, `COL_NAME`, `COL_MATERIAL`, `COL_SIZE`, `COL_SIGNATURE_Y`, `COL_SIGNATURE_M`, `COL_THEME`, `COL_GET_DATE`, `COL_PRICE`, `COL_INTRODUCE`, `COL_TIMES`, `COL_LOCATION`, `COL_MEDIA`, `COL_STATE`, `COL_REMARK`) VALUES
('COL00001', '2024-11-06', 'Jean-François Millet', '拾穗', 'canvas oil painting', '83.8,111.8', 1857, 5, '農村風景', '1986-06-09', 5000000, '這幅畫描繪了農民在麥田裡拾穗的場景，展現了艱辛的勞動與農村生活的真實感，色調沉穩，強調了生活的質樸。', NULL, '奧賽博物館 ', './uploads/07.png', 0, ''),
('COL00002', '2024-11-06', 'Édouard Manet', '草地上的午餐', 'canvas oil painting', '130.5,190', 1863, 3, '農村風景', '1986-01-12', 15000000, '此畫展現了一群人聚集在草地上享用午餐的情景，色彩明亮，生動的筆觸捕捉了社交活動的快樂與輕鬆氛圍。', NULL, '奧賽博物館', './uploads/08.png', 0, ''),
('COL00003', '2024-11-06', 'Édouard Manet', '奧林匹亞 ', 'canvas oil painting', '130.5,190', 1863, 7, '社交場合', '1932-07-25', 8240000, '這幅畫以一位裸體女性為主題，描繪了她在奧林匹亞的姿態，挑戰了當時社會對女性的傳統觀念，引起了極大的爭議。', NULL, '奧賽博物館 ', './uploads/09.png', 0, ''),
('COL00004', '2024-11-06', 'Pierre-Auguste Renoir', '煎餅磨坊的舞會', 'canvas oil painting', '131,75', 1876, 12, '農村風景', '1986-12-22', 4390000, '此畫描繪了一個社交舞會的熱鬧場景，鮮豔的色彩與動感的筆觸展現了社會生活中的歡樂與活力。', NULL, '奧賽博物館', './uploads/10.png', 0, ''),
('COL00005', '2024-11-06', 'Eugène Henri Paul Gauguin', '沙灘上的大溪地女人', 'canvas oil painting', '69,91', 1891, 5, '社交場合', '1985-12-04', 1200000, '這幅畫展示了大溪地女性的優雅姿態，使用了明亮的色彩和簡約的構圖，展現了當地的文化與自然美。', NULL, '奧賽博物館', './uploads/11.png', 0, ''),
('COL00006', '2024-11-06', 'Eugène Delacroix', '獵獅', 'canvas oil painting', '198,265', 1861, 4, '宗教與建築', '1986-11-17', 330000, '此畫捕捉了獵獅的瞬間，強烈的色彩與動態的構圖傳達了力量與勇氣，展現了人類與自然的關係。', NULL, '奧賽博物館', './uploads/12.png', 0, '');

--
-- 觸發器 `collection`
--
DELIMITER $$
CREATE TRIGGER `before_delete_COLLECTION` BEFORE DELETE ON `collection` FOR EACH ROW BEGIN
    
    DELETE FROM COL_sequence WHERE seq = SUBSTRING(OLD.COL_ID, 4);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_COLLECTION` BEFORE INSERT ON `collection` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM COL_sequence;
    
    INSERT INTO COL_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('COL', LPAD(new_seq, 5, '0'));
    
    SET NEW.COL_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `col_sequence`
--

CREATE TABLE `col_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 傾印資料表的資料 `col_sequence`
--

INSERT INTO `col_sequence` (`seq`) VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- 資料表結構 `contest`
--

CREATE TABLE `contest` (
  `CT_ID` varchar(7) NOT NULL,
  `CT_LOCATION` varchar(255) NOT NULL,
  `CT_ORGANIZER` varchar(255) NOT NULL,
  `CT_NAME` varchar(255) NOT NULL,
  `CT_START` date NOT NULL,
  `CT_END` date NOT NULL,
  `CT_ITEM` int NOT NULL,
  `CT_INTRODUCE` text NOT NULL,
  `CT_REMARK` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `contest`
--
DELIMITER $$
CREATE TRIGGER `after_delete_CONTEST` BEFORE DELETE ON `contest` FOR EACH ROW BEGIN
    
    DELETE FROM CT_sequence WHERE seq = SUBSTRING(OLD.CT_ID, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_CONTEST` BEFORE INSERT ON `contest` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);

    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM CT_sequence;

    
    INSERT INTO CT_sequence (seq) VALUES (new_seq);

    
    SET new_id = CONCAT('CT', LPAD(new_seq, 5, '0'));

    
    SET NEW.CT_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `contestdetail`
--

CREATE TABLE `contestdetail` (
  `CTD_ID` varchar(8) NOT NULL,
  `CT_ID` varchar(7) NOT NULL,
  `AK_ID` varchar(7) NOT NULL,
  `CTD_NAME` varchar(255) DEFAULT NULL,
  `CTD_RANK` int NOT NULL,
  `CTD_AMOUNT` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `contestdetail`
--
DELIMITER $$
CREATE TRIGGER `before_delete_contestdetail` BEFORE DELETE ON `contestdetail` FOR EACH ROW BEGIN
    
    DELETE FROM ctd_sequence WHERE seq = SUBSTRING(OLD.CTD_ID, 4);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_contestdetail` BEFORE INSERT ON `contestdetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);

    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM ctd_sequence;

    
    INSERT INTO ctd_sequence (seq) VALUES (new_seq);

    
    SET new_id = CONCAT('CTD', LPAD(new_seq, 5, '0'));

    
    SET NEW.CTD_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `ctd_sequence`
--

CREATE TABLE `ctd_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `ct_sequence`
--

CREATE TABLE `ct_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `end_sequence`
--

CREATE TABLE `end_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `en_sequence`
--

CREATE TABLE `en_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `exhibition`
--

CREATE TABLE `exhibition` (
  `EN_ID` varchar(7) NOT NULL,
  `EN_LOCATION` varchar(255) NOT NULL,
  `EN_ORGANIZER` varchar(255) NOT NULL,
  `EN_NAME` varchar(255) NOT NULL,
  `EN_START` date NOT NULL,
  `EN_FINISH` date NOT NULL,
  `EN_ITEM` int NOT NULL,
  `EN_INTRODUCE` text,
  `EN_REMARK` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `exhibition`
--
DELIMITER $$
CREATE TRIGGER `before_delete_exhibition` BEFORE DELETE ON `exhibition` FOR EACH ROW BEGIN
    
    DELETE FROM en_sequence WHERE seq = SUBSTRING(OLD.EN_ID, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_exhibition` BEFORE INSERT ON `exhibition` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM en_sequence;
    
    INSERT INTO en_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('EN', LPAD(new_seq, 5, '0'));
    
    SET NEW.EN_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `exhibitiondetail`
--

CREATE TABLE `exhibitiondetail` (
  `END_ID` varchar(8) NOT NULL,
  `EN_ID` varchar(7) NOT NULL,
  `AK_ID` varchar(7) DEFAULT NULL,
  `COL_ID` varchar(8) DEFAULT NULL,
  `END_NAME` varchar(255) DEFAULT NULL
) ;

--
-- 觸發器 `exhibitiondetail`
--
DELIMITER $$
CREATE TRIGGER `before_delete_exhibitiondetail` BEFORE DELETE ON `exhibitiondetail` FOR EACH ROW BEGIN
    
    DELETE FROM end_sequence WHERE seq = SUBSTRING(OLD.END_ID, 4);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_exhibitiondetail` BEFORE INSERT ON `exhibitiondetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM end_sequence;
    
    INSERT INTO end_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('END', LPAD(new_seq, 5, '0'));
    
    SET NEW.END_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `oend_sequence`
--

CREATE TABLE `oend_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `oen_sequence`
--

CREATE TABLE `oen_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `onlineexhibition`
--

CREATE TABLE `onlineexhibition` (
  `OEN_ID` varchar(8) NOT NULL,
  `OEN_NAME` varchar(255) NOT NULL,
  `OEN_START` date NOT NULL,
  `OEN_FINISH` date NOT NULL,
  `OEN_ITEM` int NOT NULL,
  `OEN_INTRODUCE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `OEN_REMARK` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `onlineexhibition`
--
DELIMITER $$
CREATE TRIGGER `before_delete_onlineexhibition` BEFORE DELETE ON `onlineexhibition` FOR EACH ROW BEGIN
    
    DELETE FROM oen_sequence WHERE seq = SUBSTRING(OLD.OEN_ID, 4);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_onlineexhibition` BEFORE INSERT ON `onlineexhibition` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);

    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM oen_sequence;

    
    INSERT INTO oen_sequence (seq) VALUES (new_seq);

    
    SET new_id = CONCAT('OEN', LPAD(new_seq, 5, '0'));

    
    SET NEW.OEN_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `onlineexhibitiondetail`
--

CREATE TABLE `onlineexhibitiondetail` (
  `OEND_ID` varchar(9) NOT NULL,
  `OEN_ID` varchar(8) NOT NULL,
  `AK_ID` varchar(7) DEFAULT NULL,
  `COL_ID` varchar(8) DEFAULT NULL,
  `OEND_NAME` varchar(255) DEFAULT NULL
) ;

--
-- 觸發器 `onlineexhibitiondetail`
--
DELIMITER $$
CREATE TRIGGER `before_delete_onlineexhibitiondetail` BEFORE DELETE ON `onlineexhibitiondetail` FOR EACH ROW BEGIN
    
    DELETE FROM oend_sequence WHERE seq = SUBSTRING(OLD.OEND_ID, 5);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_onlineexhibitiondetail` BEFORE INSERT ON `onlineexhibitiondetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(9);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM oend_sequence;
    
    INSERT INTO oend_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('OEND', LPAD(new_seq, 5, '0'));
    
    SET NEW.OEND_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `pe_sequence`
--

CREATE TABLE `pe_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `place`
--

CREATE TABLE `place` (
  `PE_ID` varchar(7) NOT NULL,
  `PE_NAME` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `place`
--
DELIMITER $$
CREATE TRIGGER `before_delete_place` BEFORE DELETE ON `place` FOR EACH ROW BEGIN
    
    DELETE FROM pe_sequence WHERE seq = SUBSTRING(OLD.PE_ID, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_place` BEFORE INSERT ON `place` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM pe_sequence;
    
    INSERT INTO pe_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('PE', LPAD(new_seq, 5, '0'));
    
    SET NEW.PE_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int UNSIGNED NOT NULL,
  `dbase` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `user` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `query` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_type` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_length` text COLLATE utf8mb3_bin,
  `col_collation` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) COLLATE utf8mb3_bin DEFAULT '',
  `col_default` text COLLATE utf8mb3_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int UNSIGNED NOT NULL,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `column_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `transformation_options` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `input_transformation` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) COLLATE utf8mb3_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `settings_data` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `export_type` varchar(10) COLLATE utf8mb3_bin NOT NULL,
  `template_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `template_data` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tables` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sqlquery` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `item_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `item_type` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `page_nr` int UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tables` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Recently accessed tables';

--
-- 傾印資料表的資料 `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"artists_treasure\",\"table\":\"artwork\"},{\"db\":\"artists_treasure\",\"table\":\"ak_sequence\"},{\"db\":\"artists_treasure\",\"table\":\"contest\"},{\"db\":\"artists_treasure\",\"table\":\"col_sequence\"},{\"db\":\"artists_treasure\",\"table\":\"collection\"},{\"db\":\"artists_treasure\",\"table\":\"tradedetail\"},{\"db\":\"artists_treasure\",\"table\":\"trade\"},{\"db\":\"artists_treasure\",\"table\":\"theme\"},{\"db\":\"artists_treasure\",\"table\":\"te_sequence\"},{\"db\":\"artists_treasure\",\"table\":\"tde_sequence\"}]');

-- --------------------------------------------------------

--
-- 資料表結構 `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `master_table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `master_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_db` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_table` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `foreign_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `search_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `search_data` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `pdf_page_number` int NOT NULL DEFAULT '0',
  `x` float UNSIGNED NOT NULL DEFAULT '0',
  `y` float UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `display_field` varchar(64) COLLATE utf8mb3_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `prefs` text COLLATE utf8mb3_bin NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Tables'' UI preferences';

--
-- 傾印資料表的資料 `pma__table_uiprefs`
--

INSERT INTO `pma__table_uiprefs` (`username`, `db_name`, `table_name`, `prefs`, `last_update`) VALUES
('root', 'artists_treasure', 'collection', '{\"sorted_col\":\"`collection`.`COL_MEDIA` DESC\"}', '2024-10-23 20:23:58');

-- --------------------------------------------------------

--
-- 資料表結構 `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `version` int UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text COLLATE utf8mb3_bin NOT NULL,
  `schema_sql` text COLLATE utf8mb3_bin,
  `data_sql` longtext COLLATE utf8mb3_bin,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') COLLATE utf8mb3_bin DEFAULT NULL,
  `tracking_active` int UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `config_data` text COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- 傾印資料表的資料 `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2024-10-23 22:28:16', '{\"lang\":\"zh_TW\",\"ThemeDefault\":\"pmahomme\",\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- 資料表結構 `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `tab` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `allowed` enum('Y','N') COLLATE utf8mb3_bin NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- 資料表結構 `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) COLLATE utf8mb3_bin NOT NULL,
  `usergroup` varchar(64) COLLATE utf8mb3_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='Users and their assignments to user groups';

-- --------------------------------------------------------

--
-- 資料表結構 `tded_sequence`
--

CREATE TABLE `tded_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `tde_sequence`
--

CREATE TABLE `tde_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `te_sequence`
--

CREATE TABLE `te_sequence` (
  `seq` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `theme`
--

CREATE TABLE `theme` (
  `TE_ID` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TE_NAME` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `theme`
--
DELIMITER $$
CREATE TRIGGER `before_delete_theme` BEFORE DELETE ON `theme` FOR EACH ROW BEGIN
    
    DELETE FROM te_sequence WHERE seq = SUBSTRING(OLD.TE_ID, 3);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_theme` BEFORE INSERT ON `theme` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM te_sequence;
    
    INSERT INTO te_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('TE', LPAD(new_seq, 5, '0'));
    
    SET NEW.TE_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `trade`
--

CREATE TABLE `trade` (
  `TDE_ID` varchar(8) NOT NULL,
  `TDE_PLACE` varchar(255) NOT NULL,
  `TDE_DATE` date NOT NULL,
  `TDE_BUYER` varchar(100) NOT NULL,
  `TDE_SELLER` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TDE_TOTAL_ITEM` int NOT NULL,
  `TDE_TOTAL_PRICE` int NOT NULL,
  `TDE_REMARK` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 觸發器 `trade`
--
DELIMITER $$
CREATE TRIGGER `before_delete_trade` BEFORE DELETE ON `trade` FOR EACH ROW BEGIN
    
    DELETE FROM tde_sequence WHERE seq = SUBSTRING(OLD.TDE_ID, 4);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_trade` BEFORE INSERT ON `trade` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM tde_sequence;
    
    INSERT INTO tde_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('TDE', LPAD(new_seq, 5, '0'));
    
    SET NEW.TDE_ID = new_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `tradedetail`
--

CREATE TABLE `tradedetail` (
  `TDED_ID` varchar(9) NOT NULL,
  `TDE_ID` varchar(8) NOT NULL,
  `AK_ID` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `COL_ID` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TDED_PRICE` int NOT NULL,
  `TDED_REMARK` text
) ;

--
-- 觸發器 `tradedetail`
--
DELIMITER $$
CREATE TRIGGER `before_delete_tradedetail` BEFORE DELETE ON `tradedetail` FOR EACH ROW BEGIN
    
    DELETE FROM tded_sequence WHERE seq = SUBSTRING(OLD.TDED_ID, 5);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_tradedetail` BEFORE INSERT ON `tradedetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(9);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM tded_sequence;
    
    INSERT INTO tded_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('TDED', LPAD(new_seq, 5, '0'));
    
    SET NEW.TDED_ID = new_id;
END
$$
DELIMITER ;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `ak_sequence`
--
ALTER TABLE `ak_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `artwork`
--
ALTER TABLE `artwork`
  ADD PRIMARY KEY (`AK_ID`);

--
-- 資料表索引 `collection`
--
ALTER TABLE `collection`
  ADD PRIMARY KEY (`COL_ID`);

--
-- 資料表索引 `col_sequence`
--
ALTER TABLE `col_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `contest`
--
ALTER TABLE `contest`
  ADD PRIMARY KEY (`CT_ID`);

--
-- 資料表索引 `ctd_sequence`
--
ALTER TABLE `ctd_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `ct_sequence`
--
ALTER TABLE `ct_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `end_sequence`
--
ALTER TABLE `end_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `en_sequence`
--
ALTER TABLE `en_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `exhibition`
--
ALTER TABLE `exhibition`
  ADD PRIMARY KEY (`EN_ID`);

--
-- 資料表索引 `exhibitiondetail`
--
ALTER TABLE `exhibitiondetail`
  ADD KEY `EN_ID` (`EN_ID`),
  ADD KEY `AK_ID` (`AK_ID`),
  ADD KEY `COL_ID` (`COL_ID`);

--
-- 資料表索引 `oend_sequence`
--
ALTER TABLE `oend_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `oen_sequence`
--
ALTER TABLE `oen_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `onlineexhibition`
--
ALTER TABLE `onlineexhibition`
  ADD PRIMARY KEY (`OEN_ID`);

--
-- 資料表索引 `onlineexhibitiondetail`
--
ALTER TABLE `onlineexhibitiondetail`
  ADD PRIMARY KEY (`OEND_ID`),
  ADD KEY `AK_ID` (`AK_ID`),
  ADD KEY `OEN_ID` (`OEN_ID`),
  ADD KEY `COL_ID` (`COL_ID`);

--
-- 資料表索引 `pe_sequence`
--
ALTER TABLE `pe_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `place`
--
ALTER TABLE `place`
  ADD PRIMARY KEY (`PE_ID`);

--
-- 資料表索引 `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- 資料表索引 `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- 資料表索引 `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- 資料表索引 `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- 資料表索引 `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- 資料表索引 `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- 資料表索引 `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- 資料表索引 `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- 資料表索引 `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- 資料表索引 `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- 資料表索引 `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- 資料表索引 `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- 資料表索引 `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- 資料表索引 `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- 資料表索引 `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- 資料表索引 `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- 資料表索引 `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- 資料表索引 `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- 資料表索引 `tded_sequence`
--
ALTER TABLE `tded_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `tde_sequence`
--
ALTER TABLE `tde_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `te_sequence`
--
ALTER TABLE `te_sequence`
  ADD PRIMARY KEY (`seq`);

--
-- 資料表索引 `theme`
--
ALTER TABLE `theme`
  ADD PRIMARY KEY (`TE_ID`),
  ADD UNIQUE KEY `TE_NAME` (`TE_NAME`);

--
-- 資料表索引 `trade`
--
ALTER TABLE `trade`
  ADD PRIMARY KEY (`TDE_ID`);

--
-- 資料表索引 `tradedetail`
--
ALTER TABLE `tradedetail`
  ADD PRIMARY KEY (`TDED_ID`),
  ADD KEY `TDE_ID` (`TDE_ID`),
  ADD KEY `AK_ID` (`AK_ID`),
  ADD KEY `COL_ID` (`COL_ID`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `exhibitiondetail`
--
ALTER TABLE `exhibitiondetail`
  ADD CONSTRAINT `exhibitiondetail_ibfk_1` FOREIGN KEY (`EN_ID`) REFERENCES `exhibition` (`EN_ID`),
  ADD CONSTRAINT `exhibitiondetail_ibfk_2` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  ADD CONSTRAINT `exhibitiondetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`);

--
-- 資料表的限制式 `onlineexhibitiondetail`
--
ALTER TABLE `onlineexhibitiondetail`
  ADD CONSTRAINT `onlineexhibitiondetail_ibfk_1` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  ADD CONSTRAINT `onlineexhibitiondetail_ibfk_2` FOREIGN KEY (`OEN_ID`) REFERENCES `onlineexhibition` (`OEN_ID`),
  ADD CONSTRAINT `onlineexhibitiondetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`);

--
-- 資料表的限制式 `tradedetail`
--
ALTER TABLE `tradedetail`
  ADD CONSTRAINT `tradedetail_ibfk_1` FOREIGN KEY (`TDE_ID`) REFERENCES `trade` (`TDE_ID`),
  ADD CONSTRAINT `tradedetail_ibfk_2` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  ADD CONSTRAINT `tradedetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
