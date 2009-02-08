##############################################################################
# Net::TellEveryone::IRC - IRC
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::IRC;

use Carp;
use strict;

use Moose;
use Net::IRC;

our $VERSION = '1.00';

has payload => (
    isa       => 'HashRef',
    is        => 'rw',
    lazy      => 1,
    default   => sub { {} },
    predicate => "has_payload",
);

has nte_object => (
    isa     => 'Net::TellEveryone',
    is      => 'ro',
    require => 1,
    weaken  => 1
);

sub process {
    my $self    = shift;
    my $payload = $self->{payload};

    my $irc = new Net::IRC;

    my $conn = $irc->newconn(
        Server   => $payload->{server},
        Port     => $payload->{port},
        Nick     => $payload->{nick},
        Ircname  => $self->nte_object->agent,
        Username => $payload->{nick},
    ) or carp "cant connect to irc server";

    $conn->{nteirc_obj} = $self;
    $conn->add_global_handler(376, \&on_connect);
    $irc->start;
}

sub on_connect {
    my $self    = shift;
    my $payload = $self->{nteirc_obj}->payload;

    $self->join( $payload->{channel}, $payload->{password} );
    $self->privmsg( $payload->{channel}, $payload->{message} );
    $self->part($payload->{channel});
    $self->disconnect;

}

1;
