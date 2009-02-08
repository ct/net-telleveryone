##############################################################################
# Net::TellEveryone - Central API to many status posting services
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone;

use Carp;
use strict;

use Moose;
our $VERSION = '1.00';

sub servicelist {
        qw(
          WebHooks
        )
}

#          Twitter
#          Identica
#          Laconica
#          Email
#          FriendFeed
#          IRC
#          Jabber
#          AIM
#          YIM

foreach my $svchash ( __PACKAGE__->servicelist ) {
    eval "require Net::TellEveryone::$svchash";
    if ($@) {
        confess "Could not load Net::TellEveryone::$svchash - $@";
    }
    has $svchash => (
        isa       => 'HashRef',
        is        => 'rw',
        lazy      => 1,
        default   => sub { {} },
        predicate => "has_$svchash",
    );
}

has services => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] },
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

has agent => (
    isa     => 'Str',
    is      => 'rw',
    default => sub { "Net::TellEveryone/$Net::TellEveryone::VERSION (PERL)" },
);

sub notify {
    my $self = shift;

    foreach my $svc ( $self->servicelist ) {
        my $class = "Net::TellEveryone::$svc";
        if ( defined $self->$svc ) {
            my $svc_obj = eval { $class->new( { payload => $self->$svc, nte_object => $self, } ) };

            if ( defined $svc_obj ) {
                $svc_obj->process;
            } else {
                carp "Cannot create object for $class - $@";
            }
        } else {
            carp "Args HashRef for $svc undefined, skipping.";
        }
    }
}

1;    # End of Net::TellEveryone
