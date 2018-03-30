CREATE TABLE [esb].[SalidasTiendas_Lineas] (
    [externalId] VARCHAR (50) NOT NULL,
    [sku]        VARCHAR (13) NOT NULL,
    [amount]     INT          NOT NULL,
    CONSTRAINT [PK_SalidasTiendas_Lineas] PRIMARY KEY CLUSTERED ([externalId] ASC, [sku] ASC),
    CONSTRAINT [FK_SalidasTiendas_Lineas_SalidasTiendas] FOREIGN KEY ([externalId]) REFERENCES [esb].[SalidasTiendas] ([externalId])
);

