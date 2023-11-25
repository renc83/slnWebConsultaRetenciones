using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entities;
using Controller;
using System.IO;
using System.Data;
using Microsoft.Reporting.WebForms;

namespace WebConsultaRetenciones.Modulos
{
	public partial class Reporte : System.Web.UI.Page
	{
        Warning[] warnings;
        string[] streamIds;
        string contentType;
        string encoding;
        string extension;
        //private  Report rpt = new 
        protected void Page_Load(object sender, EventArgs e)
		{
            if (!IsPostBack)
            {
                Reportes();
            }
        }

        private void Reportes()
        {
            switch (Request["CodReporte"])
            {
                case "IVA":
                    GXlsRetencionIVA();
                    break;
                case "ISLR":
                    GXlsRetencionISLR();
                    break;
                case "MUN":
                    GXlsRetencionMunicipal();
                    break;
                case "ADIC":
                    GXlsRetencionAdicional();
                    break;
                case "ARCV":
                    //GXlsRetencionARCV();
                    GXlsRetencionARCV();
                    break;
                default:
                    GXlsListadoRetenciones();
                    break;
            }
        }

        private void GXlsListadoRetenciones()
        {
            List<eDocumentos> arreglo = new List<eDocumentos>();
            cListadoRetenciones retenciones = new cListadoRetenciones();
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.fechaDesde = Request["fechaDesde"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.fechaHasta = Request["fechaHasta"];
            filtroDoc.RIF = Request["RIF"];
            string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista

            arreglo = retenciones.ListadoRetenciones(filtroDoc);           

            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/Report1.rdlc");

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
            eReporteImagen Imagen = new eReporteImagen();

            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(), $"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
            Imagenes.Add(Imagen);

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            ReportDataSource reportDataSource = new ReportDataSource();
            // Must match the DataSet in the RDLC
            reportDataSource.Name = "DataRetenciones";
            reportDataSource.Value = arreglo;
            this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(reportDataSource);
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML") {
               // byte[] bytes = ReportVOG.LocalReport.Render(vExtension);
				byte[] bytes = ReportVOG.LocalReport.Render(vExtension, null
					, out contentType, out encoding, out extension, out streamIds, out warnings);
				//Download the RDLC Report in Word, Excel, PDF and Image formats.

				Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=RDLC." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }

        private void GXlsRetencionIVA()
        {
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.RIF = Request["RIF"];

            List<eRetencionIvaEnc> Encabezado = new List<eRetencionIvaEnc>();
            cRetencionIvaEnc cBuscaEnc = new cRetencionIvaEnc();
            Encabezado.Add(cBuscaEnc.BuscarRetencionIvaEnc(filtroDoc));

            List<eRetencionIvaDet> detalle = new List<eRetencionIvaDet>();
            cRetencionIvaDet cBuscaDet = new cRetencionIvaDet();
            detalle = cBuscaDet.BuscarRetencionIvaDet(filtroDoc);

            string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista  
            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/rptRetencionIVA.rdlc");

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
            eReporteImagen Imagen = new eReporteImagen();

            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(), $"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
            Imagenes.Add(Imagen);

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            // Must match the DataSet in the RDLC
            ReportDataSource rptDataEncabezado = new ReportDataSource();
            rptDataEncabezado.Name = "DataEncabezado";
            rptDataEncabezado.Value = Encabezado;
            ReportDataSource rptDataDetalle = new ReportDataSource();
            rptDataDetalle.Name = "DataDetalle";
            rptDataDetalle.Value = detalle;
            ReportDataSource rptDataImagen = new ReportDataSource();
            rptDataImagen.Name = "DataImagenes";
            rptDataImagen.Value = Imagenes;
            this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(rptDataEncabezado);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataDetalle);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataImagen);
            this.ReportVOG.LocalReport.EnableExternalImages = true;
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML")
            {
                string deviceInf = "<DeviceInfo><PageHeight>8.5in</PageHeight><PageWidth>11in</PageWidth></DeviceInfo>";
                byte[] bytes = ReportVOG.LocalReport.Render(vExtension, deviceInf
                    , out contentType, out encoding, out extension, out streamIds, out warnings);
                //Download the RDLC Report in Word, Excel, PDF and Image formats.
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=rptRetencionIVA." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }

        private void GXlsRetencionISLR()
        {
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.RIF = Request["RIF"];
            

            List<eRetencionISLREnc>  Encabezado = new List<eRetencionISLREnc>();
            cRetencionISLREnc cBuscaEnc = new cRetencionISLREnc();
            Encabezado.Add(cBuscaEnc.BuscarRetencionISLREnc(filtroDoc));

            List<eRetencionISLRDet> detalle = new List<eRetencionISLRDet>();
            cRetencionISLRDet cBuscaDet = new cRetencionISLRDet();
            detalle = cBuscaDet.BuscarRetencionISLRDet(filtroDoc);

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
			eReporteImagen Imagen = new eReporteImagen();
	
            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(),$"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
			Imagenes.Add(Imagen);

			string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista           


            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/rptRetencionISLR.rdlc");

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            // Must match the DataSet in the RDLC
            ReportDataSource rptDataEncabezado = new ReportDataSource();
            rptDataEncabezado.Name = "DataEncabezado";
            rptDataEncabezado.Value = Encabezado;
            ReportDataSource rptDataDetalle = new ReportDataSource();
            rptDataDetalle.Name = "DataDetalle";
            rptDataDetalle.Value = detalle;
			ReportDataSource rptDataImagen = new ReportDataSource();
			rptDataImagen.Name = "DataImagenes";
			rptDataImagen.Value = Imagenes;
			this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(rptDataEncabezado);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataDetalle);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataImagen);
            this.ReportVOG.LocalReport.EnableExternalImages = true;
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML")
            {
                string deviceInf = "<DeviceInfo><PageHeight>8.5in</PageHeight><PageWidth>11in</PageWidth></DeviceInfo>";
                byte[] bytes = ReportVOG.LocalReport.Render(vExtension, deviceInf
                    , out contentType, out encoding, out extension, out streamIds, out warnings);
                //Download the RDLC Report in Word, Excel, PDF and Image formats.
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=rptRetencionISLR." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }

        private void GXlsRetencionMunicipal()
        {
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.RIF = Request["RIF"];

            List<eRetencionAdicEnc> Encabezado = new List<eRetencionAdicEnc>();
            cRetencionAdicEnc cBuscaEnc = new cRetencionAdicEnc();
            Encabezado.Add(cBuscaEnc.BuscarRetencionAdicEnc(filtroDoc));

            List<eRetencionAdicDet> detalle = new List<eRetencionAdicDet>();
            cRetencionAdicDet cBuscaDet = new cRetencionAdicDet();
            detalle = cBuscaDet.BuscarRetencionAdicDet(filtroDoc);

            string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista    
            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/rptRetencionMunicipal.rdlc");

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
            eReporteImagen Imagen = new eReporteImagen();

            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(), $"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
            Imagenes.Add(Imagen);

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            // Must match the DataSet in the RDLC
            ReportDataSource rptDataEncabezado = new ReportDataSource();
            rptDataEncabezado.Name = "DataEncabezado";
            rptDataEncabezado.Value = Encabezado;
            ReportDataSource rptDataDetalle = new ReportDataSource();
            rptDataDetalle.Name = "DataDetalle";
            rptDataDetalle.Value = detalle;
            ReportDataSource rptDataImagen = new ReportDataSource();
            rptDataImagen.Name = "DataImagenes";
            rptDataImagen.Value = Imagenes;
            this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(rptDataEncabezado);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataDetalle);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataImagen);
            this.ReportVOG.LocalReport.EnableExternalImages = true;
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML")
            {
                string deviceInf = "<DeviceInfo><PageHeight>8.5in</PageHeight><PageWidth>11in</PageWidth></DeviceInfo>";
                byte[] bytes = ReportVOG.LocalReport.Render(vExtension, deviceInf
                    , out contentType, out encoding, out extension, out streamIds, out warnings);
                //Download the RDLC Report in Word, Excel, PDF and Image formats.
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=rptRetencionMunicipal." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }

        private void GXlsRetencionAdicional()
        {
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.RIF = Request["RIF"];

            List<eRetencionAdicEnc> Encabezado = new List<eRetencionAdicEnc>();
            cRetencionAdicEnc cBuscaEnc = new cRetencionAdicEnc();
            Encabezado.Add(cBuscaEnc.BuscarRetencionAdicEnc(filtroDoc));

            List<eRetencionAdicDet> detalle = new List<eRetencionAdicDet>();
            cRetencionAdicDet cBuscaDet = new cRetencionAdicDet();
            detalle = cBuscaDet.BuscarRetencionAdicDet(filtroDoc);

            string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista 
            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/rptRetencionAdicional.rdlc");

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
            eReporteImagen Imagen = new eReporteImagen();

            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(), $"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
            Imagenes.Add(Imagen);

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            // Must match the DataSet in the RDLC
            ReportDataSource rptDataEncabezado = new ReportDataSource();
            rptDataEncabezado.Name = "DataEncabezado";
            rptDataEncabezado.Value = Encabezado;
            ReportDataSource rptDataDetalle = new ReportDataSource();
            rptDataDetalle.Name = "DataDetalle";
            rptDataDetalle.Value = detalle;
            ReportDataSource rptDataImagen = new ReportDataSource();
            rptDataImagen.Name = "DataImagenes";
            rptDataImagen.Value = Imagenes;
            this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(rptDataEncabezado);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataDetalle);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataImagen);
            this.ReportVOG.LocalReport.EnableExternalImages = true;
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML")
            {
                string deviceInf = "<DeviceInfo><PageHeight>8.5in</PageHeight><PageWidth>11in</PageWidth></DeviceInfo>";
                byte[] bytes = ReportVOG.LocalReport.Render(vExtension, deviceInf
                    , out contentType, out encoding, out extension, out streamIds, out warnings);
                //Download the RDLC Report in Word, Excel, PDF and Image formats.
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=rptRetencionMunicipal." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }

        private void GXlsRetencionARCV()
        {
            eFiltroDocumentos filtroDoc = new eFiltroDocumentos();
            filtroDoc.Documento = Request["Documento"];
            filtroDoc.InterID = Request["InterID"];
            filtroDoc.RIF = Request["RIF"];

            List<eRetencionARCVEnc> Encabezado = new List<eRetencionARCVEnc>();
            
            cRetencionARCVEnc cBuscaEnc = new cRetencionARCVEnc();
            Encabezado.Add(cBuscaEnc.BuscarRetencionARCVEnc(filtroDoc));

            List<eRetencionARCVDet> detalle = new List<eRetencionARCVDet>();
            cRetencionARCVDet cBuscaDet = new cRetencionARCVDet();
            detalle = cBuscaDet.BuscarRetencionARCVDet(filtroDoc);


            string vExtension = Request["Extension"]; //Word,Excel,PDF,Image --html es vista
            string stRutaFisica = Server.MapPath("~/Local_Resources/Reportes/rptRetencionARCV.rdlc");

            string imagenfirma = Request["Firma"];
            List<eReporteImagen> Imagenes = new List<eReporteImagen>();
            eReporteImagen Imagen = new eReporteImagen();

            string _PathUrl = String.Concat(Request.Url.Scheme.ToString(), $"://", Request.Url.Authority.ToString(), "/Local_Resources/Images/", imagenfirma);
            Imagen.FirmaReporte = _PathUrl;
            Imagen.LogoReporte = Server.MapPath("~/Local_Resources/Images/ReportesFirma.png");
            Imagenes.Add(Imagen);

            this.ReportVOG.Reset();
            this.ReportVOG.ProcessingMode = ProcessingMode.Local;
            this.ReportVOG.LocalReport.ReportPath = stRutaFisica;
            // Must match the DataSet in the RDLC
            ReportDataSource rptDataEncabezado = new ReportDataSource();
            rptDataEncabezado.Name = "DataEncabezado";
            rptDataEncabezado.Value = Encabezado;
            ReportDataSource rptDataDetalle = new ReportDataSource();
            rptDataDetalle.Name = "DataDetalle";
            rptDataDetalle.Value = detalle;
            ReportDataSource rptDataImagen = new ReportDataSource();
            rptDataImagen.Name = "DataImagenes";
            rptDataImagen.Value = Imagenes;
            this.ReportVOG.LocalReport.DataSources.Clear();
            this.ReportVOG.LocalReport.DataSources.Add(rptDataEncabezado);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataDetalle);
            this.ReportVOG.LocalReport.DataSources.Add(rptDataImagen);
            this.ReportVOG.LocalReport.EnableExternalImages = true;
            this.ReportVOG.LocalReport.Refresh();


            if (vExtension != "HTML")
            {
                string deviceInf = "<DeviceInfo><PageHeight>8.5in</PageHeight><PageWidth>11in</PageWidth></DeviceInfo>";
                byte[] bytes = ReportVOG.LocalReport.Render(vExtension, deviceInf
                    , out contentType, out encoding, out extension, out streamIds, out warnings);
                //Download the RDLC Report in Word, Excel, PDF and Image formats.
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = contentType;
                Response.AppendHeader("Content-Disposition", "attachment; filename=rptRetencionARCV." + extension);
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }


        private byte[] GetStreamAsByteArray(System.IO.Stream stream)
        {
            int streamLength = Convert.ToInt32(stream.Length);
            byte[] fileData = new byte[streamLength];
            stream.Read(fileData, 0, streamLength);
            stream.Close();
            return fileData;
        }

    }
}