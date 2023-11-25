using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using DataAccess;

namespace Controller
{
	public class cEmpresaBusca
	{
		public List<eEmpresa> BuscaEmpresasRif(string RIF)
		{
			List<eEmpresa> ListEmpresas = new List<eEmpresa>();
			dEmpresaBusca cEmpresa = new dEmpresaBusca();
			ListEmpresas = cEmpresa.BuscaEmpresasRif(RIF);
			return ListEmpresas;
		}
	}
}
