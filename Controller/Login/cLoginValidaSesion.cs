using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccess.DatLogin;

namespace Controller.Login
{
	public class cLoginValidaSesion
	{
		public int ValidaSesion(string RifUsuario, string strPassword)
		{
			int iAcceso = 0;
			dLoginValidaSesion ValidaSesion = new dLoginValidaSesion();
			iAcceso = ValidaSesion.ValidaSesion(RifUsuario, strPassword);
			return iAcceso;
		}
		}
}
