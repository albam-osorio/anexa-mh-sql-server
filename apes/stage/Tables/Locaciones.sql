CREATE TABLE [stage].[Locaciones] (
    [externalId] VARCHAR (50)  NOT NULL,
    [name]       VARCHAR (50)  NOT NULL,
    [address]    VARCHAR (100) NOT NULL,
    [type]       VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Locaciones] PRIMARY KEY CLUSTERED ([externalId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponde a los datos más recientes de las LOCACIONES de Mario Hernández (Tiendas, Puntos de Fabricas, etc.). Los datos provienen de la vista del ERP dbo.MH_MAESTRO_TIENDAS_RFID. En cada consulta solo se traen los registros cuya fecha de actualización (DATA_PARA_TRANSFERENCIA), sea mayor o igual a la última fecha de sincronización de datos.', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Locaciones';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro en el ERP. Proviene de la columna COD_FILIAL', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Locaciones', @level2type = N'COLUMN', @level2name = N'externalId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la locación. Proviene de la columna FILIAL', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Locaciones', @level2type = N'COLUMN', @level2name = N'name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección de la locación. Proviene de la columna DIRECCION', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Locaciones', @level2type = N'COLUMN', @level2name = N'address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de locación. Proviene de la columna TIPO_FILIAL. Los espacios en blancos son reemplazados por el carácter ''_'' de manera que coincida con los valores en APES', @level0type = N'SCHEMA', @level0name = N'stage', @level1type = N'TABLE', @level1name = N'Locaciones', @level2type = N'COLUMN', @level2name = N'type';

