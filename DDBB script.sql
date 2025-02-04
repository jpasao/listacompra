-- MariaDB dump 10.19  Distrib 10.11.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: recetas
-- ------------------------------------------------------
-- Server version	10.11.6-MariaDB-0+deb12u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `authorId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `image` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`authorId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historic`
--

DROP TABLE IF EXISTS `historic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `itemId` int(11) NOT NULL,
  `itemName` text NOT NULL,
  `operationId` smallint(6) NOT NULL COMMENT '1->create, 2->update, 3->check, 4->uncheck, 5->delete',
  `createdAt` datetime DEFAULT current_timestamp(),
  `firebaseSent` tinyint(4) DEFAULT NULL,
  `remoteAddr` varchar(45) DEFAULT NULL,
  `originalData` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `images` (
  `imageId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`imageId`),
  KEY `FK_Fotos_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Images_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredients` (
  `ingredientId` int(11) NOT NULL AUTO_INCREMENT,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `isProduct` bit(1) DEFAULT NULL,
  `isChecked` char(1) DEFAULT '0',
  `quantity` tinyint(4) DEFAULT 1,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ingredientId`)
) ENGINE=InnoDB AUTO_INCREMENT=1006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `message` varchar(200) NOT NULL,
  `datetime` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mealingredients`
--

DROP TABLE IF EXISTS `mealingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mealingredients` (
  `mealId` int(11) NOT NULL,
  `ingredientId` int(11) NOT NULL,
  PRIMARY KEY (`mealId`,`ingredientId`),
  KEY `mealingredients_FK` (`ingredientId`),
  CONSTRAINT `mealingredients_FK` FOREIGN KEY (`ingredientId`) REFERENCES `ingredients` (`ingredientId`) ON DELETE CASCADE,
  CONSTRAINT `mealingredients_FK_1` FOREIGN KEY (`mealId`) REFERENCES `meals` (`mealId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meals`
--

DROP TABLE IF EXISTS `meals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meals` (
  `mealId` int(11) NOT NULL AUTO_INCREMENT,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `isLunch` tinyint(4) NOT NULL DEFAULT 1,
  `isChecked` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`mealId`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
ALTER DATABASE `recetas` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER check_products
AFTER UPDATE ON meals
FOR EACH ROW 
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE selected_ingredient_id INTEGER;
	DECLARE selected_ingredient_is_checked CHAR(1);	
	DECLARE actual_quantity INTEGER;
	DECLARE new_quantity INTEGER;
	DECLARE ingredient_list CURSOR FOR SELECT ingredientId FROM mealingredients WHERE mealId = NEW.mealId;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;	
	
	IF OLD.isChecked <> NEW.isChecked THEN	
		OPEN ingredient_list;
			ilLoop: LOOP
				FETCH ingredient_list INTO selected_ingredient_id;
	            IF finished = 1 THEN 
	            	LEAVE ilLoop;
	            END IF;
	           	
	           	SELECT ingredients.isChecked, quantity INTO selected_ingredient_is_checked, actual_quantity 
	           	FROM ingredients 
	           	WHERE ingredientId = selected_ingredient_id;
	           
				IF NEW.isChecked = 0 THEN
					IF selected_ingredient_is_checked = '1' THEN           		
		           		UPDATE ingredients
		           		SET isChecked = '0'
		           		WHERE ingredientId = selected_ingredient_id;
		           	ELSE
		           		SET new_quantity = actual_quantity + 1;
		           		UPDATE ingredients 
		           		SET quantity = new_quantity
		           		WHERE ingredientId = selected_ingredient_id;
		           	END IF;
				ELSE
					IF selected_ingredient_is_checked = '0' THEN  
		           		IF actual_quantity = 1 THEN 
			           		UPDATE ingredients
			           		SET isChecked = '1'
			           		WHERE ingredientId = selected_ingredient_id;
		           		ELSE
		           			SET new_quantity = actual_quantity - 1;
			           		UPDATE ingredients 
			           		SET quantity = new_quantity
			           		WHERE ingredientId = selected_ingredient_id;
		           		END IF;		
		           	END IF;			
				END IF;
			END LOOP ilLoop;		
		CLOSE ingredient_list;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `recetas` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `noteId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `note` varchar(500) NOT NULL,
  PRIMARY KEY (`noteId`),
  KEY `FK_Notas_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Notes_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `otherschild`
--

DROP TABLE IF EXISTS `otherschild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otherschild` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `isChecked` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `otherschild_FK` (`parentId`),
  CONSTRAINT `otherschild_FK` FOREIGN KEY (`parentId`) REFERENCES `othersparent` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `othersparent`
--

DROP TABLE IF EXISTS `othersparent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `othersparent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipeingredients`
--

DROP TABLE IF EXISTS `recipeingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipeingredients` (
  `ingredientId` int(11) NOT NULL,
  `recipeId` int(11) NOT NULL,
  `number` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `ingredientNote` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`ingredientId`,`recipeId`),
  KEY `FK_IngredientesReceta_Receta_idx` (`recipeId`),
  CONSTRAINT `FK_RecipeIngredients_Ingredients` FOREIGN KEY (`ingredientId`) REFERENCES `ingredients` (`ingredientId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RecipeIngredients_Recipe` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipes` (
  `recipeId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `authorId` int(11) NOT NULL DEFAULT 1,
  `date` date NOT NULL,
  `views` int(10) unsigned NOT NULL DEFAULT 0,
  `preparationMinutes` tinyint(3) unsigned DEFAULT NULL,
  `difficultyId` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`recipeId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipetags`
--

DROP TABLE IF EXISTS `recipetags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipetags` (
  `tagId` int(11) NOT NULL,
  `recipeId` int(11) NOT NULL,
  PRIMARY KEY (`tagId`,`recipeId`),
  KEY `FK_EtiquetasReceta_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_RecipeTags_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RecipeTags_Tags` FOREIGN KEY (`tagId`) REFERENCES `tags` (`tagid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `steps` (
  `stepId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `step` varchar(1000) NOT NULL,
  PRIMARY KEY (`stepId`),
  KEY `FK_Pasos_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Steps_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `tagId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`tagId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'recetas'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `DeleteOldHistoric` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `DeleteOldHistoric` ON SCHEDULE EVERY 1 DAY STARTS '2025-01-18 00:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO BEGIN
	DELETE
	FROM historic
	WHERE createdAt <= DATE(NOW()) - INTERVAL 30 DAY;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'recetas'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AuthorData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AuthorData`(
	IN `pAuthorId` INT
)
BEGIN	
	SELECT A.authorId AS id, A.name, A.image, COUNT(R.recipeId) AS number
	FROM authors A
		LEFT JOIN recipes R ON A.authorId = R.authorId	
	WHERE pAuthorID IS NULL OR A.authorId = pAuthorId
	GROUP BY A.authorId, A.name, A.image
	ORDER BY A.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AuthorSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AuthorSave`(
	IN `pAuthorId` INT,
	IN `pName` VARCHAR(100),
	IN `pImage` VARCHAR(100)

)
BEGIN
	IF pAuthorId IS NOT NULL THEN
		UPDATE authors SET name = pName, image = pImage WHERE authorId = pAuthorId;
	ELSE
		INSERT INTO authors (name, image) VALUES (pName, pImage);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ElementSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ElementSave`(
	IN `pTable` CHAR(1),
	IN `pRecipeId` INT,
	IN `pText0` VARCHAR(100),
	IN `pText1` VARCHAR(8000),
	IN `pText2` VARCHAR(8000)
)
BEGIN

    -- E: recipetags:				pTagIds ->					tagId
    -- F: images:				    pImageNames ->             	name
    -- I: recipeingredients:		pIngredientIds ->          	ingredientId
    --                          	pIngredientsNumber ->    	number
    --                          	pIngredientNotes ->        	ingredientNote
    -- N: notes:                	pNotes ->                  	note
    -- P: pasos:                	pSteps ->          			step
    
    -- E: recipetags:				pTagIds ->					tagId
    -- F: images:				    pImageNames ->             	name
    -- I: recipeingredients:		pIngredientIds ->          	ingredientId
    --                          	pIngredientsNumber ->    	number
    --                          	pIngredientNotes ->        	ingredientNote
    -- N: notes:                	pNotes ->                  	note
    -- P: pasos:                	pSteps ->          			step

    DECLARE nElements INT DEFAULT 0; 
    DECLARE counter INT DEFAULT 1;
    DECLARE vElement0 VARCHAR(1000) DEFAULT NULL;    
    DECLARE vElement1 VARCHAR(1000) DEFAULT NULL;
    DECLARE vElement2 VARCHAR(1000) DEFAULT NULL;
 
    SELECT LENGTH(pText1) - LENGTH(REPLACE(pText1, '¬' ,'')) INTO nElements;
    
    IF (pText1 IS NOT NULL) THEN
        WHILE counter <= nElements DO 
        
            SELECT 
				REPLACE(SUBSTRING(SUBSTRING_INDEX(pText0, '¬', counter), LENGTH(SUBSTRING_INDEX(pText0, '¬', counter - 1)) + 1), '¬', ''),
               	REPLACE(SUBSTRING(SUBSTRING_INDEX(pText1, '¬', counter), LENGTH(SUBSTRING_INDEX(pText1, '¬', counter - 1)) + 1), '¬', ''),
               	REPLACE(SUBSTRING(SUBSTRING_INDEX(pText2, '¬', counter), LENGTH(SUBSTRING_INDEX(pText2, '¬', counter - 1)) + 1), '¬', '')
            INTO vElement0, vElement1, vElement2; 
                                     
            IF (LENGTH(vElement1) > 0) THEN
                CASE pTable
                    WHEN 'E' THEN
                        INSERT INTO recipetags (tagId, recipeId)
                        VALUES (vElement1, pRecipeId);
                    WHEN 'F' THEN
                        INSERT INTO images (recipeId, name)
                        VALUES (pRecipeId, vElement1);
                    WHEN 'I' THEN
                        INSERT INTO recipeingredients (ingredientId, recipeId, number, ingredientNote)
                        VALUES (vElement0, pRecipeId, vElement1, vElement2);
                    WHEN 'N' THEN
                        INSERT INTO notes (recipeId, note)
                        VALUES (pRecipeId, vElement1);
                    WHEN 'P' THEN
                        INSERT INTO steps (recipeId, step)
                        VALUES (pRecipeId, vElement1);
                END CASE;
            END IF;
            
            SET counter = counter + 1; 
        
        END WHILE;  
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `HistoricData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `HistoricData`(
	IN pUserId INT,
	IN pDays INT
)
BEGIN
	DECLARE vUserId INT;
	SELECT authorId INTO vUserId FROM authors WHERE authorId = pUserId;
	IF (vUserId = 6 OR vUserId IS NULL) THEN 
		SET vUserId = -1;
	END IF;

	SELECT id, userId, userName, itemId, itemName, operationId, createdAt, firebaseSent, remoteAddr, originalData
	FROM historic
	WHERE 1=1
		AND (vUserId = -1 OR userId = pUserId)
		AND (pDays = -1 OR createdAt >= DATE(NOW()) - INTERVAL pDays DAY)
	ORDER BY id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `HistoricSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `HistoricSave`(
	IN pHistoricId INT,
	IN pUserId INT,
	IN pItemId INT,
	IN pItemName TEXT,
	IN pOperationId SMALLINT,
	IN pFirebaseSent TINYINT(4),
	IN pRemoteAddr VARCHAR(45),
	IN pOriginalData TEXT
)
BEGIN
	DECLARE vUserName VARCHAR(100);
	SELECT name INTO vUserName FROM authors WHERE authorId = pUserId;
	IF (vUserName IS NULL) THEN
		SET vUserName = 'Desconocido';
	END IF;
	
	IF (pHistoricId = 0) THEN
		INSERT INTO historic (userId, userName, itemId, itemName, operationId, firebaseSent, remoteAddr, originalData)
		VALUES (pUserId, vUserName, pItemId, pItemName, pOperationId, pFirebaseSent, pRemoteAddr, pOriginalData);
	ELSE 
		UPDATE historic SET firebaseSent = 1 WHERE id = pHistoricId;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IngredientDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IngredientDelete`(
	IN `pIngredientId` INT
)
BEGIN
	DELETE FROM ingredients WHERE ingredientId = pIngredientId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IngredientSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IngredientSave`(
	IN `pIngredientId` INT,
	IN `pName` VARCHAR(100)
)
BEGIN
	IF pIngredientId IS NOT NULL THEN
		UPDATE ingredients SET name = pName WHERE ingredientId = pIngredientId;
	ELSE
		INSERT INTO ingredients (name) VALUES (pName);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IngredientsData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IngredientsData`()
BEGIN
	SELECT ingredientId, name
   	FROM ingredients
   	ORDER BY name;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MealData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `MealData`()
BEGIN
	SELECT M.mealId, M.name, M.isLunch, M.isChecked 
	FROM meals M		
	ORDER BY isLunch DESC, isChecked, name;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MealIngredientsData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `MealIngredientsData`(
	IN pMeal INT
)
BEGIN
	SELECT M.mealId, M.name, M.isLunch, I.ingredientId, I.name, M.isChecked  
	FROM meals M
		INNER JOIN mealingredients MI ON MI.mealId = M.mealId 
		INNER JOIN ingredients I ON MI.ingredientId = I.ingredientId 
	WHERE pMeal IS NULL OR M.mealId = pMeal
	ORDER BY I.name;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `OthersData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `OthersData`()
BEGIN
	SELECT 
		CASE WHEN C.id IS NULL THEN P.id ELSE C.id END AS id, 
		P.Id AS parentId, 
		P.name AS parentName, 
		C.name, 
		C.isChecked
	FROM othersparent P
		LEFT JOIN otherschild C ON P.id = C.parentId
	ORDER BY C.parentId, C.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `OthersSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `OthersSave`(
	IN pId INT,
	IN pParentId INT,
	IN pName VARCHAR(100),
	IN pIsChecked TINYINT
)
BEGIN
	IF pParentId > 0 THEN
		IF pId > 0 THEN
			UPDATE otherschild 
			SET parentId = pParentId, name = pName, isChecked = pIsChecked 
			WHERE id = pId;
		ELSE
			INSERT INTO otherschild (parentId, name, isChecked)
			VALUES (pParentId, pName, pIsChecked);
		END IF;		
	ELSE
		IF pId > 0 THEN
			UPDATE othersparent  
			SET name = pName 
			WHERE id = pId;		
		ELSE
			INSERT INTO othersparent (name)
			VALUES (pName);		
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecipeData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecipeData`()
BEGIN
	SELECT R.recipeId, R.name, R.authorId, R.date, R.views, COUNT(I.ingredientId) AS ingredientsNumber
	FROM recipes R 	
		INNER JOIN recipeingredients I ON R.recipeId = I.recipeId		
	GROUP BY R.recipeId, R.name, R.authorId, R.date, R.views
	ORDER BY R.recipeId DESC;
	
	SELECT recipeId, step 
	FROM steps S
	WHERE stepId = 
		(SELECT MAX(stepId) FROM steps WHERE recipeId = S.recipeId)
	ORDER BY s.recipeId DESC;	
	
	CALL AuthorData(NULL);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecipeDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecipeDelete`(
	IN `pRecipeId` INT
)
BEGIN
	DELETE FROM recipes WHERE recipeId = pRecipeId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecipeDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecipeDetail`(
	IN `pRecipeId` INT
)
BEGIN
	-- Update recipe views
	UPDATE recipes SET views = views + 1 WHERE recipeId = pRecipeId;

    SELECT R.recipeId, R.name, A.name AS authorName, A.image AS authorImage, R.date, R.views, R.preparationMinutes, D.name AS difficulty
    FROM recipes R 
    	INNER JOIN authors A ON R.authorId = A.authorId
    	INNER JOIN difficulties D ON D.difficultId = R.difficultyId
	 WHERE recipeId = pRecipeId;
	
    SELECT I.ingredientId, I.name, RI.number, RI.ingredientNote
    FROM ingredients I
		INNER JOIN recipeingredients RI ON RI.ingredientId = I.ingredientId
    WHERE RI.recipeId = pRecipeId
    ORDER BY I.name;
    
    SELECT T.tagId, T.name
    FROM tags T
		INNER JOIN recipetags RT ON RT.tagId = T.tagId
    WHERE RT.recipeId = pRecipeId
    ORDER BY T.name;
    
    SELECT step
    FROM steps
    WHERE recipeId = pRecipeId
    ORDER BY stepId;
    
    SELECT note
    FROM notes
    WHERE recipeId = pRecipeId;    
    
    SELECT name
    FROM images
    WHERE recipeId = pRecipeId;  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecipeElementsDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecipeElementsDelete`(
	IN `pRecipeId` INT
)
BEGIN
	DELETE FROM recipetags WHERE recipeId = pRecipeId;
	DELETE FROM images WHERE recipeId = pRecipeId;
	DELETE FROM recipeingredients WHERE recipeId = pRecipeId;
	DELETE FROM notes WHERE recipeId = pRecipeId;
	DELETE FROM steps WHERE recipeId = pRecipeId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecipeSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecipeSave`(
	IN `pTagIds` VARCHAR(100),
	IN `pImageNames` VARCHAR(600),
	IN `pIngredientIds` VARCHAR(100),
	IN `pIngredientsNumber` VARCHAR(1000),
	IN `pIngredientNotes` VARCHAR(8000),
	IN `pNotes` VARCHAR(8000),
	IN `pSteps` VARCHAR(8000),
	IN `pRecipeName` VARCHAR(200),
	IN `pAuthorId` INT,
	IN `pRecipeId` INT,
	IN `pDifficultyId` TINYINT,
	IN `pPreparationMinutes` TINYINT
)
BEGIN
	DECLARE vRecipeId INT;

	IF pRecipeId > 0 THEN
		SET vRecipeId = pRecipeId;
		UPDATE recipes SET authorId = pAuthorId, name =	pRecipeName, difficultyId = pDifficultyId, preparationMinutes = pPreparationMinutes WHERE recipeId = vRecipeId;
		CALL RecipeElementsDelete(vRecipeId);				
	ELSE 
	    INSERT INTO recipes (name, authorId, DATE, difficultyId, preparationMinutes) VALUES (pRecipeName, pAuthorId, CURDATE(), pDifficultyId, pPreparationMinutes);
	    SELECT LAST_INSERT_ID() INTO vRecipeId;		
	END IF;
    CALL ElementSave('E', vRecipeId, '', pTagIds, '');
    CALL ElementSave('F', vRecipeId, '', pImageNames, '');
    CALL ElementSave('I', vRecipeId, pIngredientIds, pIngredientsNumber, pIngredientNotes);
    CALL ElementSave('N', vRecipeId, '', pNotes, '');
    CALL ElementSave('P', vRecipeId, '', pSteps, '');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TagDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TagDelete`(
	IN `pTagId` INT
)
BEGIN
	DELETE FROM tags WHERE tagId = pTagId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TagSave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TagSave`(
	IN `pTagId` INT,
	IN `pName` VARCHAR(100)
)
BEGIN
	IF pTagId IS NOT NULL THEN
		UPDATE tags SET name = pName WHERE tagId = pTagId;
	ELSE
		INSERT INTO tags (name) VALUES (pName);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TagsData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TagsData`()
BEGIN
	SELECT T.name, COUNT(R.recipeId) AS number 
   	FROM tags T
		LEFT JOIN recipetags RT ON RT.tagId = T.tagId
      	LEFT JOIN recipes R ON R.recipeId = RT.recipeId
	GROUP BY T.name
   	ORDER BY T.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;