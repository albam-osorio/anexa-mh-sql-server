
CREATE PROCEDURE [esb].[IntegracionesGetFechaUltimoPull]
    @codigo	varchar(50)
AS
BEGIN
    SELECT 
        a.fecha_ultimo_pull,
	    CONVERT(VARCHAR(20),a.fecha_ultimo_pull,120) AS str_fecha_ultimo_pull
    FROM esb.integraciones a
    WHERE
        a.codigo = @codigo
END



