-- прогнать скрипт по базе , чтобы работала выгрузка движений

CREATE VIEW [dbo].[v_cheque_pay_type]
AS
SELECT        dbo.LOT_MOVEMENT.ID_LOT_MOVEMENT, dbo.CHEQUE.PAY_TYPE_NAME, 
                         CASE WHEN dbo.cheque.pay_type_name = 'Оплата наличными' THEN 21 WHEN dbo.CHEQUE.PAY_TYPE_NAME = 'Оплата платежной картой' THEN 22 END AS TableName
FROM            dbo.CHEQUE_ITEM LEFT OUTER JOIN
                         dbo.CHEQUE ON dbo.CHEQUE_ITEM.ID_CHEQUE_GLOBAL = dbo.CHEQUE.ID_CHEQUE_GLOBAL RIGHT OUTER JOIN
                         dbo.LOT_MOVEMENT ON dbo.CHEQUE_ITEM.ID_CHEQUE_ITEM_GLOBAL = dbo.LOT_MOVEMENT.ID_DOCUMENT_ITEM
WHERE        (dbo.LOT_MOVEMENT.CODE_OP = 'CHEQUE') AND (dbo.LOT_MOVEMENT.DATE_OP BETWEEN GETDATE() - 60 AND GETDATE())