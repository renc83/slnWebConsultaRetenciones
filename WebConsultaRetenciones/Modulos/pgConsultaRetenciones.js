var DataSettbl = new Array();

$(document).ready(function () {
    var now = new Date();
    var before = new Date();
    before.setDate(before.getDate() - 1);
    var day = ("0" + before.getDate()).slice(-2);
    var month = ("0" + (before.getMonth() + 1)).slice(-2);
    var beforetoday = before.getFullYear() + "-" + (month) + "-" + (day);

    day = ("0" + now.getDate()).slice(-2);
    month = ("0" + (now.getMonth() + 1)).slice(-2);
    today = now.getFullYear() + "-" + (month) + "-" + (day);

    $("#fechaDesde").val(beforetoday);
    $("#fechaHasta").val(today);


    sNombreEmpresa = localStorage.getItem("COMPANY");
    document.getElementById('lblCOMPANY').innerText ="Empresa:" + sNombreEmpresa

    $('#tblDocumentos').DataTable(
        {
            data: DataSettbl,
            paging: true,
            columns: [
                { title: '#' },
                { title: 'Nro. Documento' },
                { title: 'Fecha Documento' },
                { title: 'Fecha Registro.' },
                { title: '% de Retencion' },
                { title: 'Tipo' },
                { title: 'Eventos' }
            ],
        }
    );
    Buscar();
    CargarImagen();

});

function Buscar() {
    var vfechadesde = document.getElementById("fechaDesde").value;
    vfechadesde = vfechadesde.replace(/-/g, "");
    var vfechahasta = document.getElementById("fechaHasta").value;
    vfechahasta = vfechahasta.replace(/-/g, "");
    var documento = document.getElementById("txtNroDocumento").value;
    var rif = document.getElementById('lblRIF').innerText
    var company = document.getElementById('lblINTERID').innerText
    var vARCV = 0;
    if (document.getElementById("flexSwitchCheckARC").checked) {
        vARCV = 1;
    }

    var data = {
        filtrodocumento: {
            "fechaDesde": vfechadesde,
            "fechaHasta": vfechahasta,
            "RIF": rif,
            "InterID": company,
            "Documento": documento,
            "ARCV": vARCV
        }
    }

    $.ajax({
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        url: ("../Servicios/ConsultaRetenciones.asmx/ListadoRetenciones"),
        data: JSON.stringify(data),
        dataType: "json",
        success: function (dataObject, textStatus) {
            if (textStatus === "success") {
                var result = dataObject.d;
                LlenarTabla(result)
            }
        }
    });
}

function LlenarTabla(listadoarreglo) {
    var rif = document.getElementById('lblRIF').innerText

    $('#tblDocumentos').DataTable().clear();
    $('#tblDocumentos').DataTable().destroy();

    var DataSettbl = new Array();
    for (var i = 0; i < listadoarreglo.length; i++) {
        vfechadoc = (listadoarreglo[i].fechadocumento).substring(0, 10);
        vfechacon = (listadoarreglo[i].fecharegistro).substring(0, 10);
        sdocumento = listadoarreglo[i].nrodocumento.trim();
        if (listadoarreglo[i].tipo == "MUN") {
            botonPDF = "<div class='dropdown'><Button type='button' class='btn btn-danger btn-xs'><a><i class='fa fa-file-pdf'></i></a></button><div class='dropdown-content'>"+
                "<a href='#' nrodoc='" + sdocumento + "' onclick='PDFMun(this)'>Municipal</a>" +
                "<a href='#' nrodoc='" + sdocumento + "' onclick='PDFAdi(this)'>Adicional</a>  </div></div >"
            botonHtml = "<div class='dropdown'><Button type='button' class='btn btn-success btn-xs'><a><i class='fa fa-file-code'></i></a></button><div class='dropdown-content'>" +
                "<a href='#' nrodoc='" + sdocumento + "' onclick='HTMLMun(this)'>Municipal</a>" +
                "<a href='#' nrodoc='" + sdocumento + "' onclick='HTMLAdi(this)'>Adicional</a>  </div></div >"

        } else {
            botonPDF = "<Button type='button' ID='PDF" + sdocumento + "' nrodoc='" + sdocumento + "' tiporep='" + listadoarreglo[i].tipo + "'  class='btn btn-danger btn-xs' OnClick='documentoPDF(this)'><a><i class='fa fa-file-pdf'></i></a></button>";
            botonHtml = "<Button type='button' ID='Html" + sdocumento + "' nrodoc='" + sdocumento + "' tiporep='" + listadoarreglo[i].tipo + "'  class='btn btn-success btn-xs' OnClick='documentoHtml(this)'><a><i class='fa fa-file-code'></i></a></button>";
        }
       let prueba = [listadoarreglo[i].id, sdocumento, vfechadoc, vfechacon
            , listadoarreglo[i].alicuota, listadoarreglo[i].tipo
            , botonPDF +" "+ botonHtml
        ];
        DataSettbl.push(prueba);
    }


    $('#tblDocumentos').DataTable(
        {
            data: DataSettbl,
            paging: true,
            lengthMenu: [10, 20, 100],
            columns: [
                { title: '#' },
                { title: 'Nro. Documento' },
                { title: 'Fecha Documento' },
                { title: 'Fecha Registro.' },
                { title: '% de Retencion' },
                { title: 'Tipo' },
                { title: 'Eventos' }
            ],
            language: {
                info: 'Mostrando _START_ a _END_ de _TOTAL_ registros',
                infoFiltered: "(filtrado de un total de _MAX_ registros)",
                infoEmpty: 'No existen Registros',
                decimal: '.',
                search: "Buscar:",
                thousands: ',',
                infoFiltered: '(filtered from _MAX_ total records)',
                lengthMenu: 'Registros _MENU_ por Pagina',
                zeroRecords: 'No existen Registros para el Filtro',
                paginate: {
                    first: "Primero",
                    previous: "Anterior",
                    next: "Siguiente",
                    last: "Ultimo"
                },
            }
        }
    );
}

function Reporte(documento, tiporeporte, extension) {
    var vfechadesde = document.getElementById("fechaDesde").value;
    vfechadesde = vfechadesde.replace(/-/g, "");
    var vfechahasta = document.getElementById("fechaHasta").value;
    vfechahasta = vfechahasta.replace(/-/g, "");
    var rif = document.getElementById('lblRIF').innerText
    var company = document.getElementById('lblINTERID').innerText
    var vfirma = document.getElementById("sFirmaReporte").value;

    tituloPopUp = "Listado de Recibos";
    rptURL = "Reporte.aspx";
    rptURL = rptURL + "?";
    rptURL = rptURL + "CodReporte=" + tiporeporte + '&';
    rptURL = rptURL + "fechaDesde=" + vfechadesde + '&';
    rptURL = rptURL + "fechaHasta=" + vfechahasta + '&';
    rptURL = rptURL + "RIF=" + rif + '&';
    rptURL = rptURL + "InterID=" + company + '&';
    rptURL = rptURL + "Documento=" + documento + '&';
    rptURL = rptURL + "Extension=" + extension + '&';
    rptURL = rptURL + "Firma=" + vfirma + '&';

    var win = window.open(rptURL);
    win.onload = function () {
        setTimeout(function () {
            $(win.document).find("html").append("<head><title>" + tituloPopUp + "</title></head>");
        }, 700);
    }
}


function documentoPDF(oDocumento) {
    var documento = oDocumento.getAttribute("nrodoc");
    var tiporeporte = oDocumento.getAttribute("tiporep");
    Reporte(documento, tiporeporte, "PDF");
}

function documentoHtml(oDocumento) {
    var documento = oDocumento.getAttribute("nrodoc");
    var tiporeporte = oDocumento.getAttribute("tiporep");
    Reporte(documento, tiporeporte, "HTML");
}

//municipal y adicional
function PDFMun(oDocumento) {
    var tiporeporte = "MUN";
    var documento = oDocumento.getAttribute("nrodoc");
    Reporte(documento, tiporeporte, "PDF");
}
function PDFAdi(oDocumento) {
    var tiporeporte = "ADIC";
    var documento = oDocumento.getAttribute("nrodoc");
    Reporte(documento, tiporeporte, "PDF");
}
function HTMLMun(oDocumento) {
    var tiporeporte = "MUN";
    var documento = oDocumento.getAttribute("nrodoc");
    Reporte(documento, tiporeporte, "HTML");
}
function HTMLAdi(oDocumento) {
    var tiporeporte = "ADIC";
    var documento = oDocumento.getAttribute("nrodoc");
    Reporte(documento, tiporeporte, "HTML");
}
//////      

function Limpiar() {
    var now = new Date();
    var before = new Date();
    before.setDate(before.getDate() - 1);
    var day = ("0" + before.getDate()).slice(-2);
    var month = ("0" + (before.getMonth() + 1)).slice(-2);
    var beforetoday = before.getFullYear() + "-" + (month) + "-" + (day);

    day = ("0" + now.getDate()).slice(-2);
    month = ("0" + (now.getMonth() + 1)).slice(-2);
    today = now.getFullYear() + "-" + (month) + "-" + (day);

    $("#fechaDesde").val(beforetoday);
    $("#fechaHasta").val(today);
    $("#txtNroDocumento").val("");
    Buscar();
}

function CargarImagen() {
    var arrayImagenes = [];
    var arrayindexImagenes = [];
    var comp = document.getElementById('lblINTERID').innerText

    var imagenHeader = document.getElementById("imagenlogo");
    var container = "<img src='../ Local_Resources / Images / VOG - logo - emp.png' height='100px'>";

    $.getJSON("ConfigImagenes.json?" + Math.random(), function (json) {
        txjson = json
        for (var x in json.Imagenes) {
            arrayImagenes.push({
                "empresa": txjson.Imagenes[x].Empresa,
                "firma": txjson.Imagenes[x].Firma,
                "logo": txjson.Imagenes[x].Logo
            });
            arrayindexImagenes.push(
                txjson.Imagenes[x].Empresa
            );
        }

        var id = arrayindexImagenes.indexOf(comp.toUpperCase());
        if (id > -1) {
            sfirma = arrayImagenes[id].firma
            container = "<img src='../Local_Resources/Images/" + arrayImagenes[id].logo+"' height='100px'>";
        } else {
            sfirma = "ReportesFirma.png"
            container = "<img src='../Local_Resources/Images/VOG-logo-emp.png' height='100px'>";
        }
        document.getElementById("sFirmaReporte").value = sfirma;
        imagenHeader.innerHTML = container;
    });
 

}

