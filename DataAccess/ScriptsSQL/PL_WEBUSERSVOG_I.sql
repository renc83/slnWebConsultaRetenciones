/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBUSERSVOG_I 
		 @RIF				='V036248161'
		,@PASSWORD		    ='12345'
		,@INTERID		    ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBUSERSVOG_I]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBUSERSVOG_I
go
CREATE PROCEDURE PL_WEBUSERSVOG_I
(@RIF			NVARCHAR(15)
,@PASSWORD		NVARCHAR(100)
,@INTERID		NVARCHAR(5)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR  NVARCHAR(MAX)='',@Parametro nvarchar(500)
DECLARE @NOMBRE  VARCHAR(100)
DECLARE @Mensaje NVARCHAR(100)='',@ERROR INT=0
DECLARE @Inactivo bit=1, @activo int=0
DECLARE @PerfilProveedor int=2,@PerfilAdmin int=1
DECLARE @CambiaClave bit=1, @NoCambiaClave int=0

  if (OBJECT_ID('tempdb.dbo.##DETALLE','U')) is not null
	DROP TABLE ##DETALLE

  CREATE TABLE ##DETALLE (
 NOMBRE						VARCHAR(100)
 )

 	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT TOP 1
				       PV_MI_nompro	NOMBRE
				FROM ',@INTERID,'.DBO.IMPP0161 PV
			   WHERE PV.PV_MI_rif000 = @RIF ')

   SET @Parametro = N'@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF;

	SELECT @NOMBRE=NOMBRE FROM ##DETALLE
	BEGIN TRY
		INSERT WEBUSERS_VOG (USUARIO
							,NOMBREUSUARIO
							,PASSWORD
							,IDPERFIL
							,ESTATUS
							,flg_CAMBIOCLAVE)
		VALUES (@RIF
			   ,@NOMBRE
			   ,@PASSWORD
			   ,@PerfilProveedor
			   ,@Inactivo
			   ,@CambiaClave)
	END TRY
	BEGIN CATCH
			SET @Mensaje=ERROR_MESSAGE()
			SET @ERROR=ERROR_NUMBER()
	END CATCH

	SELECT @Mensaje AS MENSAJE,@ERROR AS ERROR

SET NOCOUNT OFF;
END