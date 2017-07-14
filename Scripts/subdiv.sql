 -- .subdiv
 select 1111 as OrgId,
 id_contractor as SupplierCode,
 name as SubdivName,
 aDDRESS as SubdivAddress 
  from contractor
 where id_contractor in (

 select id_contractor from CONTRACTOR_2_CONTRACTOR_GROUP
 where id_contractor_group in (select id_contractor_group from contractor_group
 where name = 'Аптеки') )
