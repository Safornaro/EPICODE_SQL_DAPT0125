-- Utilizzo il DB
use AdventureWorksDW;

-- Esporo la tabella dimproduct 
select *
from dimproduct;

-- Esploro la tabella dimproductsubcategory
select *
from dimproductsubcategory;	

-- Esploro la tabella dimproductcategory
select *
from dimproductcategory;	

-- Effettuo un inner join per aggiungere la sottocateogoria per ogni prodotto 

select 
productkey
, englishproductname
, productsubcategoryalternatekey
, englishproductsubcategoryname
, dimproductsubcategory.productsubcategorykey
, productcategorykey
from dimproduct inner join dimproductsubcategory
on dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey;

/* Effettuo un test effettuando un cross join per controllare di aver preso tutte le righe
select *
from dimproduct cross join dimproductsubcategory
on dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey;
*/

-- Effettuo un inner join per aggiungere anche la categoria, per farlo utilizzo una subquery

select 
productkey
, englishproductname
, dimproduct_dimproductsubcatgory.productsubcategorykey
, englishproductsubcategoryname
, dimproduct_dimproductsubcatgory.productcategorykey
, englishproductcategoryname
from dimproductcategory inner join 
(select productkey, englishproductname, productsubcategoryalternatekey, englishproductsubcategoryname, dimproductsubcategory.productsubcategorykey, productcategorykey
from dimproduct inner join dimproductsubcategory
on dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey) as dimproduct_dimproductsubcatgory
on  dimproductcategory.productcategorykey = dimproduct_dimproductsubcatgory.productcategorykey;

-- Per avere l'elenco dei soli prodotti venduti effettuo un inner join tra dimproduct e factresellersales

select 
dimproduct.productkey
, englishproductname
, salesordernumber
, salesorderlinenumber
, orderdate
, orderquantity
, unitprice
, salesamount
from dimproduct inner join factresellersales
on dimproduct.productkey = factresellersales.productkey;

-- esponi l'elenco dei non venduti solo per i prodotti finiti

/* prodotti finiti
select productkey, englishproductname, finishedgoodsflag
from dimproduct
where finishedgoodsflag=1;
*/

-- una volta scritta la query effettuo un left outer join tra la tabella dei prodotti finiti e quella delle vendite filtrando quelli dove non c'è un ordine di vendita

select finished_product.productkey, englishproductname, finishedgoodsflag
from (select dimproduct.productkey, englishproductname, finishedgoodsflag
from dimproduct
where finishedgoodsflag=1) as finished_product left outer join factresellersales
on finished_product.productkey = factresellersales.productkey
where salesordernumber is null;


-- Esponi lʼelenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)

select 
dimproduct.productkey
, englishproductname
, salesordernumber
, salesorderlinenumber
, orderdate
, orderquantity
, unitprice
, salesamount
from dimproduct inner join factresellersales
on dimproduct.productkey = factresellersales.productkey;

-- Esponi lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.

select *
from (select 
productkey
, englishproductname
, dimproduct_dimproductsubcatgory.productsubcategorykey
, englishproductsubcategoryname
, dimproduct_dimproductsubcatgory.productcategorykey
, englishproductcategoryname
from dimproductcategory inner join 
(select productkey, englishproductname, productsubcategoryalternatekey, englishproductsubcategoryname, dimproductsubcategory.productsubcategorykey, productcategorykey
from dimproduct inner join dimproductsubcategory
on dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey) as dimproduct_dimproductsubcatgory
on  dimproductcategory.productcategorykey = dimproduct_dimproductsubcatgory.productcategorykey) as table1 inner join factresellersales
on table1.productkey = factresellersales.productkey;

-- Esplora la tabella dimreseller

select *
from dimreseller;

-- Esponi in output lʼelenco dei reseller indicando, per ciascun reseller, anche la sua area geografica

select 
r.resellerkey 
, r.resellername as Nome_Rivenditore
, geo.geographykey
, geo.city as City
, geo.englishcountryregionname as Region
, geo.salesterritorykey 
from dimreseller as r inner join dimgeography as geo
on r.geographykey = geo.geographykey;

/* Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
Il result set deve anche indicare il nome del prodotto, 
il nome della categoria del prodotto  il nome del reseller e lʼarea geografica. */

select 
factresellersales.salesordernumber as Ordine
, factresellersales.salesorderlinenumber as Linea_Ordine
, factresellersales.orderdate as Data_Ordine
, factresellersales.unitprice as Prezzo
, factresellersales.orderquantity as Quantità
, factresellersales.totalproductcost as Totale_Prodotti
, dimproduct.englishproductname as Nome_Prodotto
, dimproduct.productsubcategorykey as Product_Subcategory_Key
, dimproductsubcategory.englishproductsubcategoryname as Sottocategoria
, dimproductsubcategory.productcategorykey as Product_Category_Key
, dimproductcategory.englishproductcategoryname as Categoria
, dimreseller.resellername as Nome_Reseller
, factresellersales.resellerkey as Reseller_Key
, dimreseller.geographykey as Key_Area
, dimgeography.city as Città
, dimgeography.englishcountryregionname as Regione
from factresellersales 
inner join dimproduct 
on factresellersales.productkey = dimproduct.productkey
inner join dimproductsubcategory
on dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey
inner join dimproductcategory
on  dimproductcategory.productcategorykey = dimproductsubcategory.productcategorykey
inner join dimreseller
on dimreseller.resellerkey = factresellersales.resellerkey
inner join dimgeography
on dimreseller.geographykey = dimgeography.geographykey;







