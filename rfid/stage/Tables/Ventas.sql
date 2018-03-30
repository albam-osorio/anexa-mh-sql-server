CREATE TABLE [stage].[Ventas] (
    [id]                        BIGINT       IDENTITY (1, 1) NOT NULL,
    [secuencia]                 BIGINT       NOT NULL,
    [externalId]                VARCHAR (50) NOT NULL,
    [operacion]                 VARCHAR (1)  NOT NULL,
    [estado]                    VARCHAR (50) NOT NULL,
    [storeCode]                 VARCHAR (6)  NOT NULL,
    [saleDate]                  VARCHAR (10) NOT NULL,
    [barCode]                   VARCHAR (13) NOT NULL,
    [productId]                 VARCHAR (50) NULL,
    [quantity]                  INT          NOT NULL,
    [fechaUltimoCambioEnOrigen] DATETIME     NOT NULL,
    [fechaExtraccion]           DATETIME     NOT NULL,
    [fechaTransformacion]       DATETIME     NULL,
    [fechaCargue]               DATETIME     NULL,
    CONSTRAINT [PK_Ventas] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Ventas_01]
    ON [stage].[Ventas]([secuencia] ASC);

