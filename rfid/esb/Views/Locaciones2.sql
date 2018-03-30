
CREATE VIEW [esb].[Locaciones2] AS 
SELECT
	 [externalId]
	,[id]
	,'C' AS [operacion]
    ,'INTEGRADO' AS estado
	,0 AS [sincronizacionesEnCola]
	,[name]
	,[address]
	,[type]
	,[directorio_salidas]
	,fecha_ultimo_pull AS [fechaUltimoCambioEnOrigen]
	,fecha_ultimo_pull AS [fechaUltimaExtraccion]
    ,fecha_ultimo_pull AS [fechaUltimoCargue]
	,fecha_ultimo_push AS [fechaUltimaIntegracion]
    ,fecha_ultimo_pull AS [fechaCreacion]
	,fecha_ultimo_push AS [fechaModificacion]
FROM [RFID3].[esb].[Locaciones] a
