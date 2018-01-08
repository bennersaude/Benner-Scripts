// ==UserScript==
// @name         Botão Atualização Sistema
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Disponibiliza botão para atualização do sistema
// @author       José Carlos S. A. Tissei
// @include      http://localhost*/Account/Login?ReturnUrl=*
// @include      http://*/Conecta*/Account/Login?ReturnUrl=*
// @include      http://testeservicocloud.cloudapp.net/Account/Login?ReturnUrl=*
// @include      http://bennerconectateste.azurewebsites.net/Account/Login?ReturnUrl=*
// @grant        GM_addStyle
// @grant        GM_getResourceText
// @require      https://code.jquery.com/jquery-latest.js
// @downloadURL  https://github.com/bennersaude/Benner-Scripts/tree/master/Tampermonkey/Conecta/botao-atualizacao-sistema/botao-atualizacao-sistema.js
// @updateURL  https://github.com/bennersaude/Benner-Scripts/tree/master/Tampermonkey/Conecta/botao-atualizacao-sistema/botao-atualizacao-sistema.js
// ==/UserScript==

(function () {
    'use strict';

    $(document).ready(function () {
        var botaoVoltar = $("a[ng-href*=\"Account/Login\"]");

        if (!botaoVoltar.is(":visible")) return;

        var urlVoltar = botaoVoltar.attr("href");
        var urlAtualizacaoSistema = urlVoltar.replace("Account/Login", "AdmSistema/AtualizacoesSistema");
        var botaoAtualizacaoSistema = "<a ng-href=\"" + urlAtualizacaoSistema + "\" href=\"" + urlAtualizacaoSistema + "\"> <button type=\"button\" id=\"atualizacao-sistema-btn\" class=\"btn green\">Atualizar Sistema</button></a>";
        botaoVoltar.after(botaoAtualizacaoSistema);
    });
})();