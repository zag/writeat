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

    writeat init 
    make

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

Perl6::Pod

=head1 AUTHOR

Zahatski Aliaksandr, <zag@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Zahatski Aliaksandr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

