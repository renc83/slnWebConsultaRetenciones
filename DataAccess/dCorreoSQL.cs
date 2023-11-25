using Entities.System;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dCorreoSQL
	{
		public msjRespuesta EnviaCorreoSQL(string remitente,string rif,string cliente,string clave) { 
			string Profile_name =String.IsNullOrEmpty(ConfigurationManager.AppSettings.Get("Profile_name"))?"": ConfigurationManager.AppSettings.Get("Profile_name");
            msjRespuesta vRespuesta = new msjRespuesta();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("pr_SysSendMail_Cliente", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CustomerNumber", rif.ToUpper());
                    cmd.Parameters.AddWithValue("@CustomerName", cliente);
                    cmd.Parameters.AddWithValue("@customermail", remitente);
                    cmd.Parameters.AddWithValue("@profile", Profile_name);
                    cmd.Parameters.AddWithValue("@clave", clave);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        vRespuesta.Mensaje = dr["MENSAJE"].ToString();
                        vRespuesta.sError = dr["ERROR"].ToString();
                    }
                }
                catch (Exception ex)
                {
                    vRespuesta.Mensaje = ex.Message;
                    vRespuesta.sError = "1";
                }
            }
            SQLConection.Close();
            return vRespuesta;


        }
	}
}
