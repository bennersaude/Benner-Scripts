// ==UserScript==
// @name         Benner - Detalhes SMS por PR
// @namespace    Benner
// @version      0.0.1
// @description  Detalhes SMS por PR
// @author       Hugo José Gonçalves
// @include      https://*github.com/pulls*
// @include      https://*github.com/*/pulls*
// @grant GM_addStyle
// @grant unsafeWindow
// @require      https://code.jquery.com/jquery-latest.js
// @run-at document-end
// @downloadURL  https://github.com/bennersaude/Benner-Scripts/raw/master/Tampermonkey/detalhes-sms-pull-request/BennerDetalhesSMSGithub.user.js
// ==/UserScript==

(function() {
    "use strict";

    var showSms = false;

    var sisconIco = "data:image/png;base64,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";

    function proccess(initialElement) {
        var issuesElements = $(initialElement).find("li[id^=issue]");
        for (var i = 0; i < issuesElements.length; i++) {
            var matches = issuesElements[i].outerHTML.match(/\".*?pull\/\d+\"/g);
            var pr = matches[0];

            var urlComplement = pr.replace(/\"/g, "");
            var fullUrl = "https://github.com" + urlComplement;
            $.get(fullUrl, proccessPR(fullUrl, issuesElements[i]));
        }
    }

    function proccessPR(fullUrl, issueElement) {
        var repoMatches = /([^\/]+)\/pull\/\d+/gi.exec(fullUrl);
        var repo = repoMatches && repoMatches.length > 1 ? repoMatches[1] : undefined;
        return function(pullRequestData) {
            var smsMatches = /from\n*.*SMS\/(\d+)/gmi.exec(pullRequestData);
            if (smsMatches && smsMatches.length > 1) {
                var sms = smsMatches[1];
                var newElementLocation = $(issueElement).children().children(".float-left:last");
                var sisconUrl = "https://siscon.benner.com.br/siscon/e/solicitacoes/Solicitacao.aspx?key=" + sms;
                var newElement = "<a target=\"_blank\" style=\"box-shadow: none;color: black;\" class=\"label v-align-text-top labelstyle-fc2929 linked-labelstyle-fc2929\" href=\"" + sisconUrl + "\"><img height=\"15px\" src=\"" + sisconIco + "\" />";
                if (showSms)
                    newElement += sms;
                newElement += "</a>";
                $(newElement).insertBefore(newElementLocation.children("div:last"));
            }
        };
    }

    function onlyUnique(value, index, self) {
        return self.indexOf(value) === index;
    }

    $(document).ready(function() {
        proccess($(document.body));
    });
})();