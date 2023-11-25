/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBUSERSVOG_PSW 
		 @RIF				='V036248161'
		,@PASSWORD		    ='12345'
		,@NoCambiaClave   =1
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBUSERSVOG_PSW]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBUSERSVOG_PSW
go
CREATE PROCEDURE PL_WEBUSERSVOG_PSW
(@RIF			NVARCHAR(15)
,@PASSWORD		NVARCHAR(100)
,@NoCambiaClave int=0
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR  NVARCHAR(MAX)='',@Parametro nvarchar(500)
DECLARE @NOMBRE  VARCHAR(100)
DECLARE @Mensaje NVARCHAR(100)='',@ERROR INT=0
DECLARE @Inactivo bit=1, @activo int=0
DECLARE @PerfilProveedor int=2,@PerfilAdmin int=1
DECLARE @CambiaClave bit=1


	BEGIN TRY
		 UPDATE WEBUSERS_VOG SET PASSWORD=@PASSWORD,flg_CAMBIOCLAVE=@NoCambiaClave,ESTATUS=@activo where USUARIO=@RIF
			SET @Mensaje='Password Actualizado'
			SET @ERROR='0'
	END TRY
	BEGIN CATCH
			SET @Mensaje=ERROR_MESSAGE()
			SET @ERROR=ERROR_NUMBER()
	END CATCH

	SELECT @Mensaje AS MENSAJE,@ERROR AS ERROR

SET NOCOUNT OFF;
END