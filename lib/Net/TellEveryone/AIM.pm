##############################################################################
# Net::TellEveryone::AIM - AIM
# v1.00
# Copyright (c) 2009 Screaming Mongoose, LLC
##############################################################################

package Net::TellEveryone::AIM;

use Carp;
use strict;

use Moose;
use Moose::Util::TypeConstraints;
use Net::OSCAR;

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
    my $self    = shift;
    my $payload = $self->{payload};
    my $oscar = Net::OSCAR->new() or die $!;

    $oscar->set_callback_signon_done( \&signed_on );
#    $oscar->set_callback_im_ok( \&msg_sent );
#    $oscar->set_callback_connection_changed( \&conn_changed );
$oscar->set_callback_error(\&error);
    $oscar->{__payload} = $payload;

    $oscar->loglevel(10);

    print $payload->{screenname} . " - " . $payload->{password} . "\n";

    $oscar->signon( $payload->{screenname}, $payload->{password} );
    while (1) {
        $oscar->do_one_loop();

        # Do stuff
    }
}

sub error($$$$$) {
	my($oscar, $connection, $errno, $error, $fatal) = @_;
	if($fatal) {
		die "Fatal error $errno in ".$connection->{description}.": $error\n";
	} else { print STDERR "Error $errno: $error\n"; }
}


sub signed_on {
    my $oscar   = shift;
    my $payload = $oscar->{__payload};
    die;
    print "Signed on\n";
    $oscar->send_im( $payload->{recipient}, $payload->{message} ) or carp $!;

}

sub msg_sent {
    my ( $oscar, $to, $reqid ) = @_;

    print "Message $reqid sent to $to\n";
    #$oscar->signoff;

}


sub conn_changed {
    my ( $oscar, $connection, $status ) = @_;
    print "CONN_CHANGED - $status \n";
}

1;
