<%@ Page Title="Consulta de Retenciones" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="pgConsultaRetenciones.aspx.cs" Inherits="WebConsultaRetenciones.Modulos.pgConsultaRetenciones" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div> 
        <div class="col-sm-12 col-m-12">
            <h6 >Proveedor: <%= F_Usuario() %> - <%= F_Nombre_Usuario() %></h6>
            <h6 id="lblRIF" hidden><%= F_Usuario() %></h6>
        </div>
        <hr />
        <div class="col-sm-12 col-m-12">
           <h6 id="lblCOMPANY">EMPRESA</h6>
            <h6 id="lblINTERID" hidden><%=F_IDEmpresa()%></h6>
        </div>
    </div>

        <hr />
        <input class="form-control" id="sFirmaReporte" type="text" value="" hidden>

   <section id="filtros">
        <div class="row">
            <div class="col-md-2 col-sm-6">
                <input class="form-control" id="fechaDesde" type="date" value="">
            </div>
            <div class="col-md-2 col-sm-6">
                <input class="form-control" id="fechaHasta" type="date" value="">
            </div>
            <div class="col-md-2 col-sm-6">
                <input type="text" placeholder="Nro Documento" class="form-control" id="txtNroDocumento" />
            </div>
            <div class="form-check form-switch col-md-2 col-sm-6">
                  <input class="form-check-input" type="checkbox" id="flexSwitchCheckARC">
                  <label class="form-check-label" for="flexSwitchCheckARC">ARCV</label>
            </div>
            <div class="col-md-2 col-sm-6">
                <div class="input-group mb-3">
                    <span class="input-group-btn">
                        <button class="btn btn-primary" type="button" onclick="Buscar(1);"><i class="fa fa-search"></i></button>
                    </span>
                    <span class="input-group-btn" style="padding-left:5px">
                        <button class="btn btn-primary" type="button" onclick="Limpiar();"><i class="fa fa-eraser"></i></button>
                    </span>
                </div>
            </div>
        </div>
    </section>

    <section>
        <div>
            <table id="tblDocumentos" class="display">

              </table>
            </div>
    </section>
        <script src="pgConsultaRetenciones.js"></script>
</asp:Content>
