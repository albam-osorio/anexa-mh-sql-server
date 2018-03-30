
CREATE PROCEDURE [esb].[SalidasTiendasMerge]
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

    DECLARE @l table(
	[externalId] [varchar](50) NOT NULL,
    [action] NVARCHAR(10) NOT NULL); 

    DECLARE @m table(
	[externalId] [varchar](50) NOT NULL,
	[mid] INT NOT NULL); 

    BEGIN TRY
        BEGIN TRANSACTION

        ---------------------------------------------------------------------------------------------------------------
        -- Se actualiza el valor de sourceId y destinationId con el valor de los id de locaciones
        -- Para garantizar que no se repita un externalId con diferentes locaciones, se genera un nuevo external id con el original y los id de las locaciones
        ---------------------------------------------------------------------------------------------------------------
		BEGIN
			UPDATE a
			SET  
				 a.sourceId = COALESCE(b.id,'')
				,a.destinationId = COALESCE(c.id,'')
				,a.externalId = a.externalId + '-' + COALESCE(b.externalId,'') + '-' + COALESCE(c.externalId,'')
			FROM stage.SalidasTiendas a
			LEFT OUTER JOIN esb.Locaciones b ON
				b.name = a.BODEGA_ORIGEN
			AND b.id <> ''
			LEFT OUTER JOIN esb.Locaciones c ON
				c.name = a.BODEGA_DESTINO
			AND c.id <> ''
			WHERE
				a.sourceId = a.BODEGA_ORIGEN
			AND a.destinationId = a.BODEGA_DESTINO
		END

        ---------------------------------------------------------------------------------------------------------------
        -- Identificación de registros pendientes por sincronizar
        ---------------------------------------------------------------------------------------------------------------
		BEGIN 
			IF OBJECT_ID('tempdb..#source') IS NOT NULL BEGIN
				DROP TABLE #source
			END

            ;WITH
			cte_00 AS(
				SELECT DISTINCT
                     a.externalId

                    ,a.sourceId
                    ,a.destinationId
                    ,a.expectedShipmentDate
                    ,a.BODEGA_ORIGEN
                    ,a.BODEGA_DESTINO

                    ,GETDATE() AS fecha_ultimo_pull
				FROM stage.SalidasTiendas a
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
				    ,CAST(CASE WHEN c.id IS NOT NULL THEN 1 ELSE 0 END AS BIT ) AS match_sourceId
				    ,CAST(CASE WHEN d.id IS NOT NULL THEN 1 ELSE 0 END AS BIT ) AS match_destinationId
				    ,CAST(1 AS BIT ) AS match_sku

                    ,CAST(CASE WHEN z.externalId IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS dup
                    ,CAST(0 AS BIT ) AS dup_sku
			    FROM cte_00 a
                LEFT OUTER JOIN esb.SalidasTiendas b ON
                    b.externalId = a.externalId
			    AND b.sincronizado = 0
			    LEFT OUTER JOIN esb.Locaciones c ON
				    c.id = a.sourceId
			    AND c.id <> ''
			    LEFT OUTER JOIN esb.Locaciones d ON
				    d.id = a.destinationId
                AND d.id <> ''
                LEFT OUTER JOIN cte_dup z ON
                    z.externalId = a.externalId
            )
            SELECT
                a.*

                ,CAST(
                CASE 
                WHEN a.dup = 1 THEN 0
                WHEN a.match_sourceId = 0 THEN 0 
                WHEN a.match_destinationId = 0 THEN 0
                ELSE 1 END AS BIT) AS se_puede_sincronizar
            INTO #source
            FROM cte_01 a

            UPDATE a
            SET a.se_puede_sincronizar = 0
            FROM #source a
            INNER JOIN esb.SalidasTiendas b ON
                b.externalId = a.externalId
            WHERE
                a.se_puede_sincronizar = 1
            AND a.sincronizacion_pendiente = 1
            AND NOT
			    (
                     a.sourceId  = b.sourceId
                 AND a.destinationId  = b.destinationId
                 AND a.expectedShipmentDate  = b.expectedShipmentDate
                 AND a.BODEGA_ORIGEN  = b.BODEGA_ORIGEN
                 AND a.BODEGA_DESTINO  = b.BODEGA_DESTINO
                )
        END
 
        BEGIN
			IF OBJECT_ID('tempdb..#source_lineas') IS NOT NULL  BEGIN
				DROP TABLE #source_lineas
			END

			;WITH
            cte_00 AS
            (
				SELECT
					 b.externalId
					,b.sku
					,b.amount
				FROM #source a
				INNER JOIN stage.SalidasTiendas b ON
					b.externalId = a.externalId
            ),
			cte_01 AS
			(
	            SELECT
		             a.externalId
		            ,a.sku
	            FROM cte_00 a
	            GROUP BY
		             a.externalId
		            ,a.sku
	            HAVING
		            COUNT(1) > 1
			)
			SELECT
				 a.externalId
				,a.sku
				,a.amount
				,CAST(CASE WHEN b.externalId IS NULL THEN 0 ELSE 1 END AS BIT ) AS match_sku
                ,CAST(CASE WHEN c.externalId IS NOT NULL THEN 1 ELSE 0 END AS BIT ) AS dup_sku
			INTO #source_lineas
			FROM cte_00 a
			LEFT OUTER JOIN esb.Productos b ON
				b.externalId = a.sku
			AND b.id <> ''
            LEFT OUTER JOIN cte_01 c ON
                c.externalId = a.externalId
            AND c.sku = a.sku

			;WITH
			cte_00 AS
			(
				SELECT
					 a.externalId
					,CAST(MIN(CAST(a.match_sku AS INT)) AS BIT) AS match_sku
					,CAST(MAX(CAST(a.dup_sku AS INT)) AS BIT) AS dup_sku
				FROM #source_lineas a
				WHERE
					a.match_sku = 0 OR a.dup_sku = 1
				GROUP BY
					 a.externalId
			)
			UPDATE a
			SET 
                a.se_puede_sincronizar = 0
               ,a.match_sku = b.match_sku
               ,a.dup_sku = b.dup_sku
			FROM #source a
			INNER JOIN cte_00 b ON
				b.externalId = a.externalId

            ;WITH
            cte_00 AS
            (
                SELECT
                    a.externalId
			    FROM #source a
                WHERE
                    a.sincronizacion_pendiente = 1
                AND a.se_puede_sincronizar = 1
            ),
            cte_01 AS
            (
                SELECT
                    b.*
			    FROM cte_00 a
			    INNER JOIN #source_lineas b ON
                    b.externalId = a.externalId
            ),
            cte_02 AS
            (
                SELECT
                    b.*
			    FROM cte_00 a
			    INNER JOIN esb.SalidasTiendas_Lineas b ON
                    b.externalId = a.externalId
            ),
            cte_03 AS
            (
				SELECT DISTINCT
					COALESCE(a.externalId,b.externalId) AS externalId
				FROM cte_01 a
				FULL OUTER JOIN cte_02 b ON
					b.externalId = b.externalId
				AND b.sku = a.sku
                AND b.amount = a.amount
				WHERE
					b.externalId IS NULL OR a.externalId IS NULL
            )
            UPDATE a
            SET a.se_puede_sincronizar = 0
            FROM #source a
            INNER JOIN cte_03 b ON
                b.externalId = a.externalId
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
		    MERGE esb.SalidasTiendas AS t
            USING cte_00 AS s ON
                s.externalId = t.externalId
            WHEN MATCHED AND NOT
			    (
                     t.sourceId  = s.sourceId
                 AND t.destinationId  = s.destinationId
                 AND t.expectedShipmentDate  = s.expectedShipmentDate
                 AND t.BODEGA_ORIGEN  = s.BODEGA_ORIGEN
                 AND t.BODEGA_DESTINO  = s.BODEGA_DESTINO
                ) THEN
                UPDATE SET 
                      t.sourceId  = s.sourceId
                     ,t.destinationId  = s.destinationId
                     ,t.expectedShipmentDate  = s.expectedShipmentDate
                     ,t.BODEGA_ORIGEN  = s.BODEGA_ORIGEN
                     ,t.BODEGA_DESTINO  = s.BODEGA_DESTINO

                     ,t.fecha_ultimo_pull = s.fecha_ultimo_pull
                     ,t.sincronizado = CAST(0 AS BIT)
            WHEN NOT MATCHED BY TARGET THEN 
                INSERT (externalId,id,fecha_ultimo_pull,sincronizado    ,sourceId,destinationId,expectedShipmentDate,BODEGA_ORIGEN,BODEGA_DESTINO)
                VALUES (externalId,'',fecha_ultimo_pull,CAST(0 AS BIT)  ,sourceId,destinationId,expectedShipmentDate,BODEGA_ORIGEN,BODEGA_DESTINO)
            OUTPUT INSERTED.externalId,INSERTED.id,$action
            INTO @t(externalId,id,[action])
            ;

			---------------------------------------------------------------------------------------------------------------
            ;WITH
            cte_00 AS
            (
                SELECT
                    b.*
                FROM #source a
                INNER JOIN #source_lineas b ON
                    b.externalId = a.externalId
                WHERE
                    a.se_puede_sincronizar = 1
            )
            MERGE esb.SalidasTiendas_Lineas AS t
			USING cte_00 AS s ON
				s.externalId = t.externalId
			AND s.sku = t.sku
            WHEN MATCHED AND NOT
				(t.amount = s.amount) THEN
			    UPDATE SET
				    t.amount = s.amount
			WHEN NOT MATCHED BY TARGET THEN
				INSERT (externalId,sku,amount)
				VALUES (externalId,sku,amount)
			WHEN NOT MATCHED BY SOURCE AND 
                EXISTS(
                    SELECT 1 
                    FROM #source a 
                    WHERE 
                        a.externalId = t.externalId 
                    AND a.se_puede_sincronizar = 1) THEN
				DELETE
			OUTPUT COALESCE(INSERTED.externalId,DELETED.externalId) AS externalId,$action
			INTO @l(externalId,[action]);
        END

        BEGIN
			;WITH
			cte_00 AS
			(
				SELECT DISTINCT
					a.externalId,
					COALESCE(b.id,'') AS id
				FROM @l a
				LEFT OUTER JOIN esb.SalidasTiendas b ON
					b.externalId = a.externalId
			)			
			MERGE @t AS t
			USING cte_00 AS s ON
				s.externalId = t.externalId
			WHEN NOT MATCHED BY TARGET THEN
				INSERT (externalId,id,[action])
				VALUES (externalId,id,'UPDATE')
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

                        ,s.sourceId
                        ,s.destinationId
                        ,s.expectedShipmentDate
                        ,s.BODEGA_ORIGEN
                        ,s.BODEGA_DESTINO

                        ,s.sincronizacion_pendiente
                        ,s.match_sourceId
                        ,s.match_destinationId
                        ,s.match_sku
                        ,s.dup
                        ,s.dup_sku
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

                        ,s.sourceId
                        ,s.destinationId
                        ,s.expectedShipmentDate
                        ,s.BODEGA_ORIGEN
                        ,s.BODEGA_DESTINO

                        ,s.sincronizacion_pendiente
                        ,s.match_sourceId
                        ,s.match_destinationId
                        ,s.match_sku
                        ,s.dup
                        ,s.dup_sku
                    FROM #source s
				    LEFT OUTER JOIN esb.SalidasTiendas t ON
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
                         WHEN a.match_sourceId = 0              THEN -10
                         WHEN a.match_destinationId = 0         THEN -11
                         WHEN a.match_sku = 0                   THEN -12
                         WHEN a.dup = 1                         THEN -20
                         WHEN a.dup_sku = 1                     THEN -21
                         WHEN a.sincronizacion_pendiente = 1    THEN -1
                         ELSE 0 END AS sync_codigo
                    	,CASE 
                         WHEN a.match_sourceId = 0              THEN 'EL ORIGEN NO EXISTE O TIENE PENDIENTE UNA SINCRONIZACION'
                         WHEN a.match_destinationId = 0         THEN 'EL DESTINO NO EXISTE O TIENE PENDIENTE UNA SINCRONIZACION'
                         WHEN a.match_sku = 0                   THEN 'UNO O MAS SKU NO EXISTEN O ESTAN PENDIENTES DE SER SINCRONIZADOS'
                         WHEN a.dup = 1                         THEN 'LA SALIDA DE TIENDA, ESTA DUPLICADA.'
                         WHEN a.dup_sku = 1                     THEN 'LA SALIDA DE TIENDA, TIENE UNO O MAS SKU DUPLICADOS'
                         WHEN a.sincronizacion_pendiente = 1    THEN 'LA SALIDA DE TIENDA, TIENE PENDIENTE UNA SINCRONIZACION'
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

                    ,s.sourceId
                    ,s.destinationId
                    ,s.expectedShipmentDate
                    ,s.BODEGA_ORIGEN
                    ,s.BODEGA_DESTINO
                INTO #msg
                FROM cte_03 s
            END

            ---------------------------------------------------------------------------------------------------------------
            -- SALIDAS
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
                    FROM msg.SalidasTiendas a
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
                MERGE msg.SalidasTiendas AS t
                USING #msg AS s ON
                    0 = 1
                WHEN NOT MATCHED BY TARGET THEN
                    INSERT
                    (tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,externalId,id,sourceId,destinationId,expectedShipmentDate,BODEGA_ORIGEN,BODEGA_DESTINO)
                    VALUES
                    (tipo_cambio,estado_cambio,intentos,fecha_ultimo_pull,fecha_ultimo_push,sync_codigo,sync_mensaje,sync_exception,externalId,id,sourceId,destinationId,expectedShipmentDate,BODEGA_ORIGEN,BODEGA_DESTINO)
                OUTPUT INSERTED.externalId,INSERTED.mid
                INTO @m(externalId,mid);

                INSERT INTO msg.SalidasTiendas_Lineas
                    (mid,sku,match_sku,amount)
                SELECT
                     a.mid
                    ,b.sku
				    ,b.match_sku
                    ,b.amount
                FROM @m a
                INNER JOIN #source_lineas b ON 
                    b.externalId = a.externalId
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
				a.codigo = 'SALIDAS_TIENDA'
		END
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        SELECT @ErrorMessage = ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

        ROLLBACK TRANSACTION
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END



