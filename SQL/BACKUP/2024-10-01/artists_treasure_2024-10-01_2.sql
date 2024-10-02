-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: artists_treasure
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ak_sequence`
--

DROP TABLE IF EXISTS `ak_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ak_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ak_sequence`
--

/*!40000 ALTER TABLE `ak_sequence` DISABLE KEYS */;
INSERT INTO `ak_sequence` VALUES (1);
/*!40000 ALTER TABLE `ak_sequence` ENABLE KEYS */;

--
-- Table structure for table `artwork`
--

DROP TABLE IF EXISTS `artwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artwork` (
  `AK_ID` varchar(7) NOT NULL,
  `AK_DATE` date NOT NULL,
  `AK_NAME` varchar(255) NOT NULL,
  `AK_MATERIAL` varchar(255) DEFAULT NULL,
  `AK_SIZE` varchar(20) DEFAULT NULL,
  `AK_SIGNATURE_Y` decimal(4,0) NOT NULL,
  `AK_SIGNATURE_M` decimal(2,0) DEFAULT NULL,
  `AK_THEME` varchar(30) DEFAULT NULL,
  `AK_INTRODUCE` text,
  `AK_TIMES` int DEFAULT NULL,
  `AK_RACETIMES` int DEFAULT NULL,
  `AK_LOCATION` varchar(30) NOT NULL,
  `AK_MEDIA` varchar(255) DEFAULT NULL,
  `AK_STATE` tinyint(1) NOT NULL,
  `AK_REMARK` text,
  PRIMARY KEY (`AK_ID`),
  UNIQUE KEY `AK_THEME` (`AK_THEME`),
  CONSTRAINT `artwork_chk_1` CHECK ((`AK_SIGNATURE_Y` between 0 and 2100)),
  CONSTRAINT `artwork_chk_2` CHECK ((`AK_SIGNATURE_M` between 1 and 12))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artwork`
--

/*!40000 ALTER TABLE `artwork` DISABLE KEYS */;
INSERT INTO `artwork` VALUES ('AK00001','2024-09-25','Self portrait as a painter','Oil Painting','65.1,50',1888,NULL,'self-portrait','Van Gogh presented himself in this self-portrait as a painter, holding a palette and paintbrushes behind his easel. He showed that he was a modern artist by using a new painting style, with bright, almost unblended colours. The palette contains the complementary colour pairs red/green, yellow/purple and blue/orange – precisely the colours Van Gogh used for this painting. He laid these pairs down side by side to intensify one another: the blue of his smock, for instance, and the orange-red of his beard.',4,NULL,'梵谷博物館','C:\\Users\\LTU\\Desktop\\Media\\Self portrait as a painter.jpg',1,NULL);
/*!40000 ALTER TABLE `artwork` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_artwork` BEFORE INSERT ON `artwork` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM ak_sequence;
    
    INSERT INTO ak_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('AK', LPAD(new_seq, 5, '0'));
    
    SET NEW.AK_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_artwork` BEFORE DELETE ON `artwork` FOR EACH ROW BEGIN
    
    DELETE FROM ak_sequence WHERE seq = SUBSTRING(OLD.AK_ID, 3);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `col_sequence`
--

DROP TABLE IF EXISTS `col_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `col_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `col_sequence`
--

/*!40000 ALTER TABLE `col_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `col_sequence` ENABLE KEYS */;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  `COL_REMARK` text,
  PRIMARY KEY (`COL_ID`),
  CONSTRAINT `collection_chk_1` CHECK ((`COL_SIGNATURE_Y` between 0 and 2100)),
  CONSTRAINT `collection_chk_2` CHECK ((`COL_SIGNATURE_M` between 1 and 12))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_COLLECTION` BEFORE INSERT ON `collection` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM COL_sequence;
    
    INSERT INTO COL_sequence (seq) VALUES (new_seq);
    
    SET new_id = CONCAT('COL', LPAD(new_seq, 5, '0'));
    
    SET NEW.COL_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_COLLECTION` BEFORE DELETE ON `collection` FOR EACH ROW BEGIN
    
    DELETE FROM COL_sequence WHERE seq = SUBSTRING(OLD.COL_ID, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `contest`
--

DROP TABLE IF EXISTS `contest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contest` (
  `CT_ID` varchar(7) NOT NULL,
  `CT_LOCATION` varchar(255) NOT NULL,
  `CT_ORGANIZER` varchar(255) NOT NULL,
  `CT_NAME` varchar(255) NOT NULL,
  `CT_START` date NOT NULL,
  `CT_END` date NOT NULL,
  `CT_ITEM` int NOT NULL,
  `CT_INTRODUCE` text NOT NULL,
  `CT_REMARK` text NOT NULL,
  PRIMARY KEY (`CT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contest`
--

/*!40000 ALTER TABLE `contest` DISABLE KEYS */;
INSERT INTO `contest` VALUES ('CT00001','線上','財團法人王源林文化藝術基金會','第 10 屆「竹梅源文藝獎」全國油畫創作比賽-初審','2024-10-28','2024-11-01',1,'為提升藝術文化水準，促進藝術創作交流，致力藝術教育平台，「財團法人王源林文化藝術基金會」成立「竹梅源文藝獎」，希望推廣藝術、提昇文化品質，發掘鼓勵更多青年藝術菁英。','\"可採紙本報名。 https://wylf.org.tw/2024-%E3%80%8C%E7%AB%B9%E6%A2%85%E6%BA%90%E6%96%87%E8%97%9D%E7%8D%8E%E3%80%8D%E7%AC%AC10%E5%B1%86%E5%85%A8%E5%9C%8B%E6%B2%B9%E7%95%AB%E5%89%B5%E4%BD%9C%E6%AF%94%E8%B3%BD/\"');
/*!40000 ALTER TABLE `contest` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_CONTEST` BEFORE INSERT ON `contest` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_delete_CONTEST` BEFORE DELETE ON `contest` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM CT_sequence WHERE seq = SUBSTRING(OLD.CT_ID, 3);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `contestdetail`
--

DROP TABLE IF EXISTS `contestdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contestdetail` (
  `CTD_ID` varchar(8) NOT NULL,
  `CT_ID` varchar(7) NOT NULL,
  `AK_ID` varchar(7) NOT NULL,
  `CTD_NAME` varchar(255) DEFAULT NULL,
  `CTD_RANK` int NOT NULL,
  `CTD_AMOUNT` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contestdetail`
--

/*!40000 ALTER TABLE `contestdetail` DISABLE KEYS */;
INSERT INTO `contestdetail` VALUES ('CTD00002','CT00001','AK00001','Self portrait as a painter',1,300000),('CTD00003','CT00001','AK00001','Self portrait as a painter',1,300000),('CTD00004','CT00001','AK00001','Self portrait as a painter',1,300000);
/*!40000 ALTER TABLE `contestdetail` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_contestdetail` BEFORE INSERT ON `contestdetail` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_contestdetail` BEFORE DELETE ON `contestdetail` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM ctd_sequence WHERE seq = SUBSTRING(OLD.CTD_ID, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ct_sequence`
--

DROP TABLE IF EXISTS `ct_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ct_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ct_sequence`
--

/*!40000 ALTER TABLE `ct_sequence` DISABLE KEYS */;
INSERT INTO `ct_sequence` VALUES (1);
/*!40000 ALTER TABLE `ct_sequence` ENABLE KEYS */;

--
-- Table structure for table `ctd_sequence`
--

DROP TABLE IF EXISTS `ctd_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ctd_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctd_sequence`
--

/*!40000 ALTER TABLE `ctd_sequence` DISABLE KEYS */;
INSERT INTO `ctd_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `ctd_sequence` ENABLE KEYS */;

--
-- Table structure for table `en_sequence`
--

DROP TABLE IF EXISTS `en_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `en_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `en_sequence`
--

/*!40000 ALTER TABLE `en_sequence` DISABLE KEYS */;
INSERT INTO `en_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `en_sequence` ENABLE KEYS */;

--
-- Table structure for table `end_sequence`
--

DROP TABLE IF EXISTS `end_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `end_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `end_sequence`
--

/*!40000 ALTER TABLE `end_sequence` DISABLE KEYS */;
INSERT INTO `end_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `end_sequence` ENABLE KEYS */;

--
-- Table structure for table `exhibition`
--

DROP TABLE IF EXISTS `exhibition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exhibition` (
  `EN_ID` varchar(7) NOT NULL,
  `EN_LOCATION` varchar(255) NOT NULL,
  `EN_ORGANIZER` varchar(255) NOT NULL,
  `EN_NAME` varchar(255) NOT NULL,
  `EN_START` date NOT NULL,
  `EN_FINISH` date NOT NULL,
  `EN_ITEM` int NOT NULL,
  `EN_INTRODUCE` text,
  `EN_REMARK` text,
  PRIMARY KEY (`EN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exhibition`
--

/*!40000 ALTER TABLE `exhibition` DISABLE KEYS */;
INSERT INTO `exhibition` VALUES ('EN00002','國立美術館','國立美術館','梵谷畫展','2024-08-10','2024-10-01',1,NULL,NULL),('EN00003','國立美術館','國立美術館','梵谷畫展','2024-08-10','2024-10-01',1,NULL,NULL),('EN00004','國立美術館','國立美術館','梵谷畫展','2024-08-10','2024-10-01',1,NULL,NULL);
/*!40000 ALTER TABLE `exhibition` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_exhibition` BEFORE INSERT ON `exhibition` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_exhibition` BEFORE DELETE ON `exhibition` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM en_sequence WHERE seq = SUBSTRING(OLD.EN_ID, 3);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `exhibitiondetail`
--

DROP TABLE IF EXISTS `exhibitiondetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exhibitiondetail` (
  `END_ID` varchar(8) NOT NULL,
  `EN_ID` varchar(7) NOT NULL,
  `AK_ID` varchar(7) DEFAULT NULL,
  `COL_ID` varchar(8) DEFAULT NULL,
  `END_NAME` varchar(255) DEFAULT NULL,
  KEY `EN_ID` (`EN_ID`),
  KEY `AK_ID` (`AK_ID`),
  KEY `COL_ID` (`COL_ID`),
  CONSTRAINT `exhibitiondetail_ibfk_1` FOREIGN KEY (`EN_ID`) REFERENCES `exhibition` (`EN_ID`),
  CONSTRAINT `exhibitiondetail_ibfk_2` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  CONSTRAINT `exhibitiondetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`),
  CONSTRAINT `exhibitiondetail_chk_1` CHECK ((((`AK_ID` is not null) and (`COL_ID` is null)) or ((`AK_ID` is null) and (`COL_ID` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exhibitiondetail`
--

/*!40000 ALTER TABLE `exhibitiondetail` DISABLE KEYS */;
INSERT INTO `exhibitiondetail` VALUES ('END00002','EN00002','AK00001',NULL,'Self portrait as a painter'),('END00003','EN00002','AK00001',NULL,'Self portrait as a painter'),('END00004','EN00002','AK00001',NULL,'Self portrait as a painter');
/*!40000 ALTER TABLE `exhibitiondetail` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_exhibitiondetail` BEFORE INSERT ON `exhibitiondetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM end_sequence;
    -- 插入輔助表以存儲新的序號
    INSERT INTO end_sequence (seq) VALUES (new_seq);
    -- 使用新序號生成格式為 'END00001' 的 ID
    SET new_id = CONCAT('END', LPAD(new_seq, 5, '0'));
    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.END_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_exhibitiondetail` BEFORE DELETE ON `exhibitiondetail` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM end_sequence WHERE seq = SUBSTRING(OLD.END_ID, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pe_sequence`
--

DROP TABLE IF EXISTS `pe_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pe_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pe_sequence`
--

/*!40000 ALTER TABLE `pe_sequence` DISABLE KEYS */;
INSERT INTO `pe_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `pe_sequence` ENABLE KEYS */;

--
-- Table structure for table `place`
--

DROP TABLE IF EXISTS `place`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `place` (
  `PE_ID` varchar(7) NOT NULL,
  `PE_NAME` varchar(30) NOT NULL,
  PRIMARY KEY (`PE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `place`
--

/*!40000 ALTER TABLE `place` DISABLE KEYS */;
INSERT INTO `place` VALUES ('PE00002','庫勒穆勒博物館'),('PE00003','臥室'),('PE00004','臥室');
/*!40000 ALTER TABLE `place` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_place` BEFORE INSERT ON `place` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_place` BEFORE DELETE ON `place` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM pe_sequence WHERE seq = SUBSTRING(OLD.PE_ID, 3);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tde_sequence`
--

DROP TABLE IF EXISTS `tde_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tde_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tde_sequence`
--

/*!40000 ALTER TABLE `tde_sequence` DISABLE KEYS */;
INSERT INTO `tde_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `tde_sequence` ENABLE KEYS */;

--
-- Table structure for table `tded_sequence`
--

DROP TABLE IF EXISTS `tded_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tded_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tded_sequence`
--

/*!40000 ALTER TABLE `tded_sequence` DISABLE KEYS */;
INSERT INTO `tded_sequence` VALUES (2),(3),(4);
/*!40000 ALTER TABLE `tded_sequence` ENABLE KEYS */;

--
-- Table structure for table `te_sequence`
--

DROP TABLE IF EXISTS `te_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `te_sequence` (
  `seq` int NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `te_sequence`
--

/*!40000 ALTER TABLE `te_sequence` DISABLE KEYS */;
INSERT INTO `te_sequence` VALUES (2),(3);
/*!40000 ALTER TABLE `te_sequence` ENABLE KEYS */;

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theme` (
  `TE_ID` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TE_NAME` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`TE_ID`),
  UNIQUE KEY `TE_NAME` (`TE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme`
--

/*!40000 ALTER TABLE `theme` DISABLE KEYS */;
INSERT INTO `theme` VALUES ('TE00002','landscape painting'),('TE00003','self-portrait');
/*!40000 ALTER TABLE `theme` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_theme` BEFORE INSERT ON `theme` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(7);
    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM te_sequence;
    -- 插入輔助表以存儲新的序號
    INSERT INTO te_sequence (seq) VALUES (new_seq);
    -- 使用新序號生成格式為 'TE00001' 的 ID
    SET new_id = CONCAT('TE', LPAD(new_seq, 5, '0'));
    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.TE_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_theme` BEFORE DELETE ON `theme` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM te_sequence WHERE seq = SUBSTRING(OLD.TE_ID, 3);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `trade`
--

DROP TABLE IF EXISTS `trade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trade` (
  `TDE_ID` varchar(8) NOT NULL,
  `TDE_PLACE` varchar(255) NOT NULL,
  `TDE_DATE` date NOT NULL,
  `TDE_BUYER` varchar(100) NOT NULL,
  `TDE_SELLER` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TDE_TOTAL_ITEM` int NOT NULL,
  `TDE_TOTAL_PRICE` int NOT NULL,
  `TDE_REMARK` text,
  PRIMARY KEY (`TDE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade`
--

/*!40000 ALTER TABLE `trade` DISABLE KEYS */;
INSERT INTO `trade` VALUES ('TDE00002','私下交易','2024-10-01','王曉明','張家豪',1,8500000,NULL),('TDE00003','私下交易','2024-10-01','王曉明','張家豪',1,8500000,NULL),('TDE00004','私下交易','2024-10-01','王曉明','張家豪',1,8500000,NULL);
/*!40000 ALTER TABLE `trade` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_trade` BEFORE INSERT ON `trade` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(8);
    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM tde_sequence;
    -- 插入輔助表以存儲新的序號
    INSERT INTO tde_sequence (seq) VALUES (new_seq);
    -- 使用新序號生成格式為 'TDE00001' 的 ID
    SET new_id = CONCAT('TDE', LPAD(new_seq, 5, '0'));
    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.TDE_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_trade` BEFORE DELETE ON `trade` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM tde_sequence WHERE seq = SUBSTRING(OLD.TDE_ID, 4);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tradedetail`
--

DROP TABLE IF EXISTS `tradedetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tradedetail` (
  `TDED_ID` varchar(9) NOT NULL,
  `TDE_ID` varchar(8) NOT NULL,
  `AK_ID` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `COL_ID` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TDED_PRICE` int NOT NULL,
  `TDED_REMARK` text,
  PRIMARY KEY (`TDED_ID`),
  KEY `TDE_ID` (`TDE_ID`),
  KEY `AK_ID` (`AK_ID`),
  KEY `COL_ID` (`COL_ID`),
  CONSTRAINT `tradedetail_ibfk_1` FOREIGN KEY (`TDE_ID`) REFERENCES `trade` (`TDE_ID`),
  CONSTRAINT `tradedetail_ibfk_2` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  CONSTRAINT `tradedetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`),
  CONSTRAINT `tradedetail_chk_1` CHECK ((((`AK_ID` is not null) and (`COL_ID` is null)) or ((`AK_ID` is null) and (`COL_ID` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tradedetail`
--

/*!40000 ALTER TABLE `tradedetail` DISABLE KEYS */;
INSERT INTO `tradedetail` VALUES ('TDED00002','TDE00002','AK00001',NULL,8500000,'Self portrait as a painter'),('TDED00003','TDE00002','AK00001',NULL,8500000,'Self portrait as a painter'),('TDED00004','TDE00002','AK00001',NULL,8500000,'Self portrait as a painter');
/*!40000 ALTER TABLE `tradedetail` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_tradedetail` BEFORE INSERT ON `tradedetail` FOR EACH ROW BEGIN
    DECLARE new_seq INT;
    DECLARE new_id VARCHAR(9);
    -- 檢查序列表是否為空，並生成新序號
    SELECT IFNULL(MAX(seq), 0) + 1 INTO new_seq FROM tded_sequence;
    -- 插入輔助表以存儲新的序號
    INSERT INTO tded_sequence (seq) VALUES (new_seq);
    -- 使用新序號生成格式為 'TDED00001' 的 ID
    SET new_id = CONCAT('TDED', LPAD(new_seq, 5, '0'));
    -- 設定新插入的資料的 id 為自動生成的格式
    SET NEW.TDED_ID = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_delete_tradedetail` BEFORE DELETE ON `tradedetail` FOR EACH ROW BEGIN
    -- 刪除 sequence 表中的對應序號
    DELETE FROM tded_sequence WHERE seq = SUBSTRING(OLD.TDED_ID, 5);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'artists_treasure'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-01 11:50:37
