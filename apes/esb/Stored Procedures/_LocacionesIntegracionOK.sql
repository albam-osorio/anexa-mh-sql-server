-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [esb].[_LocacionesIntegracionOK]
	@mid BIGINT,
	@id VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @t table(  
    [mid] bigint NOT NULL,
    [externalId] [varchar](50) NOT NULL,
    [id] [varchar](50) NOT NULL,
    [fecha_ultimo_push] DATETIME NOT NULL); 

    BEGIN TRY
        BEGIN TRANSACTION

        ---------------------------------------------------------------------------------------------------------------
		UPDATE t
		SET
			t.estado_cambio = 'INTEGRADO',
			t.intentos = t.intentos + 1,
			t.fecha_ultimo_push = GETDATE(),
			t.id = CASE WHEN t.tipo_cambio = 'C' THEN @id ELSE t.id END,
			t.sync_codigo = 0,
			t.sync_mensaje = '',
            t.sync_exception = ''
		OUTPUT INSERTED.mid,INSERTED.externalId,INSERTED.id,INSERTED.fecha_ultimo_push
		INTO @t(mid,externalId,id,fecha_ultimo_push)
		FROM msg.Locaciones t
		WHERE
			t.mid = @mid

        UPDATE t
        SET 
            t.id = CASE WHEN t.id = '' THEN a.id ELSE t.id END,
            t.fecha_ultimo_push = a.fecha_ultimo_push,
		    t.sincronizado = CAST(1 AS BIT)
        FROM esb.Locaciones t
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



