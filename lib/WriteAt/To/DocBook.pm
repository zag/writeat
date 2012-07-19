#===============================================================================
#
#  DESCRIPTION:  DocBook
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
package WriteAt::To::DocBook;
use Perl6::Pod::Utl;
use WriteAt::To;
use base ('Perl6::Pod::To::DocBook', 'WriteAt::To');
use utf8;

sub block_DESCRIPTION {
    my ($self, $n) = @_;
    my $w = $self->w;
    $w->raw('<abstract>');
    $self->visit_childs($n);
    $w->raw('</abstract>');
};

sub block_TITLE{
    my ($self, $n) = @_;
    my $w = $self->w;
    $w->raw('<title>');
    $self->visit_childs($n);
    $w->raw('</title>');
};

sub block_SUBTITLE{
    my ($self, $n) = @_;
    my $w = $self->w;
    $w->raw('<subtitle>');
    $self->visit_childs($n);
    $w->raw('</subtitle>');
};

# alias for CHAPTER
sub block_ГЛАВА {
    $self = shift;
    return $self->block_CHAPTER(@_)
}


sub block_CHAPTER {
    my ( $self, $node ) = @_;
    #close any section
    $self->switch_head_level(0);
    $self->w->raw('</chapter>') if $self->{IN_CHAPTER};
    $self->w->raw('<chapter>') &&  $self->{IN_CHAPTER}++;
    $self->w->raw('<title>')->print($node->childs->[0]->childs->[0])
    ->raw('</title>');
}

sub end_write {
    my $self = shift;
    $self->SUPER::end_write();
    $self->w->raw('</chapter>') if $self->{IN_CHAPTER};
}
1;



