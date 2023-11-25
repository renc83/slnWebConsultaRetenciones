using Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dRetencionAdicDet
	{
        public List<eRetencionAdicDet> BuscarRetencionAdicDet(eFiltroDocumentos filtrodocumento)
        {
            List<eRetencionAdicDet> detalle = new List<eRetencionAdicDet>();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEB_RetAdicDetVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", filtrodocumento.RIF.ToUpper());
                    cmd.Parameters.AddWithValue("@INTERID", filtrodocumento.InterID);
                    cmd.Parameters.AddWithValue("@DOCUMENTO", filtrodocumento.Documento);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        detalle.Add(new eRetencionAdicDet()
                        {
                            RIF = dr["RIF"].ToString(),
                            FECHADOC = Convert.ToDateTime(dr["FECHADOC"].ToString()),
                            NUMFACTURA = dr["NUMFACTURA"].ToString(),
                            NUMCONTROL = dr["NUMCONTROL"].ToString(),
                            NUMNTD = dr["NUMNTD"].ToString(),
                            NUMNTC = dr["NUMNTC"].ToString(),
                            DETIMP = dr["DETIMP"].ToString(),
                            BASEIMP = Convert.ToDecimal(dr["BASEIMP"].ToString()),
                            ALICUOTA = Convert.ToDecimal(dr["ALICUOTA"].ToString()),
                            IMPRETENIDO = Convert.ToDecimal(dr["IMPRETENIDO"].ToString()),
                            MONTOPAGADO = Convert.ToDecimal(dr["MONTOPAGADO"].ToString()),
                            NUMDOC = dr["NUMDOC"].ToString(),
                            NUMOPERA = Convert.ToInt32(dr["NUMOPERA"].ToString()),
                            FACTURAAFEC = (dr["FACTURAAFEC"].ToString()),
                            TIPOTRX = Convert.ToInt32(dr["TIPOTRX"].ToString()),
                            NUMCONT = Convert.ToInt32(dr["NUMCONT"].ToString()),
                            ACTIVIDAD = dr["ACTIVIDAD"].ToString()
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
