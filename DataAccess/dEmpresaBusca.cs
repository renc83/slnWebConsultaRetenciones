using Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dEmpresaBusca
	{
		public List<eEmpresa> BuscaEmpresasRif(string RIF)
		{  //			PL_WEBFindCompanyRIFVOG_S
			List<eEmpresa> ListEmpresas = new List<eEmpresa>();
            SqlConnection SQLConection = new SqlConnection();

            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEBFindCompanyRIFVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", RIF.ToUpper());
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        ListEmpresas.Add(new eEmpresa()
                        {
                            INTERID = dr["INTERID"].ToString(),
                            CMPANYID = dr["CMPNYNAM"].ToString(),
                            CORREO = dr["CORREO"].ToString()
                        });
                    }
                }
                catch (Exception ex)
                {
                    string sError = ex.Message;
                }
            }
            SQLConection.Close();
            return ListEmpresas;
		}
	}
}
