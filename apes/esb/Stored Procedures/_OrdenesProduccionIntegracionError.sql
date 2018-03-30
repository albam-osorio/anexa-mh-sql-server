
CREATE PROCEDURE [esb].[_OrdenesProduccionIntegracionError]
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
    [fecha_ultimo_pull] DATETIME NOT NULL); 

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
		FROM msg.OrdenesProduccion t
		WHERE
			t.mid = @mid

        ---------------------------------------------------------------------------------------------------------------
        ;WITH
        cte_00 AS
        (
            SELECT
                t.tipo_cambio,
                CASE 
                WHEN @numeroMaximoReintentos = t.intentos THEN 'DESCARTADO'
                WHEN @syncCodigo = 404 THEN 'PENDIENTE' 
                ELSE 'REINTENTO' END AS estado_cambio,
                t.intentos + 1 AS intentos,
                t.fecha_ultimo_push AS fecha_ultimo_pull,
                NULL AS fecha_ultimo_push,
                0 AS sync_codigo,
                '' AS sync_mensaje,
                '' AS sync_exception,
                t.externalId,
                t.id,

                t.supplier,
                t.arrivalDate
            FROM msg.OrdenesProduccion t
		    WHERE
			    t.mid = @mid      
        )
        MERGE msg.OrdenesProduccion AS t
        USING cte_00 AS s ON
            0 = 1
        WHEN NOT MATCHED BY TARGET THEN
            INSERT
            (
            tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,
            externalId,id,supplier,arrivalDate
            )
            VALUES
            (
            tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,
            externalId,id,supplier,arrivalDate
            )
        OUTPUT INSERTED.externalId,INSERTED.mid,INSERTED.fecha_ultimo_pull
        INTO @t(externalId,mid,fecha_ultimo_pull);

        ---------------------------------------------------------------------------------------------------------------
        INSERT INTO msg.OrdenesProduccion_Lineas
            (mid,sku,match_sku,amount)
        SELECT
            b.mid,a.sku,a.match_sku,a.amount
        FROM msg.OrdenesProduccion_Lineas a
        INNER JOIN @t b ON
            1 = 1
        WHERE
            a.mid = @mid

        ---------------------------------------------------------------------------------------------------------------
		UPDATE t
		SET 
			t.fecha_ultimo_push = a.fecha_ultimo_pull,
			t.sincronizado = CAST(0 AS BIT)
		FROM esb.OrdenesProduccion t
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







