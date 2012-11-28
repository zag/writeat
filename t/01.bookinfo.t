#===============================================================================
#
#  DESCRIPTION:  Test get bookinfo blocks
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================

package main;
use strict;
use warnings;
use v5.10;
use Test::More tests => 1;    # last test to print
use Perl6::Pod::Utl;
use Data::Dumper;
use WriteAt;
use utf8;
use_ok('WriteAt');

my $t = <<T;
=begin pod
=ЗАГОЛОВОК asdasd
=SUBTITLE asdasd
=DESCRIPTION
asd asd 
=begin CHANGES
Sep 19th 2011(v0.7)[zag]   Классы и объекты

May 13th 2011(v0.6)[zag]   Формат Pod

Jan 08th 2011(v0.5)[zag]   Подпрограммы и сигнатуры

=end CHANGES
=for AUTHOR
firstname: Александр
surname: Загацкий

=CHAPTER Test chapter

Ok 
=head1 Test name
=head2 test

yes

=head1 Test 1

ok

=CHAPTER Test chapter2

Ok 
=head1 Teste

=end pod
T

#utf8::decode($t) unless utf8::is_utf8($t);

my $tree = Perl6::Pod::Utl::parse_pod( $t, default_pod => 1 )
  || die "Can't parse ";
my %res = ();
$tree = &WriteAt::get_book_info_blocks( $tree, \%res );

#print Dumper $tree; exit;
my $res = &WriteAt::make_levels( "CHAPTER", 0, $tree );
is scalar(@$res), 2 , 'Get semantic nodes';
is &WriteAt::get_text($res->[0]->{node}), 'Test chapter', 'get text content of node';
#print Dumper $res->[0]->{node};
#use Perl6::Pod::Test;
#my $dump = &Perl6::Pod::Test::dump_tree($result);
#print Dumper $result;

exit;

use_ok "WriteAt::To::Atom";
my $atom = new WriteAt::To::Atom:: lang => 'en';
diag $atom->writer;
$atom->start_write(%res);
$atom->write();
$atom->end_write();

#$atom
#print Dumper \%res; exit;
#print Dumper $tree;
#warn $str;

