using Entities.System;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess.DatLogin
{
	public class dLoginValidaSesion
	{
		public int ValidaSesion(string RifUsuario, string strPassword) {
            syscEncripta cEncripta = new syscEncripta();
            SqlConnection SQLConection = new SqlConnection();
			int iAcceso = 0;
            SesionUsuario.acceso = 0;
            SesionUsuario.idusuario = null;
            SesionUsuario.idperfil = null;
            SesionUsuario.nombreusuario = null;
            SesionUsuario.perfil = null;
            SesionUsuario.estatus = 9; //0: activo
            SesionUsuario.flg_cambioclave = 0;

            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEBUSERSVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@USUARIO", RifUsuario.ToUpper());
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        SesionUsuario.idusuario = dr["USUARIO"].ToString();
                        SesionUsuario.idperfil = dr["IDPERFIL"].ToString();
                        SesionUsuario.nombreusuario = dr["NOMBREUSUARIO"].ToString().Trim();
                        SesionUsuario.perfil = dr["PERFIL"].ToString();
                        SesionUsuario.estatus = Convert.ToInt32(dr["ESTATUS"].ToString());
                        SesionUsuario.flg_cambioclave = Convert.ToInt32(dr["flg_CAMBIOCLAVE"]);
                        if (dr["Password"].ToString().Trim() == cEncripta.cifra(strPassword))
                        {
                            SesionUsuario.acceso = 1;
                        }
                    }
                }
                catch (Exception ex)
                {
                    SesionUsuario.acceso = 0;
                }
            }
            iAcceso = SesionUsuario.acceso;
            SQLConection.Close();
            return iAcceso;
		}
	}
}
