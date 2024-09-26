-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
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
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ak_sequence`
--

/*!40000 ALTER TABLE `ak_sequence` DISABLE KEYS */;
INSERT INTO `ak_sequence` VALUES (1),(2);
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
INSERT INTO `artwork` VALUES ('AK00001','2024-09-25','Self portrait as a painter','Oil Painting','65.1,50',1888,NULL,'self-portrait','Van Gogh presented himself in this self-portrait as a painter, holding a palette and paintbrushes behind his easel. He showed that he was a modern artist by using a new painting style, with bright, almost unblended colours. The palette contains the complementary colour pairs red/green, yellow/purple and blue/orange – precisely the colours Van Gogh used for this painting. He laid these pairs down side by side to intensify one another: the blue of his smock, for instance, and the orange-red of his beard.',4,NULL,'梵谷博物館','C:\\Users\\LTU\\Desktop\\Media\\Self portrait as a painter.jpg',1,NULL),('AK00002','2024-09-25','Café Terrace at Night','Oil Painting','80.7,65.3',1888,9,'landscape painting','Café Terrace at Night is an 1888 oil painting by the Dutch artist Vincent van Gogh. It is also known as The Cafe Terrace on the Place du Forum, and, when first exhibited in 1891, was entitled Coffeehouse, in the evening (Café, le soir).',3,NULL,'庫勒穆勒博物館','C:\\Users\\LTU\\Desktop\\Media\\Café Terrace at Night.jpg',1,NULL);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_AK_ID` BEFORE INSERT ON `artwork` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(7);
    INSERT INTO AK_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('AK', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.AK_ID = NEW_ID;
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
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `col_sequence`
--

/*!40000 ALTER TABLE `col_sequence` DISABLE KEYS */;
INSERT INTO `col_sequence` VALUES (1);
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
  `COL_DPRICE` int DEFAULT NULL,
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_COL_ID` BEFORE INSERT ON `collection` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(8);
    INSERT INTO COL_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('COL', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.COL_ID = NEW_ID;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_CT_ID` BEFORE INSERT ON `contest` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(7);
    INSERT INTO CT_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('CT', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.CT_ID = NEW_ID;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_CTD_ID` BEFORE INSERT ON `contestdetail` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(8);
    INSERT INTO CTD_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('CTD', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.CTD_ID = NEW_ID;
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
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ct_sequence`
--

/*!40000 ALTER TABLE `ct_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `ct_sequence` ENABLE KEYS */;

--
-- Table structure for table `ctd_sequence`
--

DROP TABLE IF EXISTS `ctd_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ctd_sequence` (
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctd_sequence`
--

/*!40000 ALTER TABLE `ctd_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctd_sequence` ENABLE KEYS */;

--
-- Table structure for table `en_sequence`
--

DROP TABLE IF EXISTS `en_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `en_sequence` (
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `en_sequence`
--

/*!40000 ALTER TABLE `en_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `en_sequence` ENABLE KEYS */;

--
-- Table structure for table `end_sequence`
--

DROP TABLE IF EXISTS `end_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `end_sequence` (
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `end_sequence`
--

/*!40000 ALTER TABLE `end_sequence` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_EN_ID` BEFORE INSERT ON `exhibition` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(7);
    INSERT INTO EN_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('EN', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.EN_ID = NEW_ID;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_END_ID` BEFORE INSERT ON `exhibitiondetail` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(8);
    INSERT INTO END_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('END', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.END_ID = NEW_ID;
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
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pe_sequence`
--

/*!40000 ALTER TABLE `pe_sequence` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_PE_ID` BEFORE INSERT ON `place` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(7);
    INSERT INTO PE_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('PE', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.PE_ID = NEW_ID;
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
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tde_sequence`
--

/*!40000 ALTER TABLE `tde_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `tde_sequence` ENABLE KEYS */;

--
-- Table structure for table `tded_sequence`
--

DROP TABLE IF EXISTS `tded_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tded_sequence` (
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tded_sequence`
--

/*!40000 ALTER TABLE `tded_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `tded_sequence` ENABLE KEYS */;

--
-- Table structure for table `te_sequence`
--

DROP TABLE IF EXISTS `te_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `te_sequence` (
  `SEQ` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `te_sequence`
--

/*!40000 ALTER TABLE `te_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `te_sequence` ENABLE KEYS */;

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theme` (
  `TE_ID` varchar(7) NOT NULL,
  `AK_THEME` varchar(30) NOT NULL,
  PRIMARY KEY (`TE_ID`),
  KEY `AK_THEME` (`AK_THEME`),
  CONSTRAINT `theme_ibfk_1` FOREIGN KEY (`AK_THEME`) REFERENCES `artwork` (`AK_THEME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme`
--

/*!40000 ALTER TABLE `theme` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_TE_ID` BEFORE INSERT ON `theme` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(7);
    INSERT INTO TE_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('TE', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.TE_ID = NEW_ID;
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
  `TDE_SELLER` varchar(100) NOT NULL,
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_TDE_ID` BEFORE INSERT ON `trade` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(8);
    INSERT INTO TDE_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('TDE', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.TDE_ID = NEW_ID;
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
  `AK_ID` varchar(7) NOT NULL,
  `COL_ID` varchar(8) NOT NULL,
  `TDED_PRICE` int NOT NULL,
  `TDED_REMARK` text,
  PRIMARY KEY (`TDED_ID`),
  KEY `TDE_ID` (`TDE_ID`),
  KEY `AK_ID` (`AK_ID`),
  KEY `COL_ID` (`COL_ID`),
  CONSTRAINT `tradedetail_ibfk_1` FOREIGN KEY (`TDE_ID`) REFERENCES `trade` (`TDE_ID`),
  CONSTRAINT `tradedetail_ibfk_2` FOREIGN KEY (`AK_ID`) REFERENCES `artwork` (`AK_ID`),
  CONSTRAINT `tradedetail_ibfk_3` FOREIGN KEY (`COL_ID`) REFERENCES `collection` (`COL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tradedetail`
--

/*!40000 ALTER TABLE `tradedetail` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BEFORE_INSERT_TDED_ID` BEFORE INSERT ON `tradedetail` FOR EACH ROW BEGIN

    DECLARE NEW_ID VARCHAR(9);
    INSERT INTO TDED_SEQUENCE VALUES (NULL);
    SET NEW_ID = CONCAT('TDED', LPAD(LAST_INSERT_ID(), 5, '0'));
    SET NEW.TDED_ID = NEW_ID;
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

-- Dump completed on 2024-09-27  2:36:15
