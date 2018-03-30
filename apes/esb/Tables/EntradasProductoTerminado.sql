CREATE TABLE [esb].[EntradasProductoTerminado] (
    [externalId]        VARCHAR (50) NOT NULL,
    [id]                VARCHAR (50) NOT NULL,
    [supplier]          VARCHAR (50) NOT NULL,
    [arrivalDate]       VARCHAR (10) NOT NULL,
    [concept]           VARCHAR (50) NOT NULL,
    [fecha_ultimo_pull] DATETIME     NOT NULL,
    [fecha_ultimo_push] DATETIME     NULL,
    [sincronizado]      BIT          NOT NULL,
    CONSTRAINT [PK_EntradasProductoTerminado] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

