using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities.System;
using DataAccess.DatLogin;

namespace Controller.Login
{
	public class cLoginActualizaPSW
	{
        public msjRespuesta ActualizaPassword(string rif, string password, string cambioclave)
        {
            dLoginActualizaPSW contrasena = new dLoginActualizaPSW();
            msjRespuesta vRespuesta = new msjRespuesta();
            vRespuesta = contrasena.ActualizaPassword(rif,password,cambioclave);           
            return vRespuesta;
        }
    }
}
