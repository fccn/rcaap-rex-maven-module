package Rex::Module::Development::Maven;

use strict;
use warnings;

use Rex -base;

our $__package_name = {
	debian => "maven",
	ubuntu => "maven",
	centos => "maven",
	mageia => "maven",
};


our $__program_name = {
	debian => "mvn",
	ubuntu => "mvn",
	centos => "mvn",
	mageia => "mvn",
};

our $__mvn_opts = '-Xmx512M -Xms64M -Dfile.encoding=UTF-8';
our $__mvn_cwd = '/';

task setup => sub {
	pkg param_lookup ("package_name", case ( lc(operating_system()), $__package_name )),
		ensure    => "latest";
};

task mvn => sub {
	my $command = shift;

	my $base_dir = param_lookup ("cwd", $__mvn_cwd );

	Rex::Logger::info("Running mvn $command (this action may take some time)");
	run param_lookup ("package_name", case ( lc(operating_system()), $__program_name ))." $command",
		cwd => $base_dir,
		env => {
			MAVEN_OPTS => param_lookup ("opts", $__mvn_opts ),
		};
	die("Error running mvn command.") unless ($? == 0);
};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Rex::Module::Development::Maven/;

 task yourtask => sub {
    Rex::Module::Development::Maven::setup();
	Rex::Module::Development::Maven::mvn("clean package");
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
