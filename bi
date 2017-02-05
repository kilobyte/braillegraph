#!/usr/bin/perl -w
use strict;
use GD;
use integer;

my $img = new GD::Image($ARGV[0]) or die;
my $sx = $img->width;
my $sy = $img->height;

sub pix($$)
{
    my ($x,$y) = @_;
    return $img->getPixel($x, $y);
}

sub do_char($$)
{
    my ($x,$y) = @_;
    $x*=2; $y*=4;
    my $g = 0;
    $g+=  1 if pix($x  ,$y  );
    $g+=  8 if pix($x+1,$y  );
    $g+=  2 if pix($x  ,$y+1);
    $g+= 16 if pix($x+1,$y+1);
    $g+=  4 if pix($x  ,$y+2);
    $g+= 32 if pix($x+1,$y+2);
    $g+= 64 if pix($x  ,$y+3);
    $g+=128 if pix($x+1,$y+3);
    # print Unicode codepoint 0x2800+$g, as UTF-8.
    printf("%c%c%c", 0xe2, 0xa0+$g/64, 0x80+$g%64);
}

for my $cy (0..($sy-1)/4)
{
    for my $cx (0..($sx-1)/2)
    {
        do_char($cx, $cy);
    }
    print "\n";
}
