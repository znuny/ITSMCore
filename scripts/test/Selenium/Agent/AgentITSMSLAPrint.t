# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

if ( $Selenium->{browser_name} ne 'firefox' ) {
    $Self->True(
        1,
        'PDF test currently supports Firefox only'
    );
    return 1;
}

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-service' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test SLA
        my $SLAName = "SLA" . $Helper->GetRandomID();
        my $SLAID   = $Kernel::OM->Get('Kernel::System::SLA')->SLAAdd(
            Name              => $SLAName,
            ValidID           => 1,
            FirstResponseTime => 120,
            UpdateTime        => 180,
            SolutionTime      => 580,
            Comment           => 'Selenium test SLA',
            TypeID            => 2,
            UserID            => 1,
        );
        $Self->True(
            $SLAID,
            "SLA is created - ID $SLAID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentITSMSLAZoom screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMSLAZoom;SLAID=$SLAID");

        # click on print menu
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMSLAPrint;SLAID=$SLAID\' )]")->click();

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until print screen is loaded
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( index( $Selenium->get_page_source(), "printed by" ) > -1, ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

        # check for printed values of test SLA
        $Self->True(
            index( $Selenium->get_page_source(), "$SLAName" ) > -1,
            "Service: $SLAName - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Calendar Default" ) > -1,
            "Calendar: Calendar Default - found",
        );

        my @RespondTime = ( 120, 180, 580 );
        for my $Time (@RespondTime) {
            $Self->True(
                index( $Selenium->get_page_source(), $Time . " minutes" ) > -1,
                "Respond $Time minutes - found",
            );
        }

        # delete test SLA
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM sla WHERE id = $SLAID",
        );
        $Self->True(
            $Success,
            "SLA is deleted - ID $SLAID",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'SLA'
        );
    }
);

1;
