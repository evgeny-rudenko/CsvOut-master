 -- .spdrugs .spdrugsall

select 
 1111 as OrgId,
 id_goods as DrugCode,
 name as DrugName,
 id_producer as ProducerCode,
 EAN = (Select top 1 CODE from BAR_CODE where bar_code.id_goods = goods.id_goods and date_deleted is null)
 from goods