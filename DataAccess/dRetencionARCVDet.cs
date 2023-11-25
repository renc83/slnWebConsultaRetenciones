using Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dRetencionARCVDet
	{
        public List<eRetencionARCVDet> BuscarRetencionARCVDet(eFiltroDocumentos filtrodocumento)
        {
            List<eRetencionARCVDet> detalle = new List<eRetencionARCVDet>();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEB_RetARCVDetVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", filtrodocumento.RIF.ToUpper());
                    cmd.Parameters.AddWithValue("@INTERID", filtrodocumento.InterID);
                    cmd.Parameters.AddWithValue("@ANIO", filtrodocumento.Documento);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        detalle.Add(new eRetencionARCVDet()
                        {
                            RIF = dr["RIF"].ToString(),
                            ANIO = Convert.ToInt32(dr["ANIO"].ToString()),
                            MES = (dr["MES"].ToString()),
                            BASEIMP = Convert.ToDecimal(dr["BASEIMP"].ToString()),
                            ALICUOTA = Convert.ToDecimal(dr["ALICUOTA"].ToString()),
                            ISLRRETENIDO = Convert.ToDecimal(dr["ISLRRETENIDO"].ToString()),
                            MONTOPAGADO = Convert.ToDecimal(dr["MONTOPAGADO"].ToString()),
                            FECHADOC = Convert.ToDateTime(dr["FECHADOC"].ToString()),
                            DOCUMENTO = dr["DOCUMENTO"].ToString(),
                            DETIMP = dr["DETIMP"].ToString()
                        });
                    }
                }
                catch (Exception ex)
                {
                    string sError = ex.Message;
                }
            }
            SQLConection.Close();
            return detalle;
        }
    }
}
