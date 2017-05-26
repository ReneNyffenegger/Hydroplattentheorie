#!/usr/bin/perl
use warnings;
use strict;


open (my $dot, '>:encoding(utf-8)', 'ablauf.dot') or die;
print $dot "digraph A {\n";

my %dot_boxes;

for my $html (glob '*.html') { #_{

  if ($html eq 'index.html') { #_{

    open my $in, '<:encoding(utf-8)', $html or die;
    while (my $line = <$in>) { #_{

      while ($line =~ s/<a href=["'](.*?\.html)["']//) { #_{

        my $to = $1;

        my $to_dot_id = make_dot_id($to);

        $dot_boxes{$to_dot_id}{indexed}=1;

      } #_}

    } #_}
    close $in;
    next;
  } #_}

  my $html_dot_id = make_dot_id($html);

  $dot_boxes{$html_dot_id}{html_file}=$html;

  open my $in, '<:encoding(utf-8)', $html or die;
  while (my $line = <$in>) { #_{

    if ($line =~ m!<title>(.*)</title>!) { #_{
      my $title = $1;
      $dot_boxes{$html_dot_id}{title_html} = $title;
    } #_}
    if ($line =~ m!^ *manipulateSlide\(\{next: *\['(.*)\.html',!) { #_{

        my $to = $1;
        my $to_dot_id = make_dot_id($to);
        $dot_boxes{$html_dot_id}{next_slide} = $to_dot_id;
        print $dot "$html_dot_id -> $to_dot_id;\n";

    } #_}

  } #_}

} #_}


for my $dot_id (keys %dot_boxes) { #_{
  
  my $color='';
  if ($dot_boxes{$dot_id}{indexed}) {
    $color = "\n     color=red";
  }

  my $title     = $dot_boxes{$dot_id}{title_html} // '?';
  my $html_file = $dot_boxes{$dot_id}{html_file};

  print "dot_id: $dot_id\n" unless $html_file;

  my $shape = "  $dot_id [
  shape=plaintext $color
   label=< <table>
     <tr><td>$title</td></tr>
     <tr><td>$html_file</td></tr>";


  $shape .= "
    </table> >];
";
  print $dot $shape;

} #_}

print $dot "}\n";
close $dot;
system "dot ablauf.dot -Tpdf -oablauf.pdf";

iterate_presentation();

sub iterate_presentation { #_{

  my $cur_slide = make_dot_id('Hydroplattentheorie.html');

  while ((my $next_slide = $dot_boxes{$cur_slide}{next_slide}) ne make_dot_id('The-End.html')) {
    print $next_slide, "\n";
    $cur_slide = $next_slide;
  }


} #_}

sub make_dot_id { #_{
  my $html_file_name = shift;

  $html_file_name =~ s/\.html$//;
  $html_file_name = "S_$html_file_name";
  $html_file_name =~ s/-/_/g;

  return $html_file_name;

} #_}


