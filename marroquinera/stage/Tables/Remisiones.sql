CREATE TABLE [stage].[Remisiones] (
    [externalId]              VARCHAR (50) NOT NULL,
    [orderNumber]             VARCHAR (50) NOT NULL,
    [remissionDate]           VARCHAR (10) NOT NULL,
    [destinationCode]         VARCHAR (6)  NOT NULL,
    [operacion]               VARCHAR (1)  NOT NULL,
    [fechaActualizacion]      DATETIME     NOT NULL,
    [data_para_transferencia] DATETIME     NOT NULL
);

