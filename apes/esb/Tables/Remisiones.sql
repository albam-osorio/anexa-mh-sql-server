CREATE TABLE [esb].[Remisiones] (
    [externalId]                VARCHAR (50) NOT NULL,
    [id]                        VARCHAR (50) NOT NULL,
    [operacion]                 VARCHAR (1)  NOT NULL,
    [estado]                    VARCHAR (50) NOT NULL,
    [sincronizacionesEnCola]    INT          NOT NULL,
    [orderNumber]               VARCHAR (50) NOT NULL,
    [remissionDate]             VARCHAR (10) NOT NULL,
    [destinationCode]           VARCHAR (6)  NOT NULL,
    [destinationId]             VARCHAR (50) NOT NULL,
    [fechaUltimoCambioEnOrigen] DATETIME     NOT NULL,
    [fechaUltimaExtraccion]     DATETIME     NOT NULL,
    [fechaUltimoCargue]         DATETIME     NOT NULL,
    [fechaUltimaIntegracion]    DATETIME     NULL,
    [fechaCreacion]             DATETIME     NOT NULL,
    [fechaModificacion]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Remisiones] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

