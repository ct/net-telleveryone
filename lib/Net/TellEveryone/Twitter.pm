##############################################################################
# Net::TellEveryone::Twitter - Twitter
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::Twitter;

use Carp;
use strict;

use Moose;
use Net::Twitter;

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
    required => 1,
    weaken  => 1
);

sub process {
    my $self    = shift;
    my $payload = $self->{payload};
    warn "begin twitter processing";

    my $t = Net::Twitter->new(
        username => $payload->{username},
        password => $payload->{password},
    );

    if ((defined $payload->{identica}) and ($payload->{identica})) {
        $t->{apiurl}   = 'http://identi.ca/api';
        $t->{apihost}  = 'identi.ca:80';
        $t->{apirealm} = 'Laconica API';
    }

    if ((defined $payload->{source}) and ($payload->{source})) {
        $t->{source}   = $payload->{source};
    }
    
    if ((defined $payload->{apiurl}) and ($payload->{apiurl})) {
        $t->{apiurl}   = $payload->{apiurl};
    }
    
    if ((defined $payload->{apihost}) and ($payload->{apihost})) {
        $t->{apihost}   = $payload->{apihost};
    }
    
    if ((defined $payload->{apirealm}) and ($payload->{apirealm})) {
        $t->{apirealm}   = $payload->{apirealm};
    }
    
    $t->{useragent} = $self->nte_object->agent;
    warn "about to send twitter message \n";
    my $ret = $t->update($payload->{message});
    warn "ret is $ret \n"
}

1;
