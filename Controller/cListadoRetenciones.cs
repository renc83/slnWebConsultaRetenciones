using Entities;
using System.Collections.Generic;
using DataAccess;

namespace Controller
{
	public class cListadoRetenciones
	{
		public List<eDocumentos> ListadoRetenciones(eFiltroDocumentos filtrodocumento)
		{
			List<eDocumentos> documentos = new List<eDocumentos>();
			dListadoRetenciones listado = new dListadoRetenciones();
			dListadoRetencionesARCV listadoARCV = new dListadoRetencionesARCV();
			if (filtrodocumento.ARCV == 1)
			{
				documentos = listadoARCV.ListadoRetencionesARCV(filtrodocumento);
			}
			else { 
				documentos = listado.ListadoRetenciones(filtrodocumento);
			}
			return documentos;
		}
	}
}
