using System;
using System.Configuration;
using System.Data.SqlClient;
using Entities.System;



namespace DataAccess
{
	public class sysConexionSQL
	{
        public static SqlConnection AbreConexion()
        {
            string strID = ConfigurationManager.AppSettings.Get("Usuario");
            string strPassword = ConfigurationManager.AppSettings.Get("Password");
            string strDatabase = ConfigurationManager.AppSettings.Get("Database");
            string strSource = ConfigurationManager.AppSettings.Get("Servidor");
           
            try
            {
                SqlConnection SqlC = new SqlConnection("Data Source=" + strSource + ";Initial Catalog=" + strDatabase + ";user ID = " + strID + ";Password=" + strPassword + "");
                SqlC.Open();
                return SqlC;
            }
            catch (Exception Ex)
            {
                return null;
            }
        }

        public static SqlConnection AbreConexionEmpresa(string vEmpresa)
        {
            string strID = ConfigurationManager.AppSettings.Get("usuario");
            string strPassword = ConfigurationManager.AppSettings.Get("Password");
            string strSource = ConfigurationManager.AppSettings.Get("Servidor");
            try
            {
                SqlConnection SqlC = new SqlConnection("Data Source=" + sysEmpresa.servidor + ";Initial Catalog=" + vEmpresa + ";Persist Security Info=True;user ID = " + strID + ";Password=" + strPassword + "");
                SqlC.Open();
                return SqlC;
            }
            catch (Exception Ex)
            {
                return null;
            }
        }
    }
}
