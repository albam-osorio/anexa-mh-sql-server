CREATE TABLE [msg].[SalidasTiendas] (
    [mid]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [tipo_cambio]          VARCHAR (50)   NOT NULL,
    [estado_cambio]        VARCHAR (50)   NOT NULL,
    [intentos]             INT            NOT NULL,
    [fecha_ultimo_pull]    DATETIME       NOT NULL,
    [fecha_ultimo_push]    DATETIME       NULL,
    [sync_codigo]          INT            NOT NULL,
    [sync_mensaje]         VARCHAR (1024) NOT NULL,
    [sync_exception]       VARCHAR (256)  NOT NULL,
    [externalId]           VARCHAR (50)   NOT NULL,
    [id]                   VARCHAR (50)   NOT NULL,
    [sourceId]             VARCHAR (50)   NULL,
    [destinationId]        VARCHAR (50)   NULL,
    [expectedShipmentDate] VARCHAR (10)   NOT NULL,
    [BODEGA_ORIGEN]        VARCHAR (50)   NOT NULL,
    [BODEGA_DESTINO]       VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_SalidasTiendas] PRIMARY KEY CLUSTERED ([mid] ASC)
);

