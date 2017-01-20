#!/usr/bin/perl
use warnings;
use strict;

open (my $svg, '>', '../../res/kometen.svg') or die;

my $start_halley       =  1403;
my $start_swift_tuttle =   702;
my $end                = 10000;

my $gap                =    50;

my $start = $start_halley < $start_swift_tuttle ? $start_halley : $start_swift_tuttle;

my $width = $end - $start;

printf $svg '<svg height="%fpx" width="%fpx">', 2*$gap, $width + 2*$gap;

for (my $x = $start_halley; $x <= $end; $x += 69.68) {
  printf $svg '<circle cx="%f" cy="%f" r="8" fill="red" />', $gap + $x, $gap-8;
}

for (my $x = $start_swift_tuttle; $x <= $end; $x += 129.33) {
  printf $svg '<circle cx="%f" cy="%f" r="8" fill="blue" />', $gap + $x, $gap+8;
}

print $svg "</svg>";

close $svg;
