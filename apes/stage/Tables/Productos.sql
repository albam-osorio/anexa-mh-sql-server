CREATE TABLE [stage].[Productos] (
    [externalId]       VARCHAR (13) NOT NULL,
    [companyPrefix]    VARCHAR (7)  NOT NULL,
    [name]             VARCHAR (50) NOT NULL,
    [reference]        VARCHAR (6)  NOT NULL,
    [ean]              VARCHAR (25) NOT NULL,
    [color]            VARCHAR (50) NOT NULL,
    [codigoColor]      VARCHAR (50) NOT NULL,
    [talla]            VARCHAR (50) NOT NULL,
    [tipoProducto]     VARCHAR (50) NOT NULL,
    [coleccion]        VARCHAR (50) NOT NULL,
    [grupoProducto]    VARCHAR (50) NOT NULL,
    [subGrupoProducto] VARCHAR (50) NOT NULL,
    [fabricante]       VARCHAR (50) NOT NULL,
    [temporada]        VARCHAR (50) NOT NULL,
    [referencia]       VARCHAR (50) NOT NULL,
    [modelo]           VARCHAR (50) NOT NULL,
    [genero]           VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([externalId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los datos más recientes de las REFERENCIAS DE LOS PRODUCTOS DEL INVENTARIO de Mario Hernández. Los datos provienen de la vista del ERP dbo.MH_MAESTRO_PRODUCTOS_ARIADNA1_RFID. En cada consulta solo se traen los registros cuya fecha de actualización (DATA_PARA_TRANSFERENCIA), sea mayor o igual a la última fecha de sincronización de datos.', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro en el ERP. Corresponde al código de barras del producto. Proviene de la columna CODIGO_BARRA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'externalId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los 7 primeros caracteres del codigo de barras', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'companyPrefix';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del producto. Proviene de la columna DESCRIPCION', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los 6 ultimos caracteres del codigo de barras', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'reference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Toma el mismo valor del la columna externalId', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'ean';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Color del producto. Proviene de la columna COLOR. e.g. TERRACOTA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'color';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Código del color del producto. Proviene de la columna COD_COLOR. e.g. 17', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'codigoColor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Talla del producto. Proviene de la columna TALLA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'talla';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo del producto. Proviene de la columna TIPO_PRODUTO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'tipoProducto';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Collección del producto. Proviene de la columna COLECCION', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'coleccion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Grupo del producto. Proviene de la columna GRUPO_PRODUTO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'grupoProducto';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sub grupo del producto. Proviene de la columna SUBGRUPO_PRODUTO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'subGrupoProducto';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fabricante del producto. Proviene de la columna FABRICANTE', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'fabricante';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Temporada del producto. Proviene de la columna TEMPORADA', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'temporada';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Referencia del producto. Proviene de la columna PRODUCTO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'referencia';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Modelo del producto. Proviene de la columna MODELO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'modelo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Genero del producto. Proviene de la columna GENERO', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Productos', @level2type = N'COLUMN', @level2name = N'genero';

