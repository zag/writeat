#===============================================================================
#
#  DESCRIPTION: WriteAt - suite for book writers
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
package WriteAt;

=head1 NAME

WriteAt - suite for make books and docs in pod6 format

=head1 SYNOPSIS


    =TITLE MyBook
    =SUBTITLE My first free book
    =AUTHOR Alex Green
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
WriteAt - suite for free book makers. It help make and prepare book for publishing.

=head1 INSTALLATION

There are several ways to install C<WriteAt> to your system.

=head2 Install under Ubuntu 

    sudo add-apt-repository ppa:zahatski/ppa
    sudo apt-get install writeat

=head2 From CPAN

    cpanm WriteAt

For book creation it is necessary following software:

   * docbook-4.5
   * xslt processor
   * GNU make

=head2 Checkout templates

Grab template:
        
        git clone https://github.com/zag/writeat-tmpl-firstbook.git
        cd writeat-tmpl-firstbook
        make

Point your web brouser to C<index.html> file in C<work> directory.

=cut

use strict;
use warnings;
use v5.10;
our $VERSION = '0.02';
use WriteAt::CHANGES;
use WriteAt::AUTHOR;
use WriteAt::To::DocBook;
use utf8;

=head1 FUNCTIONS

=cut

sub get_name_from_locale {
    my $name = shift;
    my %SEM  = (
        TITLE       => [ qr/TITLE/,       qr/^ЗАГОЛОВОК/ ],
        SUBTITLE    => [ qr/SUBTITLE/,    qr/ПОДЗАГОЛОВОК/ ],
        AUTHOR      => [ qr/AUTHOR/,      qr/АВТОР/ ],
        CHANGES     => [ qr/CHANGES/,     qr/ИЗМЕНЕНИЯ/ ],
        DESCRIPTION => [ qr/DESCRIPTION/, qr/ОПИСАНИЕ/ ]
    );
    while ( my ( $k, $v ) = each %SEM ) {
        foreach my $reg (@$v) {
            if ( $name =~ $reg ) {
                return $k;
            }
        }

    }
    return undef;
}

sub get_book_info_blocks {
    my $tree  = shift;
    my $res   = shift || return;
    my $to    = shift;
    my @nodes = ref($tree) eq 'ARRAY' ? @$tree : ($tree);
    my @tree  = ();
    foreach my $n (@nodes) {
        unless ( ref($n) ) {    #skip text
            push @tree, $n;
            next;
        }

        #convert =Include $n to DOM if To::* passed
        if ( $to && $n->name eq 'Include' ) {
            $n = $to->_make_dom_node($n);
            #set current path
            $to->context->custom->{src} = $n->{PATH};

        }
        if ( my $converted_block_name = &get_name_from_locale( $n->name ) ) {
            push @{$res->{$converted_block_name}}, $n;
            # overwrite original name
            $n->{name} = $converted_block_name;
        }
        else {
            push @tree, $n;
            $n->childs( &get_book_info_blocks( $n->childs, $res, $to ) );
        }
    }
    \@tree;
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
The world's first book in the pod6 format: Russian book "Everything about Perl 6" L<https://github.com/zag/ru-perl6-book>,
book template: L<https://github.com/zag/writeat-tmpl-firstbook.git>,
russian book template: L<https://github.com/zag/writeat-tmpl-firstbook-ru.git>

=head1 AUTHOR

Zahatski Aliaksandr, <zag@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Zahatski Aliaksandr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

