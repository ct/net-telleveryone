#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Net::TellEveryone' );
}

diag( "Testing Net::TellEveryone $Net::TellEveryone::VERSION, Perl $], $^X" );
