CREATE TABLE [msg].[LogMensajes] (
    [id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [mid]           BIGINT         NOT NULL,
    [intento]       INT            NOT NULL,
    [estado]        VARCHAR (50)   NOT NULL,
    [codigo]        INT            NOT NULL,
    [texto]         VARCHAR (1024) NOT NULL,
    [exception]     VARCHAR (1024) NOT NULL,
    [fechaCreacion] DATETIME       NOT NULL,
    CONSTRAINT [PK_LogMensajes] PRIMARY KEY CLUSTERED ([mid] ASC, [intento] ASC)
);

