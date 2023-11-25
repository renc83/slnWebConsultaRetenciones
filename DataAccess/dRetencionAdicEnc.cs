using Entities;
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
	public class dRetencionAdicEnc
	{
        public eRetencionAdicEnc BuscarRetencionAdicEnc(eFiltroDocumentos filtrodocumento)
        {
            eRetencionAdicEnc encabezado = new eRetencionAdicEnc();
            SqlConnection SQLConection = new SqlConnection();
            SQLConection = sysConexionSQL.AbreConexion();
            if (!Object.ReferenceEquals(null, SQLConection))
            {
                try
                { //cambiar por Sp
                    SqlCommand cmd = new SqlCommand("PL_WEB_RetAdicEncVOG_S", SQLConection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RIF", filtrodocumento.RIF.ToUpper());
                    cmd.Parameters.AddWithValue("@INTERID", filtrodocumento.InterID);
                    cmd.Parameters.AddWithValue("@DOCUMENTO", filtrodocumento.Documento);
                    SqlDataReader dr;
                    dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        encabezado.NROCOMPROBANTE = dr["NROCOMPROBANTE"].ToString();
                        encabezado.FECHACON = Convert.ToDateTime(dr["FECHACON"].ToString());
                        encabezado.FECHADOC = Convert.ToDateTime(dr["FECHADOC"].ToString());
                        encabezado.PROVEEDOR = dr["PROVEEDOR"].ToString();
                        encabezado.RIFPROVEEDOR = dr["RIFPROVEEDOR"].ToString();
                        encabezado.COMPANY = dr["COMPANY"].ToString();
                        encabezado.COMP_DIRECCION1 = dr["COMP_DIRECCION1"].ToString();
                        encabezado.COMP_DIRECCION2 = dr["COMP_DIRECCION2"].ToString();
                        encabezado.COMP_DIRECCION3 = dr["COMP_DIRECCION3"].ToString();
                        encabezado.COMP_CIUDAD = dr["COMP_CIUDAD"].ToString();
                        encabezado.COMP_RIF = dr["COMP_RIF"].ToString();
                        encabezado.COMP_NIT = dr["COMP_NIT"].ToString();
                        encabezado.PRV_DIRECCION1 = dr["PRV_DIRECCION1"].ToString();
                        encabezado.PRV_DIRECCION2 = dr["PRV_DIRECCION2"].ToString();
                        encabezado.PRV_DIRECCION3 = dr["PRV_DIRECCION3"].ToString();
                        encabezado.PRV_CUIDAD = dr["PRV_CUIDAD"].ToString();
                        encabezado.PRV_ESTADO = dr["PRV_ESTADO"].ToString();
                    }
                }
                catch (Exception ex)
                {
                    string sError = ex.Message;
                }
            }
            SQLConection.Close();
            return encabezado;
        }
    }
}
