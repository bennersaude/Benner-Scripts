// ==UserScript==
// @name         Melhoria tela de situações do SISCON
// @namespace    SISCON
// @version      1.0
// @description  Retira os font-icons das situações e algumas colunas desnecessárias no grid do SISCON
// @author       Equipe WEB
// @match        https://siscon.benner.com.br/siscon/e/*olicitacoes/Consultar.aspx*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    var ScriptSiscon = {
        quantidadeMaximaAceita: 4,
        removerColunaTabela: function (indiceColuna) {
            $('thead th:nth-child(' + indiceColuna + ')').remove();
            $('tbody td:nth-child(' + indiceColuna + ')').remove();
        },
        alterarSituacao: function (seletor, conteudo) {
            $('td[title*="' + seletor + '"]').html(conteudo);
        },
        incluirLabelSituacao: function () {
            $('tbody > tr > td.text-center[title]').each(function (indice, item) { $(item).append($(item).attr('title')); });
        },
        inserirBadgeNoTitulo: function () {
            var arraySituacoes = [];

            $('td.text-center[title]').each(function (index, value) {
                if (arraySituacoes[$(this).attr('title')] === undefined) arraySituacoes[$(this).attr('title')] = 0;

                arraySituacoes[$(this).attr('title')] += 1;
            });

            for (var item in arraySituacoes) {
                $('.portlet-title > .caption').append(' - <span class="caption-helper">' + item + ' <span class="badge badge-primary"> ' + arraySituacoes[item] + ' </span></span>');

                if (arraySituacoes[item] >= ScriptSiscon.quantidadeMaximaAceita)
                    ScriptSiscon.notificar("ATENÇÃO:  SMS na situação " + item + "(" + arraySituacoes[item] + ") estão acumulando, verifique!");
            }
        },
        notificar: function (mensagem) {
            if (Notification.permission !== "granted")
                Notification.requestPermission();
            else {
                var notification = new Notification('Siscon', {
                    icon: 'http://www.freeiconspng.com/uploads/alert-icon-23.png',
                    body: mensagem,
                });

                notification.onclick = function () {
                    window.open("https://siscon.benner.com.br/siscon/e/solicitacoes/Consultar.aspx");
                };
            }
        }
    };

    /* Removendo colunas desnecessárias */
    ScriptSiscon.removerColunaTabela(9);
    ScriptSiscon.removerColunaTabela(7);
    ScriptSiscon.removerColunaTabela(3);

    /* Alterando situações */
    ScriptSiscon.incluirLabelSituacao();
    ScriptSiscon.inserirBadgeNoTitulo();
})();