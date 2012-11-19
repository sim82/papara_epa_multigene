#!/bin/perl
use warnings "all";

use Cwd 'abs_path';
use File::Basename;
use File::Temp qw/ tempdir /;
use File::Copy;

my $tree_file = $ARGV[0] || die "missing argument 0";
my $ref_file = $ARGV[1] || die "missing argument 1";
my $qs_file = $ARGV[2] || die "missing argument 2";
my $model_file = $ARGV[3] || die "missing argument 3";

my $bindir = './linux_64';
{
  my $blast_tmp = tempdir( "blastXXXX", CLEANUP => 1 );
 
  my $fa_file = "$blast_tmp/ref.fa";
  my $ptf_cmd = "$bindir/phy_to_fasta < $ref_file > $fa_file";
  
  print( "$ptf_cmd\n" );
  system( $ptf_cmd ) 
    || die "phy_to_fasta failed";
    
    
  system( "$bindir/formatdb $fa_file" );
  #  || die "blast formatdb failed";
    
    
  my $blast_out = "$blast_tmp/qs.blast";
  my $blast_cmd = "$bindir/blast -d $fa_file -i $qs_file -m 8 -b 1 > $blast_out";
  
  system( $blast_cmd );
#    || die "blast failed";
  
  
  
  my $papara_cmd = "linux_64/papara -t $tree_file -s $ref_file -q $qs_file -x $model_file -l $blast_out";
  
  system( $papara_cmd ) || die "papara failed";
  
}
