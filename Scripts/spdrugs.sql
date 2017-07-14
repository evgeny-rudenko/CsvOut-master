 -- .spdrugs .spdrugsall

select 
 1111 as OrgId,
 id_goods as DrugCode,
 name as DrugName,
 id_producer as ProducerCode,
 EAN = (Select top 1 CODE from BAR_CODE where bar_code.id_goods = goods.id_goods and date_deleted is null)
 from goods
where id_goods in (

select id_goods from lot 
where id_lot_global in ( 
select id_lot_global from lot_movement
 where date_op between getdate()-1 and getdate())

)