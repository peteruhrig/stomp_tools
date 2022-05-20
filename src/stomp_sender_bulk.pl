#!/usr/bin/perl

use Net::Stomp;
use Config::File;
use File::Spec::Functions qw(rel2abs);
use File::Basename qw(dirname);

my $path = rel2abs( $0 );
our $directory = dirname( $path );


my $config_hash = Config::File::read_config_file($directory."/stomp_config.cfg");

my $queue;
if ($ARGV[0] ne "") {
	$queue = $ARGV[0];
}
else {
	$queue = "default_queue";
}

#print STDERR "Host: ", $config_hash->{hostname}, " Port: ", $config_hash->{port}, "\n";
my $stomp = Net::Stomp->new( { 
	hostname => $config_hash->{hostname}, 
	port => $config_hash->{port} } );
if ($config_hash->{username}) {
	$stomp->connect( { login => $config_hash->{username} , passcode => $config_hash->{password} } );
}
else {
	$stomp->connect();
}

while (<STDIN>) {
	chomp;
	if ($config_hash->{send_with_receipt}) {
		$stomp->send_with_receipt(
			{ destination => $queue, body => $_ } ) or die "Could not send.\n";
	}
	else {
		$stomp->send(
			{ destination => $queue, body => $_ } );
	}
}
$stomp->disconnect;
