using Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dRetencionIvaDet
	{
		public List<eRetencionIvaDet> BuscarRetencionIvaDet(eFiltroDocumentos filtrodocumento)
		{
			List<eRetencionIvaDet> detalle = new List<eRetencionIvaDet>();
            eRetencionIvaEnc encabezado = new eRetencionIvaEnc();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEB_RetIvaDetVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", filtrodocumento.RIF.ToUpper());
                    cmd.Parameters.AddWithValue("@INTERID", filtrodocumento.InterID);
                    cmd.Parameters.AddWithValue("@DOCUMENTO", filtrodocumento.Documento);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        detalle.Add(new eRetencionIvaDet()
                        {
                            numope =Convert.ToInt32(dr["numope"].ToString()),
                            RIF = dr["RIF"].ToString(),
                            FECHADOC =Convert.ToDateTime(dr["FECHADOC"].ToString()),
                            NUMFACTURA = dr["NUMFACTURA"].ToString(),
                            NUMCONTROL = dr["NUMCONTROL"].ToString(),
                            NUMNTD = dr["NUMNTD"].ToString(),
                            NUMNTC = dr["NUMNTC"].ToString(),
                            TIPOTRANS = dr["TIPOTRANS"].ToString(),
                            FACAFEC = (dr["FACAFEC"].ToString()),
                            COCIVA = Convert.ToDecimal(dr["COCIVA"].ToString()),
                            COSIVA = Convert.ToDecimal(dr["COSIVA"].ToString()),
                            IMP_basimp_alicgene = Convert.ToDecimal(dr["IMP_basimp_alicgene"].ToString()),
                            IMP_porceimp_alicgene = Convert.ToDecimal(dr["IMP_porceimp_alicgene"].ToString()),
                            IMP_montoimp_alicgene = Convert.ToDecimal(dr["IMP_montoimp_alicgene"].ToString()),
                            IMP_basimp_alicreduc = Convert.ToDecimal(dr["IMP_basimp_alicreduc"].ToString()),
                            IMP_porceimp_alicreduc = Convert.ToDecimal(dr["IMP_porceimp_alicreduc"].ToString()),
                            IMP_montoimp_alicreduc = Convert.ToDecimal(dr["IMP_montoimp_alicreduc"].ToString()),
                            IMP_basimp_alicadic = Convert.ToDecimal(dr["IMP_basimp_alicadic"].ToString()),
                            IMP_porceimp_alicadic = Convert.ToDecimal(dr["IMP_porceimp_alicadic"].ToString()),
                            IMP_montoimp_alicadic = Convert.ToDecimal(dr["IMP_montoimp_alicadic"].ToString()),
                            alicuota = Convert.ToDecimal(dr["alicuota"].ToString()),
                            IVARET = Convert.ToDecimal(dr["IVARET"].ToString())
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
