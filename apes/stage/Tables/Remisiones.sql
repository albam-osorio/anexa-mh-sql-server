CREATE TABLE [stage].[Remisiones] (
    [id]                        BIGINT       IDENTITY (1, 1) NOT NULL,
    [secuencia]                 BIGINT       NOT NULL,
    [externalId]                VARCHAR (50) NOT NULL,
    [operacion]                 VARCHAR (1)  NOT NULL,
    [estado]                    VARCHAR (50) NOT NULL,
    [orderNumber]               VARCHAR (50) NOT NULL,
    [remissionDate]             VARCHAR (10) NOT NULL,
    [destinationCode]           VARCHAR (6)  NOT NULL,
    [destinationId]             VARCHAR (50) NULL,
    [fechaUltimoCambioEnOrigen] DATETIME     NOT NULL,
    [fechaExtraccion]           DATETIME     NOT NULL,
    [fechaTransformacion]       DATETIME     NULL,
    [fechaCargue]               DATETIME     NULL
);

