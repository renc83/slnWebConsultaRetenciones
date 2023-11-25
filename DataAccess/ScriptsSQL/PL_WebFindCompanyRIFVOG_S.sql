/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBFindCompanyRIFVOG_S 
		 @RIF			='J305910553'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBFindCompanyRIFVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBFindCompanyRIFVOG_S
go
CREATE PROCEDURE PL_WEBFindCompanyRIFVOG_S
(@RIF NVARCHAR(15)
) AS
BEGIN
SET NOCOUNT ON;
  DECLARE @I INT=1,@TOTALFILAS INT=0
  DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)
  DECLARE @INTERID	VARCHAR(5),@CMPNYNAM		CHAR(65)
  DECLARE @EMPRESAS TABLE (
	 ID				INT
	,INTERID		CHAR(5)	
	,CMPNYNAM		CHAR(65)
	,ACTIVE			INT
  )

  if (OBJECT_ID('tempdb.dbo.##EMPRESAS','U')) is not null
	DROP TABLE ##EMPRESAS

  CREATE TABLE ##EMPRESAS (
	 INTERID		CHAR(5)	
	,CMPNYNAM		CHAR(65)
	,CORREO			CHAR(31)
  )

  INSERT INTO @EMPRESAS
  SELECT ROW_NUMBER() OVER(ORDER BY INTERID) ID
         ,INTERID,CMPNYNAM,0 ACTIVE
    FROM SY01500 
   WHERE INTERID NOT IN (SELECT INTERID FROM WEBCOMPANY_VOG)
   

   SET @TOTALFILAS=(SELECT COUNT(0) FROM @EMPRESAS)

   WHILE (@I<=@TOTALFILAS)
   BEGIN
	   SELECT @INTERID=INTERID,@CMPNYNAM=CMPNYNAM FROM @EMPRESAS WHERE ID=@I

		  SET @SQLSTR=CONCAT(' INSERT INTO ##EMPRESAS
					  SELECT   ''',@INTERID,''' AS INTERID
							 ,''',@CMPNYNAM,''' AS INTERID
							 ,P.COMMENT2		AS CORREO
					    FROM ',@INTERID,'.DBO.IMPP0161 I
					  LEFT JOIN ',@INTERID,'.DBO.PM00200 P ON P.VENDORID=I.PV_MI_idprov
					   WHERE PV_MI_rif000=@RIF')

   SET @Parametro = N'@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF;

		
		SET @I=@I+1
   END


   SELECT * FROM ##EMPRESAS order by CORREO desc

SET NOCOUNT OFF;
END