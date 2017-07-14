
 --.data
 select 
  1111 as OrgId,
  dbo.formatdatetime('yyyy-mm-dd',date_op) as CurrentDate ,
  SubCode = (select id_contractor from store where store.id_store =  lot.id_store ) ,
  lot.id_goods as DrugCode,
  ProducerCode = (select id_producer from goods where lot.id_goods = goods.id_goods ),
  EAN = (Select top 1 CODE from BAR_CODE where bar_code.id_goods = lot.id_goods and date_deleted is null),
  lot_movement.Quantity_add + lot_movement.quantity_sub as Quantity,
  price_sup as CenaOptNDS,
  price_sal as CenaRozNDS,  
  Internal_Barcode as BarCode,  
  --id_lot_movement,
  
  CASE
  when CODE_OP = 'INVOICE'     Then 10
  When CODE_OP = 'INVOICE_OUT' Then 23
  when CODE_OP = 'CHEQUE'      Then (select top 1 tablename from v_cheque_pay_type where v_cheque_pay_type.id_lot_movement = lot_movement.id_lot_movement )
  END as TableName ,
  
  case
  when CODE_OP = 'INVOICE' Then (select top 1  Doc_NUM from all_document where  LOT_MOVEMENT.ID_DOCUMENT = ALL_DOCUMENT.id_document_global)
  else ''
  end as NumberDoc,
  
  case
  when CODE_OP = 'INVOICE' Then (select top 1 dbo.formatdatetime('yyyy-mm-dd',Doc_Date)  from all_document where  LOT_MOVEMENT.ID_DOCUMENT = ALL_DOCUMENT.id_document_global)
  else ''
  end as NumberNakl,

  case
  when CODE_OP = 'INVOICE' Then (select id_contractor_from from  all_document where  LOT_MOVEMENT.ID_DOCUMENT = ALL_DOCUMENT.id_document_global)
  else ''
  end as SupplierCode , 
  Seriya = (select top 1 series_number from series where series.id_series = lot.id_series),
  SrokGodn = (select top 1 best_before from series where series.id_series = lot.id_series),
  lot.vat_sup as NDSsupplier , 
  lot.vat_sal as NDSrozn,
  lot.PRICE_SUP - lot.PVAT_SUP as CenaOptBezNDS,
  lot.price_sal - lot.pvat_sal as CenaRozBezNDS,
  SumCenaOptBezNDS = lot_movement.sum_sup-lot_movement.svat_sup ,
  SumCenaOptNDS = lot_movement.sum_sup,
  SumCenaRozBezNDS = (lot.PRICE_sal - lot.PVAT_sal)*( lot_movement.Quantity_add + lot_movement.quantity_sub ) ,
  SumCenaRozNDS =  (lot.PRICE_sal)*( lot_movement.Quantity_add + lot_movement.quantity_sub ) ,
  SumDiscount =  (select discount_acc from  all_document where  LOT_MOVEMENT.ID_DOCUMENT = ALL_DOCUMENT.id_document_global)
  from lot_movement , lot -- , all_document

 where date_op between getdate()-1 and getdate()
and lot_movement.id_lot_global = lot.id_lot_global
and lot_movement.code_op in ('INVOICE', 'CHEQUE', 'INVOICE_OUT')



