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
            #filepath for store htm files to
            basepath => ./

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
    my $self =
      $class->SUPER::new( baseurl => 'http://example.com', lang => 'en', @_ );
    return $self;
}

sub start_write {
    my $self     = shift;
    my %tags     = @_;
    my $w        = $self->writer;
    my $title    = &WriteAt::get_text( @{ $tags{TITLE} } );
    my $base_url = $self->{baseurl};
    my $author   = &WriteAt::get_text( @{ $tags{AUTHOR} } );
    my $atomid   = "tag:$base_url, 2012:1";
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

sub write {
    my $self = shift;
    my $tree = shift;
    my $res  = &WriteAt::make_levels( "CHAPTER", 0, $tree );
    my $w    = $self->writer;
    foreach my $entry (@$res) {
        my $title    = &WriteAt::get_text( $entry->{node} );
        my $title_en = &WriteAt::rus2lat($title);

        #clear spasec
        $title_en =~ s/\s+/-/g;
        my $filename = $title_en . ".htm";
        my $url      = $self->{baseurl} . "/" . $filename;
        my $id       = $self->{baseurl} . ";" . $title;
        $w->raw(
            qq%<entry xmlns="http://www.w3.org/2005/Atom">
                <title>$title</title>
                 <id>$id</id>
                 <link rel="alternate" href="$url" title="$title" type="text/html"/>
                <published>2012-07-20T09:00:00Z</published>
                <updated>2012-07-20T09:00:00Z</updated>
                 <content type="html">%
        );
        my $out = '';
        open( my $fd, ">", \$out );
        my $renderer = new Perl6::Pod::To::XHTML::
          writer  => new Perl6::Pod::Writer( out => $fd, escape => 'xml' ),
          out_put => \$out,
          doctype => 'xhtml',
          header  => 0;

        foreach my $BLOCK_NAME ( keys %{ $self->context->use } ) {
            $renderer->context->use->{$BLOCK_NAME} =
              $self->context->use->{$BLOCK_NAME};
        }

        #    $renderer->parse( \$text, default_pod=>1 );
        foreach my $n ( $entry->{node}, $entry->{childs} ) {
            $renderer->visit($n);
        }
        my $safe_text = &Perl6::Pod::Writer::_html_escape($out);
        $w->raw($safe_text);
        $w->raw(
            '</content>
        </entry>'
        );

        #if basepath
        if ( my $basepath = $self->{basepath} ) {

            # save content to htm file
            warn "$filename : File already exists" if -e $filename;
            my $content =
              $self->page_template( content => $out, title => $title );

            open FH, ">$filename" or die "$filename : $!";
            print FH $content;
            close FH;
        }
    }

}

sub end_write {
    my $self = shift;
    $self->SUPER::end_write();
    $self->w->raw('</chapter>') if $self->{IN_CHAPTER};
    $self->w->raw('</feed>');
}

sub page_template {
    my $self = shift;
    my %keys = @_;
    my $page = <<TXT;
<html>
<head>
<title>{{title}}</title>
</head>
<body>
   {{content}} 
</body>
</html>
TXT
    $page =~ s/\{\{ \s* (\S+) \s* \}\}/ $keys{$1} || ""/gex;
    return $page;
}

1;

