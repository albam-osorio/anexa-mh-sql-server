CREATE TABLE [stage].[OrdenesProduccion] (
    [externalId]  VARCHAR (50) NOT NULL,
    [supplier]    VARCHAR (50) NOT NULL,
    [arrivalDate] VARCHAR (10) NOT NULL,
    [sku]         VARCHAR (13) NOT NULL,
    [amount]      INT          NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los datos más recientes de las ORDENES DE PRODUCCIÓN. Los datos provienen de la vista del ERP dbo.MH_ORDENES_PRODUCCION2_RFID. Esta vista no contiene una columna con la última fecha de sincronización, razón por la cual siempre se copian todos los registros disponibles en la vista.Usa el valor de la columna SECUENCIA para solo traer el registro de la misma orden con el menor valor.', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro en el ERP. Proviene de la columna OP', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion', @level2type = N'COLUMN', @level2name = N'externalId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Proveedor del producto. Proviene de la columna RECURSO_PRODUTIVO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion', @level2type = N'COLUMN', @level2name = N'supplier';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de la orden. Formato YYYY-MM-DD. Proviene de la columna FECHA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion', @level2type = N'COLUMN', @level2name = N'arrivalDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Código del SKU, corresponde al código de barras del SKU. Proviene de la columna CODIGO_BARRA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion', @level2type = N'COLUMN', @level2name = N'sku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades. Cero si el valor es NULL. Proviene de la columna CANTIDAD', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'OrdenesProduccion', @level2type = N'COLUMN', @level2name = N'amount';

