use strict;
use warnings;
use utf8;
use Test::More;
use lib "t/lib";
use Util;
use Minilla::Profile::ModuleBuild;
use Minilla::CLI::Build;

my $guard = pushd(tempdir());

{
    Minilla::Profile::ModuleBuild->new(
        author => 'hoge',
        dist => 'Acme-Foo',
        module => 'Acme::Foo',
        path => 'Acme/Foo.pm',
        version => '0.01',
    )->generate();

    spew('MANIFEST', <<'...');
Build.PL
lib/Acme/Foo.pm
...
    write_minil_toml({
        name => 'Acme-Foo',
    });
    git_init_add_commit();

    Minilla::CLI::Build->run();

    ok(-d 'Acme-Foo-0.01/', 'Created build directory');
}

done_testing;

