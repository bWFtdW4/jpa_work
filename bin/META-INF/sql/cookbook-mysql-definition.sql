-- MySQL structure script for schema "cookbook"
-- best import using client command "source <path to this file>"

SET CHARACTER SET utf8mb4;
DROP DATABASE IF EXISTS cookbook;
CREATE DATABASE cookbook CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE cookbook;

-- define tables, indices, etc.
CREATE TABLE BaseEntity (
	identity BIGINT NOT NULL AUTO_INCREMENT,
	discriminator ENUM("Document", "Person", "Recipe", "IngredientType", "Ingredient") NOT NULL,
	version INTEGER NOT NULL DEFAULT 1,
	created BIGINT NOT NULL,
	modified BIGINT NOT NULL,
	PRIMARY KEY (identity),
	KEY (discriminator)
);

CREATE TABLE Document (
	documentIdentity BIGINT NOT NULL,
	hash CHAR(64) NOT NULL,
	type VARCHAR(63) NOT NULL,
	content LONGBLOB NOT NULL,
	PRIMARY KEY (documentIdentity),
	FOREIGN KEY (documentIdentity) REFERENCES BaseEntity (identity) ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE KEY (hash)
);

CREATE TABLE Person (
	personIdentity BIGINT NOT NULL,
	avatarReference BIGINT NOT NULL,
	email CHAR(128) NOT NULL,
	passwordHash CHAR(64) NOT NULL,
	groupAlias ENUM("USER", "ADMIN") NOT NULL,
	title VARCHAR(15) NULL,
	surname VARCHAR(31) NOT NULL,
	forename VARCHAR(31) NULL,
	postcode VARCHAR(15) NULL,
	street VARCHAR(63) NULL,
	city VARCHAR(63) NULL,
	country VARCHAR(63) NULL,
	PRIMARY KEY (personIdentity),
	FOREIGN KEY (personIdentity) REFERENCES BaseEntity (identity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (avatarReference) REFERENCES Document (documentIdentity) ON DELETE RESTRICT ON UPDATE CASCADE,
	UNIQUE KEY (email)
);

CREATE TABLE Recipe (
	recipeIdentity BIGINT NOT NULL,
	avatarReference BIGINT NOT NULL,
	ownerReference BIGINT NOT NULL,
	category ENUM ("MAIN_COURSE", "APPETIZER", "SNACK", "DESSERT", "BREAKFAST", "BUFFET", "BARBEQUE", "ADOLESCENT", "INFANT") NOT NULL,
	title CHAR(128) NOT NULL,
	description VARCHAR(4094) NULL,
	instruction VARCHAR(4094) NULL,
	PRIMARY KEY (recipeIdentity),
	FOREIGN KEY (recipeIdentity) REFERENCES BaseEntity (identity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (avatarReference) REFERENCES Document (documentIdentity) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (ownerReference) REFERENCES Person (personIdentity) ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE KEY (title)
);

CREATE TABLE IngredientType (
	ingredientTypeIdentity BIGINT NOT NULL,
	avatarReference BIGINT NOT NULL,
	alias CHAR(128) NOT NULL,
	pescatarian BOOLEAN NOT NULL,
	lactoOvoVegetarian BOOLEAN NOT NULL,
	lactoVegetarian BOOLEAN NOT NULL,
	vegan BOOLEAN NOT NULL,
	description VARCHAR(4094) NULL,
	PRIMARY KEY (ingredientTypeIdentity),
	FOREIGN KEY (ingredientTypeIdentity) REFERENCES BaseEntity (identity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (avatarReference) REFERENCES Document (documentIdentity) ON DELETE RESTRICT ON UPDATE CASCADE,
	UNIQUE KEY (alias)
);

CREATE TABLE Ingredient (
	ingredientIdentity BIGINT NOT NULL,
	recipeReference BIGINT NOT NULL,
	ingredientTypeReference BIGINT NOT NULL,
	amount FLOAT NOT NULL,
	unit ENUM ("LITRE", "GRAM", "TEASPOON", "TABLESPOON", "PINCH", "CUP", "CAN", "TUBE", "BUSHEL", "PIECE") NOT NULL,
	PRIMARY KEY (ingredientIdentity),
	FOREIGN KEY (ingredientIdentity) REFERENCES BaseEntity (identity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ingredientTypeReference) REFERENCES IngredientType (ingredientTypeIdentity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (recipeReference) REFERENCES Recipe (recipeIdentity) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PhoneAssociation (
	personReference BIGINT NOT NULL,
	phone CHAR(16) NOT NULL,
	PRIMARY KEY (personReference, phone),
	FOREIGN KEY (personReference) REFERENCES Person (personIdentity) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RecipeIllustrationAssociation (
	recipeReference BIGINT NOT NULL,
	documentReference BIGINT NOT NULL,
	PRIMARY KEY (recipeReference, documentReference),
	FOREIGN KEY (recipeReference) REFERENCES Recipe (recipeIdentity) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (documentReference) REFERENCES Document (documentIdentity) ON DELETE CASCADE ON UPDATE CASCADE
);
