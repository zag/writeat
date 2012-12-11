use Module::Build;
use v5.10;
Module::Build->new
    ( module_name => 'WriteAt',
    license => 'perl',
   prereq => {
	'Regexp::Grammars'=>1.015,
        'Perl6::Pod::Lib'=>0.11,
        'Perl6::Pod'=>0.55,
        'DateTime::Format::W3CDTF'=>0
	     },
    script_files=>[qw!
	scripts/writeat
    !],
   dist_version_from=>'lib/WriteAt.pm',
    meta_merge=>{
     resources=> {
        repository => 'git://github.com/zag/writeat.git',
        bugtracker=>'http://rt.cpan.org/Public/Dist/Display.html?Name=WriteAt'
    }
    },
   dist_author=>'Zahatski Aliaksandr zag@cpan.org',
    create_makefile_pl=>$ENV{DO_OUTCPAN} ? 'traditional':'passthrough'
    )->create_build_script;
