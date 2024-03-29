// --
// Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
// Copyright (C) 2021 Znuny GmbH, https://znuny.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};


/**
 * @namespace Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module behaviours for ITSM Service.
 */
 ITSM.Agent.Service = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Agent.Service
     * @function
     * @description
     *      This function initializes actions for ITSM Service.
     */
    TargetNS.Init = function() {

        Core.UI.Table.InitTableFilter($('#Filter'), $('#Services'));

        $('.MasterAction').bind('click', function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.Service || {}));
