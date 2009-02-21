##############################################################################
# Net::TellEveryone - Central API to many status posting services
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone;

use Carp qw( carp cluck );
use strict;

use Moose;
our $VERSION = '1.00';
our $DEBUG = 0;
sub servicelist {
        qw(
          WebHooks
          IRC
          Twitter
          AIM
        )
}

# TODO:
#          Email
#          FriendFeed
#          Jabber
#          YIM

foreach my $svchash ( __PACKAGE__->servicelist ) {
    eval "require Net::TellEveryone::$svchash";
    if ($@) {
        cluck "Could not load Net::TellEveryone::$svchash - $@" if $DEBUG;
        next;
    }
    __PACKAGE__->meta->add_attribute( $svchash => (
        isa       => 'Maybe[HashRef]',
        is        => 'rw',
        predicate => "has_$svchash"
    ));
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
        my $predicate = "has_$svc";
        
        if ( $self->meta->get_attribute( $svc ) && $self->$predicate ) {

            my $svc_obj = eval { $class->new( { payload => $self->$svc, nte_object => $self, } ) };

            if ( defined $svc_obj ) {
                $svc_obj->process;
            } else {
                carp "Cannot create object for $class - $@" if $Net::TellEveryone::DEBUG;
            }
        } else {
            carp "Args HashRef for $svc undefined, skipping." if $Net::TellEveryone::DEBUG;
        }
    }
}

no Moose;
1;    # End of Net::TellEveryone
