-- Populate Nulls in PropertyAddress 

/*
CREATE TEMPORARY TABLE PropAdd3
SELECT ParcelID, PropertyAddress
FROM Nashhousing
WHERE PropertyAddress <> ''
*/

/*
UPDATE Nashhousing a
JOIN PropAdd3 b
ON a.ParcelID = b.ParcelID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = ''
*/

-- Breaking out PropertyAddress into individual columns (Address, City) using SUBSTRING
/*
SELECT PropertyAddress, SUBSTRING(PropertyAddress,LOCATE(',', PropertyAddress)+2,(LENGTH(PropertyAddress)-LOCATE(',', PropertyAddress)+2)) AS City
FROM Nashhousing
*/

/*
ALTER TABLE Nashhousing
ADD City Text
*/

/*
UPDATE Nashhousing
SET City = SUBSTRING(PropertyAddress,LOCATE(',', PropertyAddress)+2,(LENGTH(PropertyAddress)-LOCATE(',', PropertyAddress)+2))
*/

/*
UPDATE Nashhousing
SET PropertyAddress = SUBSTRING(PropertyAddress,1,LOCATE(',',PropertyAddress)-1)
*/

-- Breaking out OwnerAddress into individual columns (Address, City, State) using SUBSTRING_INDEX

/*
SELECT TRIM(substring_index(OwnerAddress,',',1)) AS OwnerAddress1,
TRIM(LEFT(substring_index(OwnerAddress,',',-2),(LENGTH(substring_index(OwnerAddress,',',-2))-4))) AS City,
TRIM(substring_index(OwnerAddress,',',-1)) AS State
FROM Nashhousing
*/

/*
ALTER TABLE Nashhousing
ADD COLUMN OwnerCity text,
ADD COLUMN OwnerState text;


UPDATE Nashhousing
SET OwnerCity = TRIM(LEFT(substring_index(OwnerAddress,',',-2),(LENGTH(substring_index(OwnerAddress,',',-2))-4))),
OwnerState = TRIM(substring_index(OwnerAddress,',',-1));


UPDATE Nashhousing
SET OwnerAddress = TRIM(substring_index(OwnerAddress,',',1));
*/

-- Standardise SoldAsVacant column

/*
UPDATE Nashhousing
SET SoldAsVacant = REPLACE(SoldASVacant,'No','N')

UPDATE Nashhousing
SET SoldAsVacant = REPLACE(SoldASVacant,'Yes','Y')
*/

-- Remove Duplicate Rows - unable to run UPDATE statements with CTEs on MySQL so had to go for Temp Tables

/*
CREATE TEMPORARY TABLE Dups
SELECT *, 
	ROW_NUMBER() OVER (
    PARTITION BY UniqueID, ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference, OwnerName
    ORDER BY UniqueID ) row_num
FROM nashhousing
ORDER BY ParcelID
*/

/*
ALTER TABLE Nashhousing
ADD COLUMN row_num int
*/

/*
UPDATE Nashhousing a
JOIN Dups b
ON a.UniqueID = b.UniqueID
SET a.row_num = b.row_num
*/

/*
DELETE FROM nashhousing
WHERE 'row_number' <> '1'
*/