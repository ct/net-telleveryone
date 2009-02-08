##############################################################################
# Net::TellEveryone - Central API to many status posting services
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone;

use Carp;
use strict;

use Moose;
use Net::TellEveryone::Webhooks;
our $VERSION = '1.00';

has servicelist => (
    isa     => 'ArrayRef',
    is      => 'ro',
    default => sub {
        qw(
          Webhooks
          Twitter
          Identica
          Laconica
          Email
          Friendfeed
          Irc
          Jabber
          Aim
          Yim
        );
    },
);

has services => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] },
);

has user => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { 1 },
);

has pass => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { 1 },
);

has message => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { 1 },
);

has ref_url => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { 1 },
);

has payload => (
    isa     => 'HashRef',
    is      => 'rw',
    default => sub { {} },
);

has url => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { '' },
);

has agent => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { "Net::TellEveryone/$Net::TellEveryone::VERSION (PERL)" },
);

sub notify {
    my $self = shift;

    foreach my $svc ( $self->services ) {
        my $class = "Net::TellEveryone::$svc";
        my $svc_obj    = $class->new(
            {
                url        => $self->url,
                agent      => $self->agent,
                payload    => $self->payload,
                nte_object => $self,
            }
        );
        $svc_obj->process;
    }
}

1;    # End of Net::TellEveryone
