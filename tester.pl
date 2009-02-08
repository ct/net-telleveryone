#!/usr/bin/perl

use lib './lib';
use strict;

use Net::TellEveryone;

my $nte = Net::TellEveryone->new(
    {
        message => 'This is a message',
        ref_url => 'This is a ref_url',
        payload => {
            foo => 'bar',
            baz => 'quux',
        },
        url => 'http://orb.x4.net:10359/'
    }
    
    
)->notify;
#$nte->notify;