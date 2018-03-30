CREATE TABLE [esb].[Locaciones] (
    [externalId]         VARCHAR (50)  NOT NULL,
    [id]                 VARCHAR (50)  NOT NULL,
    [name]               VARCHAR (50)  NOT NULL,
    [address]            VARCHAR (100) NOT NULL,
    [type]               VARCHAR (50)  NOT NULL,
    [fecha_ultimo_pull]  DATETIME      NOT NULL,
    [fecha_ultimo_push]  DATETIME      NULL,
    [sincronizado]       BIT           NOT NULL,
    [directorio_salidas] VARCHAR (300) NULL,
    CONSTRAINT [PK_Locaciones] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

