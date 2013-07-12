#!/usr/bin/perl
use Module::Build;
use strict;
my $build = Module::Build->new(
    module_name       => "HelloWorld::Lib",
    dist_author       => 'Alexey Melezhik / melezhik@gmail.com',
    license          => 'perl',
    configure_requires => { 'Module::Build' => '0' },
    requires         => {
      'version'    => '0',
      'DBD::mysql' => '>= 4.0.21',
      'DBI' => '0',
    },

    dist_abstract => 'Hello World Application',
);

$build->create_build_script();
