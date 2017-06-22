// ==UserScript==
// @name         Botão Pull Request Para SMS
// @namespace    Benner.Saude
// @version      1.0
// @description  Adiciona botão para pull request da SMS
// @author       José Carlos S. A. Tissei
// @include      https://siscon.benner.com.br/siscon/e/solicitacoes/Solicitacao.aspx*
// @updateURL    https://github.com/bennersaude/Benner-Scripts/raw/master/Tampermonkey/botao-pull-request/BotaoPullRequest.user.js
// @grant GM_addStyle
// @run-at document-end
// ==/UserScript==

(function() {  
    function pesquisarPullRequest () {
        var regex = new RegExp(/key=([0-9]+)/g);
        var numeroSms = regex.exec(window.location.href)[1];
        var linkPullRequest = "https://github.com/pulls?utf8=%E2%9C%93&q=is%3Apr+" + numeroSms + "+user%3Abennersaude";
        
        return "window.open('"+linkPullRequest+"', '_blank');";
    };
    
    function montarBotaoPullRequest () {      
        var botoes = document.getElementById("ctl00_Main_ucSolicitacao_WIDGETID_FORMSOLICITACAO_toolbar");
        var icone = "<i class=\"fa fa-code-fork btn-action\"></i>";
        var botao = "<a id=\"botao-pull-request\" href=\"javascript:" + pesquisarPullRequest() + "\" class=\"btn command-action custom-action blue\">" + icone + "</a>";
        botoes.innerHTML = botao + botoes.innerHTML;
    }

    $(document).ready(function() {
        montarBotaoPullRequest();
    });
})();
