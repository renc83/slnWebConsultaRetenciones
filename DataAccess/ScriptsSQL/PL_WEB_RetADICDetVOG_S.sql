/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetADICDetVOG_S 
		 @RIF			='V036248161'
		 ,@DOCUMENTO ='002316'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetADICDetVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetADICDetVOG_S
go
CREATE PROCEDURE PL_WEB_RetADICDetVOG_S
(@INTERID		VARCHAR(5)
,@RIF			VARCHAR(15)
,@DOCUMENTO		VARCHAR(25)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)

  if (OBJECT_ID('tempdb.dbo.##DETALLE','U')) is not null
	DROP TABLE ##DETALLE

  CREATE TABLE ##DETALLE (
 RIF						VARCHAR(11)
,FECHADOC					DATE
,NUMFACTURA					VARCHAR(21)
,NUMCONTROL					VARCHAR(31)
,NUMNTD						VARCHAR(21)
,NUMNTC						VARCHAR(21)
,DETIMP						VARCHAR(31)
,BASEIMP					NUMERIC(19,5)
,ALICUOTA					NUMERIC(19,5)
,IMPRETENIDO				NUMERIC(19,5)
,MONTOPAGADO				NUMERIC(19,5)
,NUMDOC						VARCHAR(21)
,NUMOPERA					SMALLINT
,FACTURAAFEC				VARCHAR(21)
,TIPOTRX					SMALLINT
,NUMCONT					INT
,ACTIVIDAD					VARCHAR(30)
)


  --TRABAJO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_gene_rif000		RIF
						,IMP_gene_fecdoc		FECHADOC
						,IMP_gene_nunfac		NUMFACTURA
						,IMP_gene_ncontr		NUMCONTROL
						,IMP_gene_numntd		NUMNTD
						,IMP_gene_numntc		NUMNTC
						,IMP_gene_detimp		DETIMP
						,IMP_gene_basimp		BASEIMP
						,IMP_gene_porimp		ALICUOTA
						,IMP_gene_monimp		IMPRETENIDO
						,IMP_gene_montabon		MONTOPAGADO
						,IMP_gene_numdoc		NUMDOC
						,IMP_gene_nopera		NUMOPERA
						,IMP_gene_numfaf		FACTURAAFEC
						,IMP_gene_tiptra		TIPOTRX
						,IMP_gene_njrnent		NUMCONT
						,IMP_gene_acteco		ACTIVIDAD
				FROM ',@INTERID,'.DBO.IMPP4000 IM
			    left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.IMP_gene_idprov
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_gene_numdoc = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

  --TRABAJO ASOCIADO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_gene_rif000		RIF
						,IMP_gene_fecdoc		FECHADOC
						,IMP_gene_nunfac		NUMFACTURA
						,IMP_gene_ncontr		NUMCONTROL
						,IMP_gene_numntd		NUMNTD
						,IMP_gene_numntc		NUMNTC
						,IMP_gene_detimp		DETIMP
						,IMP_gene_basimp		BASEIMP
						,IMP_gene_porimp		ALICUOTA
						,IMP_gene_monimp		IMPRETENIDO
						,IMP_gene_montabon		MONTOPAGADO
						,IMP_gene_numdoc		NUMDOC
						,IMP_gene_nopera		NUMOPERA
						,IMP_gene_numfaf		FACTURAAFEC
						,IMP_gene_tiptra		TIPOTRX
						,IMP_gene_njrnent		NUMCONT
						,IMP_gene_acteco		ACTIVIDAD
				FROM ',@INTERID,'.DBO.IMPP4000 IM
			    left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.IMP_gene_idprov
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_gene_numfaf = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_gene_rif000h		RIF
						,IMP_gene_fecdoch		FECHADOC
						,IMP_gene_nunfach		NUMFACTURA
						,IMP_gene_ncontrh		NUMCONTROL
						,IMP_gene_numntdh		NUMNTD
						,IMP_gene_numntch		NUMNTC
						,IMP_gene_detimph		DETIMP
						,IMP_gene_basimph		BASEIMP
						,IMP_gene_porimph		ALICUOTA
						,IMP_gene_monimph		IMPRETENIDO
						,IMP_gene_montabonh		MONTOPAGADO
						,IMP_gene_numdoch		NUMDOC
						,IMP_gene_noperah		NUMOPERA
						,IMP_gene_numfafh		FACTURAAFEC
						,IMP_gene_tiptrah		TIPOTRX
						,IMP_gene_njrnentH		NUMCONT
						,IMP_gene_actecoh		ACTIVIDAD
				FROM ',@INTERID,'.DBO.IMPP4100 IM
			    left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.IMP_gene_idprovH
			  WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_gene_numdoch = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

 --HISTORICO AFECTA--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_gene_rif000h		RIF
						,IMP_gene_fecdoch		FECHADOC
						,IMP_gene_nunfach		NUMFACTURA
						,IMP_gene_ncontrh		NUMCONTROL
						,IMP_gene_numntdh		NUMNTD
						,IMP_gene_numntch		NUMNTC
						,IMP_gene_detimph		DETIMP
						,IMP_gene_basimph		BASEIMP
						,IMP_gene_porimph		ALICUOTA
						,IMP_gene_monimph		IMPRETENIDO
						,IMP_gene_montabonh		MONTOPAGADO
						,IMP_gene_numdoch		NUMDOC
						,IMP_gene_noperah		NUMOPERA
						,IMP_gene_numfafh		FACTURAAFEC
						,IMP_gene_tiptrah		TIPOTRX
						,IMP_gene_njrnentH		NUMCONT
						,IMP_gene_actecoh		ACTIVIDAD
				FROM ',@INTERID,'.DBO.IMPP4100 IM
			    left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.IMP_gene_idprovH
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_gene_numfafh = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
			
		   
	SELECT  RIF			
		   ,FECHADOC		
		   ,NUMFACTURA		
		   ,NUMCONTROL		
		   ,NUMNTD			
		   ,NUMNTC			
		   ,DETIMP			
		   ,IIF(NUMNTC='',ABS(BASEIMP		),ABS(BASEIMP		)*-1) BASEIMP					
		   ,ABS(ALICUOTA		) ALICUOTA
		   ,IIF(NUMNTC='',ABS(IMPRETENIDO	),ABS(IMPRETENIDO	)*-1) IMPRETENIDO
		   ,IIF(NUMNTC='',ABS(MONTOPAGADO	),ABS(MONTOPAGADO	)*-1) MONTOPAGADO	
		   ,NUMDOC			
		   ,NUMOPERA		
		   ,FACTURAAFEC	
		   ,TIPOTRX		
		   ,NUMCONT		
		   ,ACTIVIDAD
	FROM ##DETALLE

SET NOCOUNT OFF;
END