##############################################################################
# Net::TellEveryone::Twitter - Twitter
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::Twitter;

use Carp;
use strict;

use Moose;
use Net::Twitter

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

    my $t = Net::Twitter->new(
        username => $payload->{username},
        password => $payload->{password},
    );
    
    $t->update($payload->{message});

}

1;
