#===============================================================================
#
#  DESCRIPTION:  Test published attr
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
#$Id$
package CTX;
sub new {
    my $class = shift;
    my $self = bless( ( $#_ == 0 ) ? shift : {@_}, ref($class) || $class );
    #init head levels
    $self->{HEAD_LEVELS} = 0;
    $self->{stack} = [];
    $self;
}

sub get_filter_time {
    my $self = shift;
    return $self->{filter_time}
}
sub get_parent_time {
    my $self = shift;
    return $self->{stack}->[-1]
}
sub switch_head_level {
    my $self = shift;
    my $n = shift;
    my $level = shift;
}

package main;
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

=head2 get_time_stamp_from_string <str>

Get time stamp from strnigs like this:

        2012-11-27T09:39:19Z
        2012-11-27 09:39:19
        2012-11-27 09:39
        2012-11-27 09
        2012-11-27

return unixtimestamp

=cut

sub get_time_stamp_from_string {
    my $str  = shift || return;
    use DateTime::Format::W3CDTF;
    #if w3cdtf time
    if ( $str =~ /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(Z|.\d{2}:\d{2})/ ) {
        my $dt = DateTime::Format::W3CDTF->new();
        return $dt->parse_datetime($str)->epoch();
    }
    elsif ( $str =~
        /^(\d{4})-(\d{2})-(\d{2})(?:.(\d{2})(?::(\d{2})(?::(\d{2}))?)?)?/ )
    {
        my $dt = DateTime->new(
            year       => $1,
            month      => $2,
            day        => $3,
            hour       => $4 || 0,
            minute     => $5 || 0,
            second     => $6 || 0,
            nanosecond => 500000000,
        );
        return $dt->epoch;
    }
    die "Bad srting $str";
}

sub filter_published {
    my $tree  = shift;
    my $ctx   = shift || return;
    my @nodes = ref($tree) eq 'ARRAY' ? @$tree : ($tree);
    my @tree  = ();
    foreach my $n (@nodes) {
        unless ( ref($n) ) {    #skip text
            push @tree, $n;
            next;
        }
     if ($n->name eq 'pod' ) {
        push @tree, $n;
        $n->childs( &filter_published( $n->childs, $ctx ) );
        next;
     }
    # handle publish attr
    my $pub_time = 
        &get_time_stamp_from_string( $n->get_attr->{published} ) 
        || $ctx->get_parent_time() 
        || next; #if publish time empty skipit

    my $name = $n->name;
    #prcess head levels
    if ( $name eq 'head' ) {
        $ctx->switch_head_level( $n, $n->level, $pub_time );
    }
    my $filter_time = $ctx->get_filter_time;
    #skip node
    next if ( $pub_time > $filter_time );
    push @tree, $n;
    $n->childs( &filter_published( $n->childs, $ctx ) );
    }
    \@tree;
}


my $tree = Perl6::Pod::Utl::parse_pod( $t, default_pod =>0 )
  || die "Can't parse ";
my %res = ();
#$tree = &WriteAt::get_book_info_blocks( $tree, \%res );
$tree = &filter_published($tree, new CTX:: (filter_time=>&get_time_stamp_from_string('2012-11-27T09:38:19Z')));
#print Dumper $tree;

