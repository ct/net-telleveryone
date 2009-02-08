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

has user => (
    isa => 'Str',
    is  => 'rw',
    default =>  sub { 1 }, 
);

has pass => (
    isa => 'Str',
    is  => 'rw',
    default =>  sub { 1 }, 
);

has message => (
    isa => 'Str',
    is  => 'rw',
    default =>  sub { 1 }, 
);

has ref_url => (
    isa => 'Str',
    is  => 'rw',
    default =>  sub { 1 }, 
);




1; # End of Net::TellEveryone
