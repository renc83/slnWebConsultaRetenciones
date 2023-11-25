var pagina = 1;

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

    $("#fechaDesde").val(today);
    $("#fechaHasta").val(today);
    BuscaEmpresasRif("RIF");

});



function BuscaEmpresasRif(RIF) {
    var sRIF = document.getElementById("lblRIF").textContent;
    $.ajax({
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        url: ("../Servicios/sUsuarios.asmx/BuscaEmpresasRif"),
        data: '{ "RIF":"' + sRIF + '" }',
        dataType: "json",
        success: function (dataObject, textStatus) {
            if (textStatus === "success") {
                var result = dataObject.d;
                if (result.length == 0) {
                    llenaComboEmpresas(result)
                } else {                  
                    llenaComboEmpresas(result);
                }
            }
        }
    });
}

function llenaComboEmpresas(listEmpresas) {
    var combohtml = document.getElementById("idEmpresas");
    var container = "";
    var fin = listEmpresas.length;
    container = " <select class='form-control' id='cmbEmpresas' name='cmbEmpresas'>";
    if (listEmpresas.length > 0) {
        for (var i = 0; i < fin; i++) {
            container += "<option value=" + listEmpresas[i].INTERID + ">" + listEmpresas[i].CMPANYID + "</option>";
        }
    } else {
        container += "<option value=ERROR>NO SE PUDIERON CARGAR LAS EMPRESAS</option>";
    }
    container += "</select>";
    combohtml.innerHTML = container;
}

function AbrirConsultar() {
    oEmpresa=document.getElementById("cmbEmpresas");
    sEmpresa = oEmpresa.value;
    sNombreEmpresa = oEmpresa.options[oEmpresa.selectedIndex].text;
    var strURL = "pgConsultaRetenciones.aspx?INTERID=" + sEmpresa;
    localStorage.setItem('INTERID', sEmpresa);
    localStorage.setItem('COMPANY', sNombreEmpresa);
    window.location.assign(strURL);
}