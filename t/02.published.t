#===============================================================================
#
#  DESCRIPTION:  Test published attr
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
#$Id$

use strict;
use warnings;
#use Test::More tests => 1;                      # last test to print
use Test::More 'no_plan';                      # last test to print

use Data::Dumper;
use WriteAt;
use utf8;
use_ok('WriteAt');
my $t = <<T;
=begin pod
=for CHAPTER :published<'2012-11-27T09:39:19Z'> :tag<intro>
Test chapter
=head1 Test name

test
=head2 test

yes
=end pod
T

my $tree = Perl6::Pod::Utl::parse_pod( $t, default_pod =>0 )
  || die "Can't parse ";
my %res = ();
#$tree = &WriteAt::get_book_info_blocks( $tree, \%res );
print Dumper $tree;

