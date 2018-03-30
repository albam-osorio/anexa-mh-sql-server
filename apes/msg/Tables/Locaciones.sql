CREATE TABLE [msg].[Locaciones] (
    [mid]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [tipo_cambio]       VARCHAR (50)   NOT NULL,
    [estado_cambio]     VARCHAR (50)   NOT NULL,
    [intentos]          INT            NOT NULL,
    [fecha_ultimo_pull] DATETIME       NOT NULL,
    [fecha_ultimo_push] DATETIME       NULL,
    [sync_codigo]       INT            NOT NULL,
    [sync_mensaje]      VARCHAR (1024) NOT NULL,
    [sync_exception]    VARCHAR (256)  NULL,
    [externalId]        VARCHAR (50)   NOT NULL,
    [id]                VARCHAR (50)   NOT NULL,
    [name]              VARCHAR (50)   NOT NULL,
    [address]           VARCHAR (100)  NOT NULL,
    [type]              VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_Locaciones] PRIMARY KEY CLUSTERED ([mid] ASC)
);

