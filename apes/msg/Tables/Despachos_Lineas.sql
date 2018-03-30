CREATE TABLE [msg].[Despachos_Lineas] (
    [mid]                  BIGINT       NOT NULL,
    [sku]                  VARCHAR (13) NOT NULL,
    [match_sku]            BIT          NOT NULL,
    [amount]               INT          NOT NULL,
    [expectedShipmentDate] VARCHAR (10) NOT NULL
);

