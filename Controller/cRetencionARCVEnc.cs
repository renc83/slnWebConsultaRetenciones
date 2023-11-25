using DataAccess;
using Entities;

namespace Controller
{
	public class cRetencionARCVEnc
	{
		public eRetencionARCVEnc BuscarRetencionARCVEnc(eFiltroDocumentos filtroDoc)
		{
			eRetencionARCVEnc encabezado = new eRetencionARCVEnc();
			dRetencionARCVEnc dEncabezado = new dRetencionARCVEnc();
			encabezado = dEncabezado.BuscarRetencionARCVEnc(filtroDoc);
			return encabezado;
		}
	}
}
