CREATE TABLE [esb].[Seriales] (
    [id]                  BIGINT       IDENTITY (1, 1) NOT NULL,
    [serial]              VARCHAR (50) NOT NULL,
    [sku]                 VARCHAR (13) NOT NULL,
    [fecha_actualizacion] DATETIME     NOT NULL,
    CONSTRAINT [PK_Seriales] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_Seriales] UNIQUE NONCLUSTERED ([serial] ASC)
);

