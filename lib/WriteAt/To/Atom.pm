#===============================================================================
#
#  DESCRIPTION:  convert pod6 to atom
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
package WriteAt::To::Atom;
use strict;
use warnings;
use Perl6::Pod::Utl;
use WriteAt::To;
#use Perl6::Pod::To::XHTML;
use base ( 'Perl6::Pod::To::XHTML', 'WriteAt::To' );
use utf8;

sub start_write {
    my $self = shift;
    my %tags = @_;
    my $w    = $self->writer;
   <?xml version="1.0" encoding="utf-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom">
  <title>Personal notes</title>
  <id>tag:zag.ru,2011:1</id>
  <link rel="alternate" href="http://zag.ru" type="text/html"/>
  <link rel="self" href="http://zag.ru/Atom" type="application/atom+xml"/>
  <updated>2012-11-27T09:39:19Z</updated>
  <author>
    <name>Aliaksandr Zahatski</name>
    <uri>http://zag.ru</uri>
  </author>

}

sub end_write {
    my $self = shift;
    $self->SUPER::end_write();
    $self->w->raw('</chapter>') if $self->{IN_CHAPTER};
    $self->w->raw('</book>');
}

1;

