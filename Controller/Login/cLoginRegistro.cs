using DataAccess.DatLogin;
using Entities.System;

namespace Controller.Login
{
	public class cLoginRegistro
	{
		public msjRespuesta RegistrarUsuario(string rif,string password,string interid) {
            msjRespuesta vRespuesta = new msjRespuesta();
			dLoginRegistro Registra = new dLoginRegistro();
			vRespuesta = Registra.RegistrarUsuario(rif, password, interid);
            return vRespuesta;
        }
	}
}
