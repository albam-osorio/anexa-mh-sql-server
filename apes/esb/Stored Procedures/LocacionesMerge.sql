
CREATE PROCEDURE [esb].[LocacionesMerge]
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;

    --------------------------------------------------------------------------------------------------------------------
    DECLARE @ESTADO_CAMBIO_PENDIENTE VARCHAR(50) = 'PENDIENTE'
    DECLARE @ESTADO_CAMBIO_ERROR VARCHAR(50) = 'ERROR'
	
    DECLARE @t table(
    [externalId] [varchar](50) NOT NULL,
    [id] [varchar](50) NOT NULL,
    [action] NVARCHAR(10) NOT NULL); 

    DECLARE @m table(
	[externalId] [varchar](50) NOT NULL,
	[mid] INT NOT NULL); 

    BEGIN TRY
        BEGIN TRANSACTION

        ---------------------------------------------------------------------------------------------------------------
        -- Identificación de registros pendientes por sincronizar
        ---------------------------------------------------------------------------------------------------------------
        BEGIN
			IF OBJECT_ID('tempdb..#source') IS NOT NULL BEGIN
				DROP TABLE #source
			END

            ;WITH
            cte_00 AS(
				SELECT
                     a.externalId

                    ,a.name
                    ,a.[address]
                    ,a.[type]

                    ,GETDATE() AS fecha_ultimo_pull
				FROM stage.Locaciones a
            ),
            cte_dup AS(
				SELECT
                     a.externalId
				FROM cte_00 a
                GROUP BY
                    a.externalId
                HAVING COUNT(1) > 1
            ),
            cte_01 AS
            (
			    SELECT
                     a.*

                    ,CAST(CASE WHEN b.externalId IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS sincronizacion_pendiente

                    ,CAST(CASE WHEN z.externalId IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS dup
			    FROM cte_00 a
                LEFT OUTER JOIN esb.Locaciones b ON
                    b.externalId = a.externalId
			    AND b.sincronizado = 0
                LEFT OUTER JOIN cte_dup z ON
                    z.externalId = a.externalId
            )
            SELECT
                a.*

                ,CAST(
                CASE 
                WHEN a.dup = 1 THEN 0
                ELSE 1 END AS BIT) AS se_puede_sincronizar
            INTO #source
            FROM cte_01 a

            UPDATE a
            SET a.se_puede_sincronizar = 0
            FROM #source a
            INNER JOIN esb.Locaciones b ON
                b.externalId = a.externalId
            WHERE
                a.se_puede_sincronizar = 1
            AND a.sincronizacion_pendiente = 1
            AND NOT
			    (
                    a.name = b.name
                AND a.[address] = b.[address]
                AND a.[type] = b.[type]
                )
        END

        ---------------------------------------------------------------------------------------------------------------
        -- Actualización esb.
        ---------------------------------------------------------------------------------------------------------------
		BEGIN
            ;WITH
            cte_00 AS
            (
                SELECT
                    a.*
                FROM #source a
                WHERE
                    a.se_puede_sincronizar = 1
            )
            MERGE esb.Locaciones AS t
            USING cte_00 AS s ON
                s.externalId = t.externalId
            WHEN MATCHED AND NOT 
                (
                    t.name = s.name
                AND t.[address] = s.[address]
                AND t.[type] = s.[type]
                ) THEN
                UPDATE SET
                     t.name = s.name
                    ,t.[address] = s.[address]
                    ,t.[type] = s.[type]

                    ,t.fecha_ultimo_pull = s.fecha_ultimo_pull
				    ,t.sincronizado = CAST(0 AS BIT)
            WHEN NOT MATCHED BY TARGET THEN 
                INSERT (externalId,id,fecha_ultimo_pull,sincronizado    ,name,[address],[type])
                VALUES (externalId,'',fecha_ultimo_pull,CAST(0 AS BIT)  ,name,[address],[type])
            OUTPUT INSERTED.externalId,INSERTED.id,$action
            INTO @t(externalId,id,[action])
            ;
		END

        ---------------------------------------------------------------------------------------------------------------
        -- Inserción en msg
        ---------------------------------------------------------------------------------------------------------------
        DECLARE @REGISTROS_SINCRONIZADOS INT
        DECLARE @REGISTROS_NO_SINCRONIZABLES INT
        
        SELECT 
            @REGISTROS_SINCRONIZADOS = COUNT(1) 
        FROM @t

        SELECT 
            @REGISTROS_NO_SINCRONIZABLES = COUNT(1) 
        FROM #source s
        WHERE 
            s.se_puede_sincronizar = 0

        IF @REGISTROS_SINCRONIZADOS > 0 OR @REGISTROS_NO_SINCRONIZABLES > 0 BEGIN
            ---------------------------------------------------------------------------------------------------------------
            -- Se generan los nuevos mensajes de registros sincronizados
            -- Se generan los nuevos mensajes de registros con problemas
            ---------------------------------------------------------------------------------------------------------------
            BEGIN
                IF OBJECT_ID('tempdb..#msg') IS NOT NULL BEGIN
                    DROP TABLE #msg
                END

			    ;WITH
                cte_00 AS
			    (
				    SELECT
                        CAST(
                            CASE
                            WHEN COALESCE(t.[action],'') = 'INSERT' THEN 'C'
                            WHEN COALESCE(t.[action],'') = 'UPDATE' THEN 'U'
                            ELSE 'X' END AS VARCHAR(50))  AS tipo_cambio
                        ,@ESTADO_CAMBIO_PENDIENTE AS estado_cambio

                        ,0 AS intentos
					    ,s.fecha_ultimo_pull
					    ,CAST(NULL AS DATETIME) AS fecha_ultimo_push

                        ,s.externalId
                        ,t.id

					    ,s.name
					    ,s.[address]
					    ,s.[type]

                        ,s.sincronizacion_pendiente
                        ,s.dup
                    FROM #source s
				    INNER JOIN @t t ON
					    t.externalId = s.externalId
                ),
                cte_01 AS
			    (
				    SELECT
                         CAST('X' AS VARCHAR(50))  AS tipo_cambio
                        ,@ESTADO_CAMBIO_ERROR AS estado_cambio

                        ,0 AS intentos
                        ,s.fecha_ultimo_pull
                        ,CAST(NULL AS DATETIME) AS fecha_ultimo_push

                        ,s.externalId
                        ,COALESCE(t.id,'') AS id

					    ,s.name
					    ,s.[address]
					    ,s.[type]

                        ,s.sincronizacion_pendiente
                        ,s.dup
                    FROM #source s
				    LEFT OUTER JOIN esb.Locaciones t ON
					    t.externalId = s.externalId
                    WHERE
                        s.se_puede_sincronizar = 0
                ),
                cte_02 AS
                (
                    SELECT * FROM cte_00
                    UNION
                    SELECT * FROM cte_01
                ),
                cte_03 AS
                (
                    SELECT
                         a.*
                    	,CASE 
                         WHEN a.dup = 1                         THEN -20
                         WHEN a.sincronizacion_pendiente = 1    THEN -1
                         ELSE 0 END AS sync_codigo
                    	,CASE 
                         WHEN a.dup = 1                         THEN 'LA LOCACION, ESTA DUPLICADA.'
                         WHEN a.sincronizacion_pendiente = 1    THEN 'LA LOCACION, TIENE PENDIENTE UNA SINCRONIZACION'
                         ELSE '' END AS sync_mensaje
                        ,'' AS sync_exception
                    FROM cte_02 a
                )
                SELECT
                     s.tipo_cambio
                    ,s.estado_cambio
		
                    ,s.intentos
                    ,s.fecha_ultimo_pull
                    ,s.fecha_ultimo_push
                    ,s.sync_codigo
                    ,s.sync_mensaje
                    ,s.sync_exception

                    ,s.externalId
                    ,s.id

					,s.name
					,s.[address]
					,s.[type]
                INTO #msg
                FROM cte_03 s
            END

            ---------------------------------------------------------------------------------------------------------------
            -- PRODUCTOS
            ---------------------------------------------------------------------------------------------------------------
            BEGIN
                ;WITH
                cte_00 AS
                (
                    SELECT
                          a.*
						,CASE 
						WHEN a.tipo_cambio = b.tipo_cambio 
						AND a.estado_cambio = b.estado_cambio 
						AND a.sync_codigo = b.sync_codigo
						AND a.tipo_cambio = 'X'
						AND a.estado_cambio IN ('ERROR') THEN 1

						WHEN a.estado_cambio IN ('DESCARTADO') THEN 1
						ELSE 0 END AS descartar
                        ,ROW_NUMBER() OVER(PARTITION BY a.externalId ORDER BY a.mid DESC) AS orden
                    FROM msg.Locaciones a
                    INNER JOIN #msg b ON
                        b.externalId = a.externalId
                )
                DELETE a
                FROM #msg a
                INNER JOIN cte_00 b ON
                    b.externalId = a.externalId
                WHERE
                    b.orden = 1
				AND b.descartar = 1 
            END

            ---------------------------------------------------------------------------------------------------------------
            -- Se utiliza el MERGE forzando siempre un INSERT solo para obtener el IDENTITY de cada nuevo registro.
            -- OUTPUT INSERTED.mid, no esta disponible en la instruccion INSERT
            ---------------------------------------------------------------------------------------------------------------
            BEGIN
                MERGE msg.Locaciones AS t
                USING #msg AS s ON
                    0 = 1
                WHEN NOT MATCHED BY TARGET THEN
                    INSERT
                    (tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,externalId,id,name,[address],[type])
                    VALUES
                    (tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,externalId,id,name,[address],[type])
                OUTPUT INSERTED.externalId,INSERTED.mid
                INTO @m(externalId,mid);
            END
        END

        BEGIN
        ---------------------------------------------------------------------------------------------------------------
            DECLARE @fecha_ultimo_pull DATETIME

            SELECT
                @fecha_ultimo_pull = MAX(t.fecha_ultimo_pull)
            FROM #source t
        
            UPDATE a
			SET a.fecha_ultimo_pull = COALESCE(@fecha_ultimo_pull,SYSDATETIME())
            FROM esb.Integraciones a
            WHERE
                a.codigo = 'LOCACIONES'
        END
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        
        ROLLBACK TRANSACTION
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

