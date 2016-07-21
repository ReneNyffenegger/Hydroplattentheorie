#!/usr/bin/perl

use warnings;
use strict;

my $x_deg_from   = shift;
my $x_min_from   = shift;
my $x_sec_from   = shift;

my $y_deg_from   = shift;
my $y_min_from   = shift;
my $y_sec_from   = shift;

my $x_deg_to     = shift;
my $x_min_to     = shift;
my $x_sec_to     = shift;

my $y_deg_to     = shift;
my $y_min_to     = shift;
my $y_sec_to     = shift;

my $steps        = shift;
my $out_file     = shift;

my $x_from = $x_deg_from + sign($x_deg_from) * $x_min_from / 60 + sign($x_deg_from) * $x_sec_from / 3600;
my $x_to   = $x_deg_to   + sign($x_deg_to  ) * $x_min_to   / 60 + sign($x_deg_to  ) * $x_sec_to   / 3600;

my $y_from = $y_deg_from + sign($y_deg_from) * $y_min_from / 60 + sign($y_deg_from) * $y_sec_from / 3600;
my $y_to   = $y_deg_to   + sign($y_deg_to  ) * $y_min_to   / 60 + sign($y_deg_to  ) * $x_sec_to   / 3600;

open (my $f, '>', $out_file) or die;

for (my $i=0; $i<=$steps; $i++) {
  printf $f "%f %f\n", 
    $x_from + ($x_to-$x_from)/$steps*$i,
    $y_from + ($y_to-$y_from)/$steps*$i;
}

close $f;

sub sign {
  my $s = shift;
  return  1 if $s > 0;
  return -1;
}
