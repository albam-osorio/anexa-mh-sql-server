CREATE TABLE [esb].[Ventas] (
    [externalId]                VARCHAR (50) NOT NULL,
    [id]                        VARCHAR (50) NOT NULL,
    [operacion]                 VARCHAR (1)  NOT NULL,
    [estado]                    VARCHAR (50) NOT NULL,
    [sincronizacionesEnCola]    INT          NOT NULL,
    [storeCode]                 VARCHAR (6)  NOT NULL,
    [saleDate]                  VARCHAR (10) NOT NULL,
    [fechaUltimoCambioEnOrigen] DATETIME     NOT NULL,
    [fechaUltimaExtraccion]     DATETIME     NOT NULL,
    [fechaUltimoCargue]         DATETIME     NOT NULL,
    [fechaUltimaIntegracion]    DATETIME     NULL,
    [fechaCreacion]             DATETIME     NOT NULL,
    [fechaModificacion]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Ventas] PRIMARY KEY CLUSTERED ([externalId] ASC)
);

