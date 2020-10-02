/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE IF NOT EXISTS `recetas` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci */;
USE `recetas`;

CREATE TABLE IF NOT EXISTS `authors` (
  `authorId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci DEFAULT NULL,
  `image` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`authorId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` (`authorId`, `name`, `image`) VALUES
	(1, ' M. Carmen', 'carmenMii.jpg'),
	(2, 'Vero', 'VeroMii.jpg'),
	(3, 'Pablitor', 'pabloMii.jpg');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `difficulties` (
  `difficultId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` tinytext CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`difficultId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `difficulties` DISABLE KEYS */;
INSERT INTO `difficulties` (`difficultId`, `name`) VALUES
	(1, 'Baja'),
	(2, 'Media'),
	(3, 'Alta');
/*!40000 ALTER TABLE `difficulties` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `images` (
  `imageId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`imageId`),
  KEY `FK_Fotos_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Images_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` (`imageId`, `recipeId`, `name`) VALUES
	(8, 13, 'image1.jpg');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `ingredients` (
  `ingredientId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `isProduct` bit(1) DEFAULT NULL,
  `isChecked` char(1) COLLATE latin1_spanish_ci DEFAULT NULL,
  PRIMARY KEY (`ingredientId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` (`ingredientId`, `name`, `isProduct`, `isChecked`) VALUES
	(1, 'Carne picada', b'1', '0'),
	(2, 'Cebolla', b'1', '1'),
	(3, 'Ajo', b'1', '1'),
	(4, 'Perejil', b'1', '1'),
	(5, 'Nuez moscada', b'1', '1'),
	(6, 'Pan rallado', b'1', '1'),
	(7, 'Harina fina', b'1', '1'),
	(8, 'Huevos', b'1', '1'),
	(9, 'Lentejas', b'1', '1'),
	(10, 'Pimiento', b'1', '1'),
	(11, 'Pimienta', b'1', '1'),
	(12, 'Comino molido', b'1', '1'),
	(13, 'Laurel', b'1', '1'),
	(14, 'Cilantro', b'1', '1'),
	(15, 'Aceite de girasol', b'1', '1'),
	(16, 'Pimentón', b'1', '1'),
	(17, 'Chorizo', b'1', '1'),
	(18, 'Pan', b'1', '1'),
	(19, 'Harina', b'1', '1'),
	(20, 'Vino', b'1', '0'),
	(28, 'Galletas', b'1', '1'),
	(29, 'Mortadela', b'1', '1'),
	(30, 'Pan rallado', b'1', '1'),
	(31, 'Leche desnatada', b'1', '0'),
	(32, 'Leche semi', b'1', '0'),
	(33, 'Leche de vaca', b'1', '1'),
	(34, 'Pescado', b'1', '0'),
	(35, 'Calabaza', b'1', '1'),
	(36, 'Aceite de oliva', b'1', '0');
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `notes` (
  `noteId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `note` varchar(500) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`noteId`),
  KEY `FK_Notas_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Notes_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` (`noteId`, `recipeId`, `note`) VALUES
	(25, 13, 'Salsita: A la otra mitad de las cebollas se le añade harina, 1 vaso de vino y sal.'),
	(26, 13, 'Se pasa todo y se sirve con la carne.');
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `recipeingredients` (
  `ingredientId` int(11) NOT NULL,
  `recipeId` int(11) NOT NULL,
  `number` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `ingredientNote` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`ingredientId`,`recipeId`),
  KEY `FK_IngredientesReceta_Receta_idx` (`recipeId`),
  CONSTRAINT `FK_RecipeIngredients_Ingredients` FOREIGN KEY (`ingredientId`) REFERENCES `ingredients` (`ingredientid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RecipeIngredients_Recipe` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `recipeingredients` DISABLE KEYS */;
INSERT INTO `recipeingredients` (`ingredientId`, `recipeId`, `number`, `ingredientNote`) VALUES
	(1, 1, '', NULL),
	(1, 13, '1 kg', ''),
	(2, 1, NULL, NULL),
	(2, 13, '2', ''),
	(3, 1, NULL, NULL),
	(3, 13, '2 dientes', ''),
	(4, 1, NULL, NULL),
	(5, 1, NULL, NULL),
	(6, 1, NULL, NULL),
	(7, 1, NULL, NULL),
	(8, 1, '2', NULL),
	(8, 13, '2', ''),
	(18, 13, '100 g', 'Mojado en leche');
/*!40000 ALTER TABLE `recipeingredients` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `recipes` (
  `recipeId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `authorId` int(11) NOT NULL DEFAULT '1',
  `date` date NOT NULL,
  `views` int(10) unsigned NOT NULL DEFAULT '0',
  `preparationMinutes` tinyint(3) unsigned DEFAULT NULL,
  `difficultyId` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`recipeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `recipes` DISABLE KEYS */;
INSERT INTO `recipes` (`recipeId`, `name`, `authorId`, `date`, `views`, `preparationMinutes`, `difficultyId`) VALUES
	(1, 'Albóndigas', 1, '2020-05-01', 2, 30, 1),
	(13, 'Albondigón', 1, '2020-05-17', 3, 35, 2);
/*!40000 ALTER TABLE `recipes` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `recipetags` (
  `tagId` int(11) NOT NULL,
  `recipeId` int(11) NOT NULL,
  PRIMARY KEY (`tagId`,`recipeId`),
  KEY `FK_EtiquetasReceta_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_RecipeTags_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RecipeTags_Tags` FOREIGN KEY (`tagId`) REFERENCES `tags` (`tagid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `recipetags` DISABLE KEYS */;
INSERT INTO `recipetags` (`tagId`, `recipeId`) VALUES
	(1, 1),
	(1, 13),
	(2, 13);
/*!40000 ALTER TABLE `recipetags` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `steps` (
  `stepId` int(11) NOT NULL AUTO_INCREMENT,
  `recipeId` int(11) NOT NULL,
  `step` varchar(1000) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`stepId`),
  KEY `FK_Pasos_Recetas_idx` (`recipeId`),
  CONSTRAINT `FK_Steps_Recipes` FOREIGN KEY (`recipeId`) REFERENCES `recipes` (`recipeid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `steps` DISABLE KEYS */;
INSERT INTO `steps` (`stepId`, `recipeId`, `step`) VALUES
	(1, 1, 'En el vaso de la batidora se pone el ajo, la cebolla, el perejil y los huevos.'),
	(2, 1, 'Se pasa bien y se le añade a la carne picada.'),
	(3, 1, 'Se mezcla todo muy bien y se le añade la nuez moscada y la sal. '),
	(4, 1, 'A continuación se le echa el pan rallado y se amasa hasta que todos los ingredientes queden bien ligados. Luego se cogen porciones y se les da forma. '),
	(5, 1, 'Se emborriza cada albóndiga en harina fina y se fríen.'),
	(55, 13, 'Se refríen las cebollas y se reserva la mitad.'),
	(56, 13, 'Se echa a la carne picada, la mitad de las cebollas, los ajos picados, los huevos batidos y el pan mojado en leche.'),
	(57, 13, 'Se le añade sal y nuez moscada y se mezcla todo.'),
	(58, 13, 'Se hace un albondigón con esta masa y se pone en una bandeja de horno con un poco de aceite.');
/*!40000 ALTER TABLE `steps` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `tags` (
  `tagId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  PRIMARY KEY (`tagId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` (`tagId`, `name`) VALUES
	(1, 'Horno'),
	(2, 'Postres'),
	(3, 'Platos de cuchara');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;

DELIMITER //
CREATE PROCEDURE `AuthorData`(
	IN `pAuthorId` INT


)
BEGIN	
	SELECT A.authorId, A.name, A.image, COUNT(R.recipeId) AS number
	FROM authors A
		LEFT JOIN recipes R ON A.authorId = R.authorId	
	WHERE pAuthorID IS NULL OR A.authorId = pAuthorId
	GROUP BY A.authorId, A.name, A.image
	ORDER BY A.name;	
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `AuthorSave`(
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
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `ElementSave`(
	IN `pTable` CHAR(1),
	IN `pRecipeId` INT,
	IN `pText0` VARCHAR(100),
	IN `pText1` VARCHAR(8000),
	IN `pText2` VARCHAR(8000)



)
BEGIN
    -- Insert into tables depending provided initial:

    -- E: recipetags:				pTagIds ->					tagId
    -- F: images:				    pImageNames ->             	name
    -- I: recipeingredients:		pIngredientIds ->          	ingredientId
    --                          	pIngredientsNumber ->    	number
    --                          	pIngredientNotes ->        	ingredientNote
    -- N: notes:                	pNotes ->                  	note
    -- P: pasos:                	pSteps ->          			step
       
    DECLARE nElements INT DEFAULT 0; -- Separator number in string
    DECLARE counter INT DEFAULT 1;
    DECLARE vElement0 VARCHAR(1000) DEFAULT NULL;    -- Store column content from each loop
    DECLARE vElement1 VARCHAR(1000) DEFAULT NULL;
    DECLARE vElement2 VARCHAR(1000) DEFAULT NULL;
    
    -- Count separators. pText1 is always filled 
    SELECT LENGTH(pText1) - LENGTH(REPLACE(pText1, '¬' ,'')) INTO nElements;
    
    IF (pText1 IS NOT NULL) THEN
        WHILE counter <= nElements DO 
        
            SELECT 
				REPLACE(SUBSTRING(SUBSTRING_INDEX(pText0, '¬', counter), LENGTH(SUBSTRING_INDEX(pText0, '¬', counter - 1)) + 1), '¬', ''),
               	REPLACE(SUBSTRING(SUBSTRING_INDEX(pText1, '¬', counter), LENGTH(SUBSTRING_INDEX(pText1, '¬', counter - 1)) + 1), '¬', ''),
               	REPLACE(SUBSTRING(SUBSTRING_INDEX(pText2, '¬', counter), LENGTH(SUBSTRING_INDEX(pText2, '¬', counter - 1)) + 1), '¬', '')
            INTO vElement0, vElement1, vElement2; 
                                     
            IF (LENGTH(vElement1) > 0) THEN
                -- Insert into table depending pTable value
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
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `IngredientDelete`(
	IN `pIngredientId` INT
)
BEGIN
	DELETE FROM ingredients WHERE ingredientId = pIngredientId;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `IngredientSave`(
	IN `pIngredientId` INT,
	IN `pName` VARCHAR(100)


)
BEGIN
	IF pIngredientId IS NOT NULL THEN
		UPDATE ingredients SET name = pName WHERE ingredientId = pIngredientId;
	ELSE
		INSERT INTO ingredients (name) VALUES (pName);
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `IngredientsData`()
BEGIN
	SELECT ingredientId, name
   	FROM ingredients
   	ORDER BY name;	
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `RecipeData`()
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
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `RecipeDelete`(
	IN `pRecipeId` INT
)
BEGIN
	DELETE FROM recipes WHERE recipeId = pRecipeId;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `RecipeDetail`(
	IN `pRecipeId` INT
)
BEGIN
	-- Update recipe views
	UPDATE recipes SET views = views + 1 WHERE recipeId = pRecipeId;
	-- Recipe data
    SELECT R.recipeId, R.name, A.name AS authorName, A.image AS authorImage, R.date, R.views, R.preparationMinutes, D.name AS difficulty
    FROM recipes R 
    	INNER JOIN authors A ON R.authorId = A.authorId
    	INNER JOIN difficulties D ON D.difficultId = R.difficultyId
	 WHERE recipeId = pRecipeId;
	-- Ingredient list
    SELECT I.ingredientId, I.name, RI.number, RI.ingredientNote
    FROM ingredients I
		INNER JOIN recipeingredients RI ON RI.ingredientId = I.ingredientId
    WHERE RI.recipeId = pRecipeId
    ORDER BY I.name;
    -- Tag list
    SELECT T.tagId, T.name
    FROM tags T
		INNER JOIN recipetags RT ON RT.tagId = T.tagId
    WHERE RT.recipeId = pRecipeId
    ORDER BY T.name;
    -- Recipe steps
    SELECT step
    FROM steps
    WHERE recipeId = pRecipeId
    ORDER BY stepId;
    -- Notes
    SELECT note
    FROM notes
    WHERE recipeId = pRecipeId;    
    -- Recipe images
    SELECT name
    FROM images
    WHERE recipeId = pRecipeId;  
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `RecipeElementsDelete`(
	IN `pRecipeId` INT
)
BEGIN
	DELETE FROM recipetags WHERE recipeId = pRecipeId;
	DELETE FROM images WHERE recipeId = pRecipeId;
	DELETE FROM recipeingredients WHERE recipeId = pRecipeId;
	DELETE FROM notes WHERE recipeId = pRecipeId;
	DELETE FROM steps WHERE recipeId = pRecipeId;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `RecipeSave`(
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
	    -- Insert new recipe name and get new id
	    INSERT INTO recipes (name, authorId, DATE, difficultyId, preparationMinutes) VALUES (pRecipeName, pAuthorId, CURDATE(), pDifficultyId, pPreparationMinutes);
	    SELECT LAST_INSERT_ID() INTO vRecipeId;		
	END IF;
    
    -- Insert into tables depending provided initial:

    -- E: recipetags:				pTagIds ->					tagId
    -- F: images:				    pImageNames ->             	name
    -- I: recipeingredients:		pIngredientIds ->     		ingredientId
    --                          	pIngredientsNumber ->    	number
    --                          	pIngredientNotes ->        	ingredientNote
    -- N: notes:                	pNotes ->                  	note
    -- P: pasos:                	pSteps ->          			step
    
    -- Call ElementSave with each table value string (separator is ¬) 
    CALL ElementSave('E', vRecipeId, '', pTagIds, '');
    CALL ElementSave('F', vRecipeId, '', pImageNames, '');
    CALL ElementSave('I', vRecipeId, pIngredientIds, pIngredientsNumber, pIngredientNotes);
    CALL ElementSave('N', vRecipeId, '', pNotes, '');
    CALL ElementSave('P', vRecipeId, '', pSteps, '');
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `TagDelete`(
	IN `pTagId` INT
)
BEGIN
	DELETE FROM tags WHERE tagId = pTagId;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `TagSave`(
	IN `pTagId` INT,
	IN `pName` VARCHAR(100)


)
BEGIN
	IF pTagId IS NOT NULL THEN
		UPDATE tags SET name = pName WHERE tagId = pTagId;
	ELSE
		INSERT INTO tags (name) VALUES (pName);
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `TagsData`()
BEGIN
	SELECT T.name, COUNT(R.recipeId) AS number 
   	FROM tags T
		LEFT JOIN recipetags RT ON RT.tagId = T.tagId
      	LEFT JOIN recipes R ON R.recipeId = RT.recipeId
	GROUP BY T.name
   	ORDER BY T.name;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
