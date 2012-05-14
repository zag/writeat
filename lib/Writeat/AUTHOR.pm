#===============================================================================
#
#  DESCRIPTION:  Author SECTION
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
#$Id$
package Writeat::AUTHOR;
use strict;
use warnings;
use Perl6::Pod::Block;
use base 'Perl6::Pod::Block';

=pod

Convert:

    *AUTHOR
    firstname: Alex
    surname: Bom
    lineage: Bred

To 

           <author>
                <firstname>Alex</firstname>
                <lineage>Bred</lineage>
                <surname>Bom</surname>
        </author>
 
=cut

sub parse_content {
    my $self     = shift;
    my $t        = shift;
    my %items = $t=~m/^(\w+)\s*:\s*(.+?)\s*$/mg;
    return \%items;
}

sub to_docbook {
    my ( $self, $to )= @_;
    my $w = $to->w;
    $w->raw('<author>');
    my $rec = $self->parse_content( $self->childs->[0]->childs->[0] );
    while( my ($k, $v) = each %$rec ) {
        $w->raw("<$k>");
        $w->print("$v");
        $w->raw("</$k>");
    }
    $w->raw('</author>');
}
1;

