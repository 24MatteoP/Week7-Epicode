show databases;
use W7D4;
show tables;

#1. Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
#La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata.

describe dimproduct; #Tabella dove troviamo il nome del prodotto
describe dimproductsubcategory; #Tabella dove troviamo la Sottocategoria
describe dimproductcategory; #Tabella dove troviamo la Categoria

create view Product 
as (
select dp.EnglishProductName as ProductName, dps.EnglishProductSubcategoryName as SubCategoryName, dpc.EnglishProductCategoryName as CategoryName
from dimproduct as dp
inner join dimproductsubcategory as dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
inner join dimproductcategory as dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
);

select *
from Product;



#2. Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
#La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione.

describe dimreseller; #Tabella dove troviamo il Nome del Reseller
describe dimgeography; #Tabella dove troviamo il Nome della Città e della Regione

create view Reseller 
as (
select dr.ResellerName, dg.City, dg.EnglishCountryRegionName as RegionName
from dimreseller as dr
inner join dimgeography as dg on dr.GeographyKey = dg.GeographyKey
order by RegionName ASC
);

select *
from Reseller;



#3. Crea una vista denominata Sales che deve restituire: 
#la data dellʼordine,il codice documento, la riga di corpo del documento, la quantità venduta, lʼimporto totale, il profitto.

describe factresellersales; #OrderDate, OrderQuantity, SalesAmount(ImportoTotale), Profit(SalesAmount - TotalProductCost), SalesOrderNumber (CodiceDocumento), SalesOrderLineNumber (RigaDocumento)

create view Sales 
as (
select OrderDate, SalesOrderNumber as DocumentCod, SalesOrderLineNumber as DocumentLine, OrderQuantity, SalesAmount, SalesAmount - TotalProductCost as Profit
from factresellersales
order by Profit DESC
);

select *
from Sales;




