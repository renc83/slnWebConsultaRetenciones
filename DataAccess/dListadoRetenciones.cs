using Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dListadoRetenciones
	{
		public List<eDocumentos> ListadoRetenciones(eFiltroDocumentos filtrodocumento)
		{
			List<eDocumentos> documentos = new List<eDocumentos>();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEBListRetencionesVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", filtrodocumento.RIF.ToUpper());
                    cmd.Parameters.AddWithValue("@INTERID", filtrodocumento.InterID);
                    cmd.Parameters.AddWithValue("@FECHADESDE", filtrodocumento.fechaDesde);
                    cmd.Parameters.AddWithValue("@FECHAHASTA", filtrodocumento.fechaHasta);
                    cmd.Parameters.AddWithValue("@DOCUMENTO", filtrodocumento.Documento);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        documentos.Add(new eDocumentos()
                        {
                            id = Convert.ToInt32(dr["ID"]),
                            nrodocumento= dr["NRODOCUMENTO"].ToString(),
                            fechadocumento= dr["FECHADOC"].ToString(),
                            fecharegistro= dr["FECHACON"].ToString(),
                            alicuota= dr["ALICUOTA"].ToString(),
                            tipo= dr["TIPO"].ToString()
                        });
                    }
                }
                catch (Exception ex)
                {
                    string sError = ex.Message;
                }
            }
            SQLConection.Close();
            return documentos;
		}
	}
}
