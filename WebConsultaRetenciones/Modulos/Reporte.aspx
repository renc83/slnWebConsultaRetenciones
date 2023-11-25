<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="WebConsultaRetenciones.Modulos.Reporte" %>


<%@ Register Assembly="Microsoft.ReportViewer.WebForms" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <div style="height:100%">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <rsweb:ReportViewer ID="ReportVOG" runat="server" BackColor="" ClientIDMode="AutoID" Width="100%" Height="600px" >
            <LocalReport ReportPath="Reporte.rdlc" EnableExternalImages="True" EnableHyperlinks="True">
            </LocalReport>
        </rsweb:ReportViewer>
    </form>
    </div>
</body>
</html>
