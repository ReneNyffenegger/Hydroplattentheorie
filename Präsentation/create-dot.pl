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

#       my $dot_id = "S_$to";
#       $dot_id =~ s/-/_/g;

#       $htmls{$to}{dot_id} = $dot_id;
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
  my $dot_id;
  while (my $line = <$in>) { #_{
    if ($line =~ m!<title>(.*)</title>!) { #_{
      $title = $1;
    } #_}
    if ($line =~ m!^ *manipulateSlide\(\{next: *\['(.*)\.html',!) { #_{

        $to = $1;

        $dot_id = "S_$to";
        $dot_id =~ s/-/_/g;

        $htmls{$to}{dot_id} = $dot_id;
        $htmls{$to}{title} = $title;
#       $htmls{$to}{indexed} = 1;

#     $to = $1;
#     $to = "S_$to";
#     $to =~ s/-/_/g;

    } #_}
  } #_}
  close $in;
  

# $htmls{$to}{dot_id} = $dot_id;
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
    print $dot "$html_ -> $dot_id;\n";
  }


}

for my $html_ (keys %htmls) {

# # print "$html_\n";
#   print "$html_ \t $htmls{$html_}{dot_id}\n";
# # print join "\n", keys $htmls{$html_};
#   print "\n\n";
#   next;

  my $color='';
  if ($htmls{$html_}{indexed}) {
    $color = "\n     color=red";
  }

  my $title = $htmls{$html_}{title} // '?';

  my $shape = "  $htmls{$html_}{dot_id} [
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
