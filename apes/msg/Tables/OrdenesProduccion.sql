CREATE TABLE [msg].[OrdenesProduccion] (
    [mid]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [tipo_cambio]       VARCHAR (50)   NOT NULL,
    [estado_cambio]     VARCHAR (50)   NOT NULL,
    [intentos]          INT            NOT NULL,
    [fecha_ultimo_pull] DATETIME       NOT NULL,
    [fecha_ultimo_push] DATETIME       NULL,
    [sync_codigo]       INT            NOT NULL,
    [sync_mensaje]      VARCHAR (1024) NOT NULL,
    [sync_exception]    VARCHAR (256)  NOT NULL,
    [externalId]        VARCHAR (50)   NOT NULL,
    [id]                VARCHAR (50)   NOT NULL,
    [supplier]          VARCHAR (50)   NOT NULL,
    [arrivalDate]       VARCHAR (10)   NOT NULL,
    CONSTRAINT [PK_OrdenesProduccion] PRIMARY KEY CLUSTERED ([mid] ASC)
);

