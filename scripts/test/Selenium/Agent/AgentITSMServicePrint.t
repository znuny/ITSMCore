# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
                }
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable PDF output
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PDF',
            Value => 0
        );

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-service' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test service
        my $ServiceName = "Service" . $Helper->GetRandomID();
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name        => $ServiceName,
            ValidID     => 1,
            Comment     => 'Selenium Test Service',
            UserID      => 1,
            TypeID      => 2,
            Criticality => '3 normal',
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentITSMServiceZoom screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentITSMServiceZoom;ServiceID=$ServiceID");

        # click on print
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentITSMServicePrint;ServiceID=$ServiceID\' )]");

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check for printed values of test service
        $Self->True(
            index( $Selenium->get_page_source(), "Service: $ServiceName" ) > -1,
            "Service: $ServiceName - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Operational" ) > -1,
            "Current Incident: Operational - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "3 normal" ) > -1,
            "Criticality: 3 normal - found",
        );

        # delete test service
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Deleted Service - $ServiceID",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Service'
        );

        }
);

1;
