// ==UserScript==
// @name         Liberar Uniben
// @namespace    Benner.saude
// @version      0.1
// @description  Botão que abre o cliente de email com texto padrão e pessoas para solicitação de Liberação da Uniben
// @author       Bruno Fernandes
// @include      https://siscon.benner.com.br/siscon/e/solicitacoes/Atendimento.aspx*
// @include      https://siscon.benner.com.br/siscon/e/solicitacoes/Solicitacao.aspx*
// @grant        none
// @run-at document-end
// ==/UserScript==

(function() {

    function sendMail() {
        var host = "CWB-BRUNO"                                                           // Alterar aqui seu host para liberação
        if (host == "Não Definido"){ alert("Defina seu HOST no script \"Liberar Uniben\"") };
        var regex = new RegExp(/key=([0-9]+)/g);
        var numeroSms = regex.exec(window.location.href)[1];
        var saudacao = "Boa noite!"
        if (new Date().getHours() < 12){saudacao = "Bom dia!"}
           else if (new Date().getHours() >= 12 && new Date().getHours() < 19) {saudacao = "Boa tarde!"}
        var link = "mailto:alexiades.scalfo@unimedcuritiba.com.br;pereira@unimedcuritiba.com.br;claudemir.souza@unimedcuritiba.com.br;"
             + "?&subject=" + escape("Liberar UNIBEN")
             + "&body=" + escape(saudacao + "%0D%0A%0D%0A" + host + "%0D%0ASMS " + numeroSms + "%0D%0A%0D%0AAtenciosamente,")
        ;

        return "window.open('" + link + "', '_self'); ";
}

    function montarBotaoLiberarUniben() {
        var botoes = document.getElementById("ctl00_Main_ucAtendimento_WIDGETID_FORMATENDIMENTO_toolbar");     //Protocolo
        if (botoes == null){
           botoes = document.getElementById("ctl00_Main_ucSolicitacao_WIDGETID_COMANDOS_SOLICITACAO_toolbar"); //SMS
        }
        var icone = "<i class=\"fa fa-mail-forward btn-action\"></i>";
        var botao = "<a id=\"botao-liberar-uniben\" href=\"javascript:" + sendMail() + "\" class=\"btn command-action custom-action blue\" title=\"Liberar UNIBEN\" >" + icone + " </a>";
        botoes.innerHTML = botoes.innerHTML + botao;
    }

    $(document).ready(function () {
        montarBotaoLiberarUniben();
        window.close();
    });
})();