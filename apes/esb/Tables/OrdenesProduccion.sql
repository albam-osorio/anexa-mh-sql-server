CREATE TABLE [esb].[OrdenesProduccion] (
    [externalId]        VARCHAR (50) NOT NULL,
    [id]                VARCHAR (50) NOT NULL,
    [supplier]          VARCHAR (50) NOT NULL,
    [arrivalDate]       VARCHAR (10) NOT NULL,
    [fecha_ultimo_pull] DATETIME     NOT NULL,
    [fecha_ultimo_push] DATETIME     NULL,
    [sincronizado]      BIT          NOT NULL,
    CONSTRAINT [PK_OrdenesProduccion] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

