<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pruebas.aspx.cs" Inherits="WebConsultaRetenciones.Pruebas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
   <!-- Bootstrap 4 -->
    <script src="/Scripts/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="/Scripts/plugins/bootstrap/css/bootstrap.css" rel="stylesheet" />

    <style>
        /* Estilos para el dropdown button */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f1f1f1;
            min-width: 120px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }
    </style>

</head>
<body>

                <div class="input-group-prepend show">
                    <button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                      Action
                    </button>
                    <ul class="dropdown-menu show" x-placement="top-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(0px, -165px, 0px);">
                      <li class="dropdown-item"><a href="#">Action</a></li>
                      <li class="dropdown-item"><a href="#">Another action</a></li>
                      <li class="dropdown-item"><a href="#">Something else here</a></li>
                      <li class="dropdown-divider"></li>
                      <li class="dropdown-item"><a href="#">Separated link</a></li>
                    </ul>
                  </div>

<div class="dropdown">
  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    Dropdown button
  </button>
  <div class="dropdown-content" aria-labelledby="dropdownMenuButton">
    <a class="dropdown-item" href="#">Action</a>
    <a class="dropdown-item" href="#">Another action</a>
    <a class="dropdown-item" href="#">Something else here</a>
  </div>
</div>
<hr />
        <div class="dropdown">
        <button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                      Action
                    </button>
        <div class="dropdown-content">
            <a href="#" onclick="opcionSeleccionada('opcion1')">Opción 1</a>
            <a href="#" onclick="opcionSeleccionada('opcion2')">Opción 2</a>
            <a href="#" onclick="opcionSeleccionada('opcion3')">Opción 3</a>
        </div>
    </div>

</body>
</html>
