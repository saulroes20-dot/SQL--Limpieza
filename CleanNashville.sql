--Limpieza de datos SQL 

SELECT * 
FROM NashvilleHousing;

--Estandarizar formato de datos 

SELECT SalesDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SalesDateConverted DATE;

UPDATE NashvilleHousing
SET SalesDateConverted = CONVERT(Date,SaleDate)


--Agregar datos a la dirección - datos nulos

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN
NashvilleHousing b
	ON a.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;
--Actualizar BBDD 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN
NashvilleHousing b
	ON a.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Dividir texto en columnas (Ciudad, dirección, Estado) 

SELECT PropertyAddress
FROM NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing;