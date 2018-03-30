CREATE TABLE [stage].[Ventas] (
    [externalId]              VARCHAR (50) NOT NULL,
    [storeCode]               VARCHAR (6)  NOT NULL,
    [saleDate]                VARCHAR (10) NOT NULL,
    [barCode]                 VARCHAR (13) NOT NULL,
    [quantity]                INT          NOT NULL,
    [operacion]               VARCHAR (1)  NOT NULL,
    [data_para_transferencia] DATETIME     NOT NULL,
    [fechaActualizacion]      DATETIME     NOT NULL
);

