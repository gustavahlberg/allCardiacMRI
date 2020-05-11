#!/usr/bin/env perl
use strict;
use Getopt::Long;


GetOptions( "chr=i"=> \my $i);
my $pth='/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497';
my $bim=$pth.'/ukb_snp_chr'.$i.'_v2.bim';
my $bimexcl='ukb_snp_chr'.$i.'_v2.excl.bim';

sub split_line {
    my ($line)=@_;
    chomp($line);
    $line =~ s/^[\s]+//g;
    my @cols=  split /\s+/, $line;
}


die "$bim: ".$! unless open FILE, "< $bim";
die "$bimexcl: ".$! unless open RA, "> $bimexcl";
while (my $line = <FILE>){
    my @cells = &split_line ($line);
    if ($cells[0] == 6 && $cells[3] > 25000000 && $cells[3] < 35000000) {
            print RA $line;
        }
    if ($cells[0] == 8 && $cells[3] > 7000000 && $cells[3] < 13000000) {
            print RA $line;
        }
    if ($cells[0] == 5 && $cells[3] > 44000000 && $cells[3] < 51500000) {
      print RA $line;
    }
    if ($cells[0] == 11 && $cells[3] > 45000000 && $cells[3] < 57000000) {
      print RA $line;
    }
    if ($cells[0] < 1 || $cells[0] > 22) {
      print RA $line;
    }
}
close FILE;
close RA;
