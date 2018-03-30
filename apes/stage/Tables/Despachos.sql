CREATE TABLE [stage].[Despachos] (
    [externalId]           VARCHAR (50) NOT NULL,
    [sourceId]             VARCHAR (50) NOT NULL,
    [destinationId]        VARCHAR (50) NOT NULL,
    [cliente]              VARCHAR (50) NOT NULL,
    [agencia]              VARCHAR (50) NOT NULL,
    [sku]                  VARCHAR (13) NOT NULL,
    [amount]               INT          NOT NULL,
    [expectedShipmentDate] VARCHAR (10) NOT NULL,
    [BODEGA_ORIGEN]        VARCHAR (50) NOT NULL,
    [BODEGA_DESTINO]       VARCHAR (50) NOT NULL,
    [fecha_ultimo_pull]    DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los datos más recientes de PEDIDOS. Los datos provienen de la vista del ERP dbo.MH_PEDIDOS_PEND_CON_TALLAS1_RFID. Esta vista no contiene una columna con la última fecha de sincronización, razón por la cual siempre se copian todos los registros disponibles en la vista.', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro en el ERP. Proviene de la columna PEDIDO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'externalId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único en APES de la bodega origen. Conversión del valor de la columna BODEGA_ORIGEN', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'sourceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único en APES de la bodega destino. Conversión del valor de la columna BODEGA_DESTINO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'destinationId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del cliente. Proviene de la columna CLIENTE', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'cliente';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la agencia. Proviene de la columna AGENCIA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'agencia';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Código del SKU, corresponde al código de barras del producto. Proviene de la columna CODIGO_BARRA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'sku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades por entregar. Cero si el valor es NULL. Proviene de la columna CANT_X_ENTREGAR', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite de entrega. Formato YYYY-MM-DD. Proviene de la columna LIMITE_ENTREGA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'expectedShipmentDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la bodega origen del pedido. Proviene de la columna BODEGA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'BODEGA_ORIGEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la bodega destino del pedido. Valor constante = "ALISTADO"', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Despachos', @level2type = N'COLUMN', @level2name = N'BODEGA_DESTINO';

