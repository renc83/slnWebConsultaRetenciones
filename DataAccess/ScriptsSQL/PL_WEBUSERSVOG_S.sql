/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBUSERSVOG_S 
		 @USUARIO			='V036248161'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBUSERSVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBUSERSVOG_S
go
CREATE PROCEDURE PL_WEBUSERSVOG_S
(@USUARIO NVARCHAR(15)
) AS
BEGIN
SET NOCOUNT ON;

  SELECT USUARIO
		,NOMBREUSUARIO
		,PASSWORD
		,IDPERFIL
		,IIF(IDPERFIL=1,'SYSADMIN','PROVEEDOR') PERFIL
		,ESTATUS
		,isnull(flg_CAMBIOCLAVE,0) flg_CAMBIOCLAVE
	FROM WEBUSERS_VOG 
   WHERE USUARIO=@USUARIO

SET NOCOUNT OFF;
END