/*====================================================================
Author: Rafael Ni�o
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetIvaEncVOG_S 
		 @RIF			='V123917967'
		 ,@DOCUMENTO ='00517'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetIvaEncVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetIvaEncVOG_S
go
CREATE PROCEDURE PL_WEB_RetIvaEncVOG_S
(@INTERID		VARCHAR(5)
,@RIF			VARCHAR(15)
,@DOCUMENTO		VARCHAR(25)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)

  if (OBJECT_ID('tempdb.dbo.##ENCABEZADO','U')) is not null
	DROP TABLE ##ENCABEZADO

  CREATE TABLE ##ENCABEZADO (
 NROCOMPROBANTE			VARCHAR(21)
,FECHACON				DATE
,FECHADOC				DATE
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
					 IM.IMP_nc_open_nreten		NROCOMPROBANTE
					,IM.IMP_nc_open_feccon		FECHACON
					,IM.IMP_nc_open_fecdoc		FECHADOC
					,IM.IMP_nc_open_nompro		PROVEEDOR
					,IM.IMP_nc_open_rif000		RIFPROVEEDOR
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
				FROM ',@INTERID,'.DBO.IMPP2001 IM
				left JOIN DYNAMICS.dbo.SY01500 CM ON CM.INTERID = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPC0001 CV  ON CV.CO_MI_idcomp = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.open_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_open_docnum = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
print @SQLSTR
  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##ENCABEZADO
					SELECT TOP 1
					 IM.IMP_nc_hist_nreten		NROCOMPROBANTE
					,IM.IMP_nc_hist_feccon		FECHACON
					,IM.IMP_nc_hist_fecdoc		FECHADOC
					,IM.IMP_nc_hist_nompro		PROVEEDOR
					,IM.IMP_nc_hist_rif000		RIFPROVEEDOR
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
				FROM ',@INTERID,'.DBO.IMPP2201 IM
				left JOIN DYNAMICS.dbo.SY01500 CM ON CM.INTERID = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPC0001 CV  ON CV.CO_MI_idcomp = ''',@INTERID,'''
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.hist_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_hist_docnum = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

	SELECT * FROM ##ENCABEZADO

SET NOCOUNT OFF;
END