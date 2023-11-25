<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CambioClave.aspx.cs" Inherits="WebConsultaRetenciones.CambioClave" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="./Local_Resources/Images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="./Scripts/css/styles.css">

    <!-- jQuery -->
    <script src="/Scripts/plugins/code.jquery.com_jquery-3.7.0.min.js"></script>
    <!-- Toast -->
    <link href="/Scripts/plugins/toastr/toastr.css" rel="stylesheet" />
    <script src="/Scripts/plugins/toastr/toastr.js"></script>
    <script src="./Scripts/js/sysfunctions.js"></script>
    <title>Inicio de Sesion</title>
</head>

<body class="bgg">
    <div class="wrapper">
        <div class="empresa">
        </div>
        <div id="formContent">
            <!-- Tabs Titles -->
            <h2 class="inactive underlineHover"><a href="./Login.aspx">Iniciar Sesion</a></h2>
            <h2 class="active"><a href="#">Cambio Contraseña</a></h2>
            <!-- Icon -->
            <div>
                <img src="./Local_Resources/Images/VOG-horiz-blue.png" height="40px">
                <br>
                <span>Comprobantes de Retención Online v1.0</span>
                <br>
            </div>

            <!-- Login Form -->
            <form id="login" runat="server">
                <asp:TextBox runat="server" class="form-control" ID="rifusuario" name="rifusuario" type="text" value=""
                    placeholder="Ingrese su RIF (J000000000)" MaxLength="10" onchange="ValidaRIF(this.value)" ReadOnly></asp:TextBox>
                <asp:TextBox runat="server" class="form-control" ID="clave" name="clave" type="password" value=""
                    placeholder="Ingrese su Contraseña" requeried> </asp:TextBox>
                <asp:TextBox runat="server" class="form-control" ID="reclave" name="reclave" type="password" value=""
                    placeholder="Repita su Contraseña" requeried> </asp:TextBox>
                <asp:Button ID="btnActualiza" runat="server" class="btn btn-primary btn-m" Text="Actualizar" OnClick="btnActualiza_Click" />
                <!-- Remind Passowrd -->
                <div id="formFooter">
                    <img src="./Local_Resources/Images/MS Dynamics.jpg" height="45px">
                    <br>
                </div>
            </form>
        </div>
    </div>

</body>

</html>


