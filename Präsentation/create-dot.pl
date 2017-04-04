#!/usr/bin/perl
use warnings;
use strict;

open (my $dot, '>:encoding(utf-8)', 'ablauf.dot') or die;
print $dot "digraph A {\n";

my %htmls;

for my $html (glob '*.html') {

  if ($html eq 'index.html') { #_{

    open my $in, '<:encoding(utf-8)', $html or die;
    while (my $line = <$in>) {

      while ($line =~ s/<a href=["'](.*?)\.html["']//) {

        my $to = $1;
        $to = "S_$to";
        $to =~ s/-/_/g;

        $htmls{$to}{indexed} = 1;

      }

    }
    close $in;
    next;
  } #_}

  my ($html_) = $html =~ /(.*)\.html$/;
  $html_ = "S_$html_";
  $html_ =~ s/-/_/g;

  open my $in, '<:encoding(utf-8)', $html or die;

  my $title;
  my $to;
  while (my $line = <$in>) { #_{
    if ($line =~ m!<title>(.*)</title>!) {
      $title = $1;
    }
    if ($line =~ m!next: *\['(.*)\.html',!) {
      $to = $1;
      $to = "S_$to";
      $to =~ s/-/_/g;

    }
  } #_}
  close $in;
  

  $htmls{$html_}{title} = $title;
# if ($to) {
#   $htmls{$to}{title} = $title;
# }

#  print $dot "$html_ [
#  shape=plaintext;
#  label=< <table>
#    <tr><td>$title</td></tr>
#    <tr><td>$html</td></tr>
#   </table> >];
#";
#
  if ($to) {
    print $dot "$html_ -> $to;\n";
  }


}

for my $html_ (keys %htmls) {

  my $color='';
  if ($htmls{$html_}{indexed}) {
    $color = "\n     color=red";
  }

  my $title = $htmls{$html_}{title} // '?';

  my $shape = "  $html_ [
  shape=plaintext $color
   label=< <table>
     <tr><td>$title</td></tr>
     <tr><td>$html_</td></tr>";


  $shape .= "
    </table> >];
";
  print $dot $shape;
}

print $dot "}\n";
close $dot;

# system "dot ablauf.dot -Tpdf -oablauf.pdf && op ablauf.pdf";
system "dot ablauf.dot -Tpdf -oablauf.pdf";
