#!/usr/bin/perl

use lib './lib';
use strict;

use Net::TellEveryone;

my $nte = Net::TellEveryone->new(
    {
        WebHooks => {
            url => 'http://orb.x4.net/hooktest.pl',
            content => {
                foo => "bar",
                baz => "quux", 
            }
        },
        
    }
    
    
)->notify;
#$nte->notify;