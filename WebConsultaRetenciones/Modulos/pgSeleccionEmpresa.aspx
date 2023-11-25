<%@ Page Title="Seleccionar Empresa" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="pgSeleccionEmpresa.aspx.cs" Inherits="WebConsultaRetenciones.Modulos.pgSeleccionEmpresa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-sm-12 col-m-12">
            <h6>Proveedor: <%= F_Usuario() %> : <%= F_Nombre_Usuario() %></h6>
            <h6 id="lblRIF" hidden><%= F_Usuario() %></h6>
        </div>
    <hr />
    </div>

    <div class="row">
        <div  class="seleccion-empresa"> 
            <div class="col-2">
            <strong>Seleccione la Empresa:</strong>
                </div>
            <div id="idEmpresas" class="col-6">
                <%-- se carga por JS --%>
            </div>
            <div class="col-2">
             
            </div>
            <div class="col-2">
               <button class="btn btn-primary" onclick="AbrirConsultar()">ACEPTAR</button>
            </div>
                

        </div>

    </div>



    <script src="pgSeleccionEmpresa.js"></script>
</asp:Content>
