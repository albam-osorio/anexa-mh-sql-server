CREATE TABLE [stage].[Pedidos] (
    [externalId]              VARCHAR (50) NOT NULL,
    [sourceId]                VARCHAR (50) NOT NULL,
    [destinationId]           VARCHAR (50) NOT NULL,
    [cliente]                 VARCHAR (50) NOT NULL,
    [agencia]                 VARCHAR (50) NOT NULL,
    [sku]                     VARCHAR (13) NOT NULL,
    [amount]                  INT          NOT NULL,
    [expectedShipmentDate]    VARCHAR (10) NOT NULL,
    [BODEGA_ORIGEN]           VARCHAR (50) NOT NULL,
    [BODEGA_DESTINO]          VARCHAR (50) NOT NULL,
    [merge_action]            VARCHAR (1)  NOT NULL,
    [data_para_transferencia] DATETIME     NOT NULL,
    [fecha_actualizacion]     DATETIME     NOT NULL
);

