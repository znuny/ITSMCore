# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentITSMService;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {%Param},
    );

    $LayoutObject->Block( Name => 'Filter' );

    # get service list
    my $ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceListGet(
        UserID => $Self->{UserID},
    );

    # set incident signal
    my %InciSignals = (
        Translatable('operational') => 'greenled',
        Translatable('warning')     => 'yellowled',
        Translatable('incident')    => 'redled',
    );

    if ( @{$ServiceList} ) {

        # sort the service list by long service name
        @{$ServiceList} = sort { $a->{Name} . '::' cmp $b->{Name} . '::' } @{$ServiceList};

        for my $ServiceData ( @{$ServiceList} ) {

            # output overview row
            $LayoutObject->Block(
                Name => 'OverviewRow',
                Data => {
                    %{$ServiceData},
                    Name          => $ServiceData->{Name},
                    CurInciSignal => $InciSignals{ $ServiceData->{CurInciStateType} },
                    State         => $ServiceData->{CurInciStateType},
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );
    }

    # investigate refresh
    my $Refresh = $Self->{UserRefreshTime} ? 60 * $Self->{UserRefreshTime} : undef;

    # output header
    my $Output = $LayoutObject->Header(
        Title   => 'Overview',
        Refresh => $Refresh,
    );
    $Output .= $LayoutObject->NavigationBar();

    # generate output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentITSMService',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
