CREATE TABLE [esb].[OrdenesProduccion_Lineas] (
    [externalId] VARCHAR (50) NOT NULL,
    [sku]        VARCHAR (13) NOT NULL,
    [amount]     INT          NOT NULL,
    CONSTRAINT [PK_OrdenesProduccion_Lineas] PRIMARY KEY CLUSTERED ([externalId] ASC, [sku] ASC),
    CONSTRAINT [FK_OrdenesProduccion_Lineas_OrdenesProduccion] FOREIGN KEY ([externalId]) REFERENCES [esb].[OrdenesProduccion] ([externalId])
);

