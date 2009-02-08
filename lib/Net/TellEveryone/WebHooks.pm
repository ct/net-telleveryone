##############################################################################
# Net::TellEveryone::Webhooks - Webhooks
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::WebHooks;

use Carp;
use strict;

use Moose;
use Moose::Util::TypeConstraints;
use LWP::Useragent;
use JSON::Any;

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
    weaken =>
);

sub process {
    my $self = shift;

    my $ua = LWP::UserAgent->new();
    $ua->agent( $self->nte_object->agent );
    $ua->env_proxy;
    
    my $args = { "payload" => JSON::Any->objToJson( $self->payload->{content} ) };
    my $url = $self->payload->{url};

    my $req = $ua->post( $url, $args );
}

1;
