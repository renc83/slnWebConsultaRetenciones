using Entities.System;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess.DatLogin
{
	public class dLoginRegistro
	{
        
        public msjRespuesta RegistrarUsuario(string rif, string password, string interid)
        {
            syscEncripta cEncripta = new syscEncripta();
            msjRespuesta vRespuesta = new msjRespuesta();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEBUSERSVOG_I", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", rif.ToUpper());
                    cmd.Parameters.AddWithValue("@PASSWORD", cEncripta.cifra(password));
                    cmd.Parameters.AddWithValue("@INTERID", interid.ToUpper());
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
