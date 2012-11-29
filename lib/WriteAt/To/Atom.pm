#===============================================================================
#
#  DESCRIPTION:  convert pod6 to atom
#
#       AUTHOR:  Aliaksandr P. Zahatski, <zahatski@gmail.com>
#===============================================================================
=head1 NAME

WriteAt - suite for make books and docs in pod6 format

=head1 SYNOPSIS

        new WriteAt::To::Atom:: 
            lang=>'en', 
            baseurl=>'http://example.com',

=cut

package WriteAt::To::Atom;
use strict;
use warnings;
use Perl6::Pod::Utl;
use WriteAt::To;
#use Perl6::Pod::To::XHTML;
use base ( 'Perl6::Pod::To::XHTML', 'WriteAt::To' );
use utf8;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(baseurl=>'http://example.com', lang=>'en', @_);
    return $self;
}
sub start_write {
    my $self = shift;
    my %tags = @_;
    my $w    = $self->writer;
    my $title =&WriteAt::get_text( @{ $tags{TITLE} } );
    my $base_url = $self->{baseurl};
    my $author = &WriteAt::get_text( @{ $tags{AUTHOR} } );
    my $atomid = "tag:$base_url, 2012:1";
    $w->raw(<<TXT);
   <?xml version="1.0" encoding="utf-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom">
  <title>$title</title>
  <id>$atomid</id>
  <link rel="alternate" href="$base_url" type="text/html"/>
  <link rel="self" href="$base_url/Atom.xml" type="application/atom+xml"/>
  <updated>2012-11-27T09:39:19Z</updated>
  <author>
    <name>$author</name>
    <uri>$base_url</uri>
  </author>
TXT
}

sub end_write {
    my $self = shift;
    $self->SUPER::end_write();
    $self->w->raw('</chapter>') if $self->{IN_CHAPTER};
    $self->w->raw('</book>');
}

1;

