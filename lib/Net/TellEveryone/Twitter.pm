##############################################################################
# Net::TellEveryone::Twitter - Twitter
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::Twitter;

use Carp;
use strict;

use Moose;
use Moose::Util::TypeConstraints;
use Net::Twitter

our $VERSION = '1.00';

has url => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { '' },
);

has payload => (
    isa     => 'JSON',
    coerce  => 1,
    is      => 'rw',
    default => sub { '{ "payload": "0"}' },
);

has agent => (
    isa     => 'Str',
    is      => 'rw',
);

has nte_object => (
    isa => 'Net::TellEveryone',
    is  => 'ro',
    require => 1,
    weaken =>
);

sub process {
    my $self = shift;
    
    carp 'process';

    my $ua = LWP::UserAgent->new();
    $ua->agent( $self->agent );
    $ua->env_proxy;

    my $req = $ua->post(
        $self->url,
        {
            payload => $self->payload,
            user    => $self->nte_object->user,
            message => $self->nte_object->message,
            ref_url => $self->nte_object->ref_url,
        }
    );

}

1;