
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [esb].[_ProductosIntegracionError]
	@mid BIGINT, 
	@syncCodigo INT,
    @syncMensaje VARCHAR(1024),
    @syncException VARCHAR(256),
    @numeroMaximoReintentos INT
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @t table(  
    [mid] bigint NOT NULL,
    [externalId] [varchar](50) NOT NULL,
    [fecha_ultimo_push] DATETIME NOT NULL); 

    BEGIN TRY
        BEGIN TRANSACTION

        ---------------------------------------------------------------------------------------------------------------
		UPDATE t
		SET
			t.estado_cambio = 'ERROR',
			t.fecha_ultimo_push = SYSDATETIME(),
			t.sync_codigo = COALESCE(@syncCodigo,-999),
			t.sync_mensaje = COALESCE(CAST(@syncMensaje AS VARCHAR(1024)),''),
            t.sync_exception = COALESCE(CAST(@syncException AS VARCHAR(256)),'')
		OUTPUT INSERTED.mid,INSERTED.externalId,INSERTED.fecha_ultimo_push
		INTO @t(mid,externalId,fecha_ultimo_push)
		FROM msg.Productos t
		WHERE
			t.mid = @mid

        INSERT INTO msg.Productos
            (tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,
            sync_codigo,sync_mensaje,sync_exception,
            externalId,id,
            companyPrefix,name,reference,ean,color,codigoColor,talla,tipoProducto,coleccion,grupoProducto,subGrupoProducto,fabricante,temporada,referencia,modelo,genero)
        SELECT
            t.tipo_cambio,
            CASE 
            WHEN @numeroMaximoReintentos = t.intentos THEN 'DESCARTADO'
            WHEN @syncCodigo = 404 THEN 'PENDIENTE' 
            ELSE 'REINTENTO' END AS estado_cambio,
            t.intentos + 1,
            t.fecha_ultimo_push AS fecha_ultimo_pull,
            NULL AS fecha_ultimo_push,
            0 AS sync_codigo,
            '' AS sync_mensaje,
            '' AS sync_exception,
            t.externalId,
            t.id,
            
            t.companyPrefix,
            t.name,
            t.reference,
            t.ean,
            t.color,
            t.codigoColor,
            t.talla,
            t.tipoProducto,
            t.coleccion,
            t.grupoProducto,
            t.subGrupoProducto,
            t.fabricante,
            t.temporada,
            t.referencia,
            t.modelo,
            t.genero            
        FROM msg.Productos t
		WHERE
			t.mid = @mid

		UPDATE t
		SET 
			t.fecha_ultimo_push = a.fecha_ultimo_push,
			t.sincronizado = CAST(0 AS BIT)
		FROM esb.Productos t
		INNER JOIN @t a ON
			t.externalId = a.externalId

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
        
        SELECT @ErrorMessage = ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        
        ROLLBACK TRANSACTION
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END



