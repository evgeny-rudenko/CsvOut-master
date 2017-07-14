 -- .spproducer --- тут страна нужна или нет
 select 
 1111 as OrgId,
 id_producer as ProducerCode ,
 name as ProducerName
 from producer
 where id_producer in (select id_producer from goods 
 where id_goods in (

select id_goods from lot 
where id_lot_global in ( 
select id_lot_global from lot_movement
 where date_op between getdate()-1 and getdate())

))
