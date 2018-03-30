CREATE TABLE [esb].[Despachos] (
    [externalId]        VARCHAR (50) NOT NULL,
    [id]                VARCHAR (50) NOT NULL,
    [sourceId]          VARCHAR (50) NOT NULL,
    [destinationId]     VARCHAR (50) NOT NULL,
    [cliente]           VARCHAR (50) NOT NULL,
    [agencia]           VARCHAR (50) NOT NULL,
    [BODEGA_ORIGEN]     VARCHAR (50) NOT NULL,
    [BODEGA_DESTINO]    VARCHAR (50) NOT NULL,
    [fecha_ultimo_pull] DATETIME     NOT NULL,
    [fecha_ultimo_push] DATETIME     NULL,
    [sincronizado]      BIT          NOT NULL,
    CONSTRAINT [PK_Despachos] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

