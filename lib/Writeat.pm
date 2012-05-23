#===============================================================================
#
#  DESCRIPTION: Writeat - suite for book writers
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
package Writeat;

=head1 NAME

Writeat - suite for make books and docs in pod6 format

=head1 SYNOPSIS


    =TITLE MyBook
    =SUBTITLE My first free book
    =AUTHOR
    firstname:Alex
    surname:Green
    =DESCRIPTION  Short description about this book
    =begin CHANGES
    Aug 18th 2010(v0.2)[zag]   preface
    
    May 27th 2010(v0.1)[zag]   Initial version
    =end CHANGES
     
    =Include src/book_preface.pod
    =CHAPTER Intro
    
    B<Pod> is an evolution of Perl 5's L<I<Plain Ol' Documentation>|doc:perlpod>
    (POD) markup. Compared to Perl 5 POD, Perldoc's Pod dialect is much more 
    uniform, somewhat more compact, and considerably more expressive. The
    Pod dialect also differs in that it is a purely descriptive mark-up
    notation, with no presentational components.

=head1 DESCRIPTION

Books must be high available for readers and writers !
Writeat - suite for free book makers. It help make and prepare book for publishing.

=cut

use strict;
use warnings;
use v5.10;
our $VERSION = '0.01';
use Writeat::CHANGES;
use Writeat::AUTHOR;
use Writeat::To::DocBook;

=head1 FUNCTIONS

=cut

sub get_book_info_blocks {
    my $tree = shift;
    my $res = shift || return;
    my @nodes = ref( $tree ) eq 'ARRAY' ? @$tree : ($tree);
    my @tree = ();
    foreach my $n (@nodes) {
        unless (ref($n)){ #skip text
            push @tree, $n;
            next;
        }
        if ($n->name =~ /^(CHANGES|SUBTITLE|AUTHOR|TITLE|DESCRIPTION)$/ ) {
            $res->{$n->name} = $n;
        } else {
            push @tree,$n;
            $n->childs(
            &get_book_info_blocks( $n->childs , $res )
            )
        }
    }
    \@tree
}

=head1 METHODS
=cut
sub new {
    my $class = shift;
    bless( ( $#_ == 0 ) ? shift : {@_}, ref($class) || $class );
}

1;
__END__

=head1 SEE ALSO

Perl6::Pod,
Russian book "Everything about Perl 6" L<https://github.com/zag/ru-perl6-book>


=head1 AUTHOR

Zahatski Aliaksandr, <zag@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Zahatski Aliaksandr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

