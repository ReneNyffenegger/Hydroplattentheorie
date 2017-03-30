#!/usr/bin/perl
use warnings;
use strict;

open (my $dot, '>:encoding(utf-8)', 'ablauf.dot') or die;
print $dot "digraph A {\n";

for my $html (glob '*.html') {

  my ($html_) = $html =~ /(.*)\.html$/;
  $html_ = "S_$html_";
  $html_ =~ s/-/_/g;

  open my $in, '<:encoding(utf-8)', $html or die;

  my $title;
  my $to;
  while (my $line = <$in>) {
    if ($line =~ m!<title>(.*)</title>!) {
      $title = $1;
    }
    if ($line =~ m!next: *\['(.*)\.html',!) {
      $to = $1;
      $to = "S_$to";
      $to =~ s/-/_/g;
    }
  }
  close $in;
  


  print $dot "$html_ [
  shape=plaintext;
  label=< <table>
    <tr><td>$title</td></tr>
    <tr><td>$html</td></tr>
   </table> >];
";

  if ($to) {

    print $dot "$html_ -> $to;\n";
  }


}

print $dot "}\n";
close $dot;

system "dot ablauf.dot -Tpdf -oablauf.pdf && op ablauf.pdf";
