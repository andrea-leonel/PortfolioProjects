-- Cleaning Data with SQL queries

-- Standardising SaleDate
/*
UPDATE Nashhousing
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y')
*/

-- Populate Nulls in PropertyAddress 


CREATE TEMPORARY TABLE PropAdd3
SELECT UniqueID, ParcelID, PropertyAddress
FROM Nashhousing
WHERE PropertyAddress <> ''

/*
UPDATE Nashhousing a
JOIN PropAdd3 b
ON a.ParcelID = b.ParcelID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = ''
*/