// ==UserScript==
// @name         Benner - Detalhes SMS por PR
// @namespace    Benner
// @version      0.0.4
// @description  Detalhes SMS por PR
// @author       Hugo José Gonçalves
// @include      https://siscon.benner.com.br/*BDSMSPR=1
// @include      https://*github.com*
// @grant GM_addStyle
// @grant unsafeWindow
// @require      https://code.jquery.com/jquery-latest.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/localforage/1.5.0/localforage.min.js
// @require      https://raw.githubusercontent.com/localForage/localForage-startsWith/f5f37f103b53cc84317c59edb38dc43033065740/dist/localforage-startswith.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/mousetrap/1.6.1/mousetrap.min.js
// @run-at document-end
// @downloadURL  https://github.com/bennersaude/Benner-Scripts/raw/master/Tampermonkey/detalhes-sms-pull-request/BennerDetalhesSMSGithub.user.js
// ==/UserScript==

(function() {
    "use strict";

    var internalScriptKey = "BDSMSPR";
    var dbPrefix = internalScriptKey + "_";

    var cacheDays = 7;
    var queryBeforehand = true;

    // DO NOT CHANGE
    // SISCON Token?
    var useToken = false;
    var ctl100_token_val = "wsMv7QB+un3vBt7uqPf943JQVGK5oNWy+74P5e86FWawSVKxWOWt4hAgHez/8VB3KUI8na455UXpjk5X1ZrqzRT3aFmtA/lzu8W6bVu91xk=";
    var sisconToken = "&p=1&vst=d5812344-c333-4b47-974d-b7eec54b5b35";
    var organizationName = "bennersaude";
    var uniqueUrlInternalToken = internalScriptKey + "=1";

    localforage.getItem(dbPrefix + 'queryBeforehand')
        .then(function(result) {
        queryBeforehand = result || queryBeforehand;
    });
    localforage.getItem(dbPrefix + 'cacheDays')
        .then(function(result) {
        cacheDays = result || cacheDays;
    });

    initConfiguration();
    clearOldItemsFromCache();

    var observers = [];
    var sisconIco = "data:image/png;base64,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";

    function proccess(initialElement) {
        var issuesElements = $(initialElement).find("li[id^=issue]");

        for (var i = 0; i < issuesElements.length; i++) {
            var issueElement = issuesElements[i];
            var newElementLocation = $(issueElement).children().children(".float-left:last");
            var addedAlready = newElementLocation.find(".hjg-sms-btn");
            if (addedAlready && addedAlready.length)
                return;

            var matches = issuesElements[i].outerHTML.match(/\".*?pull\/\d+\"/g);
            var pr = matches[0];

            var urlComplement = pr.replace(/\"/g, "");
            var fullUrl = "https://github.com" + urlComplement;

            proccessPRUrl(fullUrl, newElementLocation, function(newElementLocation, elementToAdd) {
                elementToAdd.insertBefore(newElementLocation.children("div:last"));
            });
        }
    }

    function proccessPRUrl(url, newElementLocation, cb) {
        generateElementToAdd(url, !queryBeforehand, function (elementToAdd) {
            cb(newElementLocation, elementToAdd);
        });
    }

    function fakeGet(url, cb) {
        cb(undefined);
    }

    function generateElementToAdd(url, cacheOnly, cb) {
        var repoMatches = /([^\/]+)\/pull\/\d+/gi.exec(url);
        var repo = repoMatches && repoMatches.length > 1 ? repoMatches[1] : undefined;

        var styleElement = "style=\"box-shadow: none;color: black!important;background-color:transparent!important;vertical-align:middle!important\"";
        var newElement = "<a target=\"_blank\" " + styleElement + " class=\"hjg-sms-btn label v-align-text-top labelstyle-fc2929 linked-labelstyle-fc2929\" href=\"#\"><img height=\"15px\" src=\"" + sisconIco + "\" /></a>";

        getLocationForPR(url, cacheOnly).then(function(newLocation) {
            var jqueryNewElement = $(newElement);
            jqueryNewElement.on("click", clickAction(url, newLocation));

            cb(jqueryNewElement);
        });
    }

    function clickAction(fullUrl, newLocation) {
        return function($event) {
            $event.preventDefault();

            var win = window.open("", '_blank');
            win.blur();

            if (!newLocation) {
                getLocationForPR(fullUrl, false)
                    .then(function(result) {

                    newLocation = result;
                    updateWindow(newLocation, win);
                });
            } else {
                updateWindow(newLocation, win);
            }
        };
    }

    function updateWindow(newLocation, win) {
        if (newLocation) {
            win.location.href = newLocation;
            win.focus();
        } else {
            alert("SMS não encontrada.");
            win.close();
        }
    }

    function getLocationForPR(fullUrl, cacheOnly) {
        cacheOnly = typeof cacheOnly === "undefined" ? true : cacheOnly;

        var dfd = $.Deferred();

        localforage.startsWith(dbPrefix + fullUrl)
            .then(function(results) {

            var result;

            for (var key in results) {
                if (results.hasOwnProperty(key)) {
                    result = results[key];
                    break;
                }
            }

            if (result) {
                dfd.resolve(result);
                return result;
            }

            if (cacheOnly) {
                dfd.resolve(undefined);
                return undefined;
            }

            $.get(fullUrl, function (pullRequestData) {
                var newLocation;

                var smsMatches = /from\n*.*(SMS|hotfix)\/(\d+)/gmi.exec(pullRequestData);
                if (smsMatches && smsMatches.length > 2) {
                    var sms = smsMatches[2];
                    newLocation = "https://siscon.benner.com.br/siscon/e/solicitacoes/Solicitacao.aspx?key=" + sms;
                    if (useToken)
                        newLocation += sisconToken + "&" + uniqueUrlInternalToken;
                }

                localforage.setItem(dbPrefix + fullUrl + "_" + new Date().getTime(), newLocation);
                dfd.resolve(newLocation);
            });
        });

        return dfd.promise();
    }

    function boxObserver(target) {
        target = target[0];
        if (!target) return undefined;

        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.addedNodes.length > 0) {
                    start();
                }
            });
        });

        var config = { attributes: false, childList: true, subtree: false, characterData: false };

        observer.observe(target, config);
        return observer;
    }


    function onlyUnique(value, index, self) {
        return self.indexOf(value) === index;
    }

    function clearOldItemsFromCache() {
        localforage.startsWith(dbPrefix)
            .then(function(results) {

            for (var key in results) {
                if (results.hasOwnProperty(key)) {
                    var keySplitted = key.split("_");
                    if (keySplitted.length > 2) {
                        var createTime = keySplitted[2];
                        var age = (new Date().getTime() - createTime) / (24 * 60 * 60 * 1000);
                        if (age > cacheDays) {
                            console.log("Removing cache too old: " + key + " - about " + age + " days old.");
                            localforage.removeItem(key);
                        }
                    }
                }
            }
        });
    }

    function initConfiguration() {
        Mousetrap.bind('down right up left c', function() {
            var trueMatchRegex = /^(y|yes|s|sim|t|true|v|verdadeiro)$/i;

            var cacheDaysPrompt = prompt("Cache expiration time (days)?", cacheDays);
            var t = parseFloat(cacheDaysPrompt);
            if (t) {
                localforage.setItem(dbPrefix + 'cacheDays', t);
                cacheDays = t;
            }

            var queryBeforehandPrompt = prompt("Query all PRs on page load? (Y/N)", queryBeforehand);
            if (queryBeforehandPrompt) {
                queryBeforehand = queryBeforehandPrompt.match(trueMatchRegex) ? true : false;
                localforage.setItem(dbPrefix + 'queryBeforehand', queryBeforehand);
            }
        });
    }

    function clearAndRegisterObservers() {
        for (var i = 0; i < observers.length; i++) {
            if (observers[i])
                observers[i].disconnect();
        }
        observers = [];

        var mainBox = $("div[role='main']");
        observers.push(boxObserver(mainBox));
        var bodyBox = $("#js-repo-pjax-container");
        observers.push(boxObserver(bodyBox));
    }

    function start() {
        var reSiscon = new RegExp("siscon\.benner\.com\.br.*" + uniqueUrlInternalToken, "gi");
        if (window.location.href.match(reSiscon)) {
            if (useToken)
                $("#ctl00___token").val(ctl100_token_val);
            return;
        }

        var rePull = new RegExp("\/" + organizationName + "\/.*\/pull\/", "gi");
        var rePulls = new RegExp("\/" + organizationName + "\/.*\/pulls", "gi");
        if (window.location.href.match(rePull)) {
            var newElementLocation = $(document.body).find(".gh-header-title");
            proccessPRUrl(window.location.href, newElementLocation, function(newElementLocation, elementToAdd) {
                newElementLocation.append(elementToAdd);
            });
        } else if (window.location.href.match(rePulls)) {
            proccess($(document.body));
        }

        clearAndRegisterObservers();
    }

    $(document).ready(function() {
        start();
    });
})();
