CREATE TABLE [dbo].[Feeds] (
    [id]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [estado]            VARCHAR (50)  NOT NULL,
    [orderId]           VARCHAR (20)  NOT NULL,
    [status]            VARCHAR (20)  NOT NULL,
    [dateTime]          VARCHAR (50)  NOT NULL,
    [commitToken]       VARCHAR (MAX) NOT NULL,
    [version]           INT           NOT NULL,
    [fechaCreacion]     DATETIME      NOT NULL,
    [fechaModificacion] DATETIME      NOT NULL,
    CONSTRAINT [PK_feeds] PRIMARY KEY CLUSTERED ([id] ASC)
);

