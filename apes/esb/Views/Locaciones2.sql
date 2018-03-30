CREATE VIEW [esb].[Locaciones2] AS 
SELECT
	 [externalId]
	,[id]
	,[name]
	,[address]
	,[type]
	,[directorio_salidas]
	,'C' AS [operacion]
	--,[estadoSincronizacion]
	,[sincronizado]
	,0 AS [sincronizacionesEnCola]
	,fecha_ultimo_pull AS [fechaActualizacion]
	,fecha_ultimo_pull AS [fechaUltimoPull]
	,fecha_ultimo_push AS [fechaUltimoPush]
FROM [esb].[Locaciones] a


