-- .rest

 select 
  1111 as OrgId,
 dbo.formatdatetime('yyyy-mm-dd',getdate()) as CurrentDate ,
 SubCode = (select id_contractor from store where store.id_store =  lot.id_store ) ,
 id_goods as Drug_Code ,
 ProducerCode = (select id_producer from goods where lot.id_goods = goods.id_goods ),
 EAN = (Select top 1 CODE from BAR_CODE where bar_code.id_goods = lot.id_goods and date_deleted is null),
 quantity_rem as Quantity ,
 price_sup as CenaOptNDS,
 price_sal as CenaRozNDS,  
 Internal_Barcode as BarCode  
 from lot
 where quantity_rem > 0 
