--cleaning data in sql queries

select *
from PortfolioProject..NashvilleHousing


--standardize date format

select Saledate, CONVERT(date,Saledate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set Saledate = CONVERT(date,Saledate)

alter table NashvilleHousing
add SalesConverted Date;

update NashvilleHousing
set SalesConverted = CONVERT(date,Saledate)

--populate property address data
 
 select * 
 from PortfolioProject..NashvilleHousing
 --where PropertyAddress is null
 order by parcelID

  select a.parcelID ,b.parcelID ,a.PropertyAddress ,b.PropertyAddress ,ISNULL(a.PropertyAddress ,b.PropertyAddress )
 from PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b
 on a.parcelID = b.parcelID
 and a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null

 update a
 set PropertyAddress  = ISNULL(a.PropertyAddress ,b.PropertyAddress )
 from PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b
 on a.parcelID = b.parcelID
 and a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null

 --breaking out address into individual columns (Address,City ,State)

 select PropertyAddress
 from PortfolioProject..NashvilleHousing

 select 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as address
 from PortfolioProject..NashvilleHousing

 alter table PortfolioProject..NashvilleHousing
 add PropertySplitAddress nvarchar(255);

 update NashvilleHousing
 set PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress))

 alter table NashvilleHousing
 add PropertySplitCity nvarchar(255);

 update NashvilleHousing
 set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

  select *
 from PortfolioProject..NashvilleHousing

 Select 
 parsename(replace (owneraddress,',','.'),3),
 parsename(replace (owneraddress,',','.'),2),
 parsename(replace (owneraddress,',','.'),1)
 from PortfolioProject..NashvilleHousing

 alter table PortfolioProject..NashvilleHousing
 add PropertySplitowneraddress nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set PropertySplitowneraddress= parsename(replace (owneraddress,',','.'),3)

  alter table PortfolioProject..NashvilleHousing
 add PropertySplitownerCity nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set PropertySplitownerCity= parsename(replace (owneraddress,',','.'),2)

  alter table PortfolioProject..NashvilleHousing
 add PropertySplitownerstate nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set PropertySplitownerstate= parsename(replace (owneraddress,',','.'),1)

 select *
 from PortfolioProject..NashvilleHousing

 --change Y and N as yes and No in "sold as vacant field

 select SoldAsVacant,
 case when SoldAsVacant='Y' then 'yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  End
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
set SoldAsVacant= case when SoldAsVacant='Y' then 'yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  End

--remove Duplicates

 With Rownum_CTE as (
 select *,
     ROW_NUMBER() over(partition by ParcelID,
	                                PropertyAddress,
									SalePrice,
									Saledate,
									LegalReference
									order by 
									UniqueID
									)row_num
 from PortfolioProject..NashvilleHousing
 --order by ParcelID
 )
 Select * from 
 Rownum_CTE
 where row_num>1
 order by propertyAddress

 --Delete unused columns

 Select * 
 from PortfolioProject..NashvilleHousing

 alter table PortfolioProject..NashvilleHousing
 Drop column OwnerAddress,TaxDistrict,PropertyAddress,Saledate
