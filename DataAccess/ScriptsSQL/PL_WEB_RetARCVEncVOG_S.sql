/*====================================================================
Author: Rafael Ni�o
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetARCVEncVOG_S 
		 @RIF			='V036248161'
		 ,@ANIO		 ='2023'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetARCVEncVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetARCVEncVOG_S
go
CREATE PROCEDURE PL_WEB_RetARCVEncVOG_S
(@INTERID		VARCHAR(5)
,@RIF			VARCHAR(15)
,@ANIO		    varchar(4)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)

  if (OBJECT_ID('tempdb.dbo.##ENCABEZADO','U')) is not null
	DROP TABLE ##ENCABEZADO

  CREATE TABLE ##ENCABEZADO (
 PERIODO				VARCHAR(50)
,FECHAEMISION			DATE
,ANIOIMPOSITIVO			INT
,PROVEEDOR				VARCHAR(65)
,RIFPROVEEDOR			VARCHAR(11)
,COMPANY				VARCHAR(65)
,COMP_DIRECCION1		VARCHAR(61)
,COMP_DIRECCION2		VARCHAR(61)
,COMP_DIRECCION3		VARCHAR(61)
,COMP_CIUDAD			VARCHAR(35)
,COMP_RIF				VARCHAR(11)
,PRV_DIRECCION1			VARCHAR(71)
,PRV_DIRECCION2			VARCHAR(71)
,PRV_DIRECCION3			VARCHAR(71)
,PRV_CUIDAD				VARCHAR(31)
,PRV_ESTADO				VARCHAR(31)
)


  --TRABAJO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##ENCABEZADO
					SELECT TOP 1
					 CONCAT(''Desde 01-01-'',@ANIO,'' Hasta 31-12-'',@ANIO) PERIODO
					,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IM.IMP_nc_open3_period),4),''1231'')) 	FECHAEMISION
					,RIGHT(RTRIM(IM.IMP_nc_open3_period),4)		ANIOIMPOSITIVO
					,IM.IMP_nc_open3_nompro		PROVEEDOR
					,IM.IMP_nc_open3_rif000		RIFPROVEEDOR
					,CM.CMPNYNAM				COMPANY			
					,CM.ADDRESS1				COMP_DIRECCION1
					,CM.ADDRESS2				COMP_DIRECCION2
					,CM.ADDRESS3				COMP_DIRECCION3
					,CM.CITY					COMP_CIUDAD
					,CV.CO_MI_rif000		    COMP_RIF	
					,PV.PV_MI_direc1			PRV_DIRECCION1
					,PV.PV_MI_direc2			PRV_DIRECCION2
					,PV.PV_MI_direc3			PRV_DIRECCION3
					,PV.PV_MI_ciudad			PRV_CUIDAD
					,PV.PV_MI_estado			PRV_ESTADO
				FROM ',@INTERID,'.DBO.IMPP3000 IM
				left JOIN DYNAMICS.dbo.SY01500 CM ON CM.INTERID = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPC0001 CV  ON CV.CO_MI_idcomp = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND RIGHT(RTRIM(IM.IMP_nc_open3_period),4) = @ANIO')

   SET @Parametro = N'@RIF NVARCHAR(12),@ANIO		INT';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@ANIO=@ANIO;

  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##ENCABEZADO
					SELECT TOP 1
					CONCAT(''Desde 01-01-'',@ANIO,'' Hasta 31-12-'',@ANIO) PERIODO
					,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IM.IMP_nc_hist3_period),4),''1231'')) 	FECHAEMISION
					,RIGHT(RTRIM(IM.IMP_nc_hist3_period),4)		ANIOIMPOSITIVO
					,IM.IMP_nc_hist3_nompro		PROVEEDOR
					,IM.IMP_nc_hist3_rif000		RIFPROVEEDOR
					,CM.CMPNYNAM				COMPANY			
					,CM.ADDRESS1				COMP_DIRECCION1
					,CM.ADDRESS2				COMP_DIRECCION2
					,CM.ADDRESS3				COMP_DIRECCION3
					,CM.CITY					COMP_CIUDAD
					,CV.CO_MI_rif000		    COMP_RIF	
					,PV.PV_MI_direc1			PRV_DIRECCION1
					,PV.PV_MI_direc2			PRV_DIRECCION2
					,PV.PV_MI_direc3			PRV_DIRECCION3
					,PV.PV_MI_ciudad			PRV_CUIDAD
					,PV.PV_MI_estado			PRV_ESTADO
				FROM ',@INTERID,'.DBO.IMPP3200 IM
				left JOIN DYNAMICS.dbo.SY01500 CM ON CM.INTERID = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPC0001 CV  ON CV.CO_MI_idcomp = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.hist3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND RIGHT(RTRIM(IM.IMP_nc_hist3_period),4) = @ANIO')

   SET @Parametro = N'@RIF NVARCHAR(12),@ANIO		INT';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@ANIO=@ANIO;

	SELECT * FROM ##ENCABEZADO

SET NOCOUNT OFF;
END