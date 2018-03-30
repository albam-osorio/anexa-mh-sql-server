CREATE TABLE [stage].[SalidasTiendas] (
    [externalId]           VARCHAR (50) NOT NULL,
    [sourceId]             VARCHAR (50) NOT NULL,
    [destinationId]        VARCHAR (50) NOT NULL,
    [expectedShipmentDate] VARCHAR (10) NOT NULL,
    [sku]                  VARCHAR (13) NOT NULL,
    [amount]               INT          NOT NULL,
    [BODEGA_ORIGEN]        VARCHAR (50) NOT NULL,
    [BODEGA_DESTINO]       VARCHAR (50) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los datos más recientes de SALIDAS DE TIENDAS. Los datos provienen de la vista del ERP dbo.MH_SALIDAS_TIENDAS_RFID2. En cada consulta solo se traen los registros cuya fecha de actualización (DATA_PARA_TRANSFERENCIA), sea mayor o igual a la última fecha de sincronización de datos.', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro en el ERP. Proviene de la columna NUMERO_SALIDA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'externalId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único en APES de la bodega origen. Conversión del valor de la columna BODEGA_ORIGEN', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'sourceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único en APES de la bodega destino. Conversión del valor de la columna BODEGA_DESTINO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'destinationId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite de entrega. Formato YYYY-MM-DD. Proviene de la columna EMISSAO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'expectedShipmentDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Código del SKU, corresponde al código de barras del producto. Proviene de la columna CODIGO_BARRA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'sku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades por entregar. Cero si el valor es NULL. Proviene de la columna CANTIDAD', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la bodega origen del pedido. Proviene de la columna FILIAL', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'BODEGA_ORIGEN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la bodega destino del pedido. Proviene de la columna FILIAL_DESTINO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'SalidasTiendas', @level2type = N'COLUMN', @level2name = N'BODEGA_DESTINO';

