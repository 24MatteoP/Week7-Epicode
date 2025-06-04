use AdventureWorksDW;
show tables;
describe dimproduct;

#1. Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia?show databases;
SELECT ProductKey, COUNT(*) AS Ripetizioni #In Output avremo la ProductKey e il conteggio dei record che si ripetono
FROM dimproduct 
GROUP BY ProductKey #Dovra raggruppare tutti i record in base alla ProductKey, se ci sono ripetizioni
HAVING COUNT(*) > 1; #Ci mostra in Output i risultati solo se ci sono record con lo stesso ProductKey
#Se non avremo nulla in Output significa che ProductKey è una chiave Primaria


#2. Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK
describe factresellersales; #SalesOrderNumber SalesOrderLineNumber

select SalesOrderNumber, SalesOrderLineNumber, count(*) AS ripetizioni 
from factresellersales
group by SalesOrderNumber, SalesOrderLineNumber #Dovra' raggruppare i record che abbiano sia lo stesso SalesOrderNumber e contemporaneamente lo stesso SalesOrderLineNumber
having count(*) > 1; #Ci mostra in Output i risultati solo se ci sono record che si ripetono


#3. Conta il numero transazioni SalesOrderLineNumber realizzate ogni giorno a partire dal 1 Gennaio 2020
select OrderDate, count(SalesOrderNumber) as NumeroOrdini
from factresellersales
where OrderDate >= '2020-01-01' #La condizione è che OrderDate sia maggiore o uguale a 2020-01-01
group by OrderDate; #Dichiariamo di raggruppare il Count in base al dato inserito in OrderDate, senza invece avremo una sola riga con il totale complessivo


#4. Calcola il fatturato totale FactResellerSales.SalesAmount, la quantità totale venduta FactResellerSales.OrderQuantity e il prezzo medio di vendita FactResellerSales.UnitPrice per prodotto DimProduct 
#a partire dal 1 Gennaio 2020.  Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
describe dimproduct;
select *
from dimproduct;

select frs.ProductKey,dp.EnglishProductName, sum(SalesAmount) as FatturatoTotale, sum(OrderQuantity) as QuantitaTotaleVenduta, avg(UnitPrice) as PrezzoMedioVendita
from factresellersales as frs
inner join dimproduct as dp on frs.ProductKey = dp.ProductKey
where  OrderDate >= '2020-01-01'
group by ProductKey;

#5. Calcola il fatturato totale FactResellerSales.SalesAmount e la quantità totale venduta FactResellerSales.OrderQuantity per Categoria prodotto DimProductCategory
#Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. 
describe factresellersales;
describe dimproductcategory;

select dpc.ProductCategoryKey, dpc.EnglishProductCategoryName ,sum(SalesAmount) as FatturatoTotale, sum(OrderQuantity) as QuantitaTotaleVenduta
from factresellersales as frs
inner JOIN dimproduct AS dp ON frs.ProductKey = dp.ProductKey
inner JOIN dimproductsubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
inner JOIN dimproductcategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
group by dpc.ProductCategoryKey;


#6. Calcola il fatturato totale per area città DimGeography.City realizzato a partire dal 1 Gennaio 2020. Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K.
describe dimgeography;
describe factresellersales;

select dg.City, sum(SalesAmount) as Fatturato
from factresellersales as frs
inner join dimgeography as dg on frs.SalesTerritoryKey = dg.SalesTerritoryKey
where frs.OrderDate >= '2020-01-01'
group by dg.City
having sum(frs.SalesAmount) > 60000
order by Fatturato desc;

