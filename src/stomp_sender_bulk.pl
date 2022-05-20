#!/usr/bin/perl

use Net::Stomp;
use Config::File;

my $config_hash = Config::File::read_config_file("stomp_config.cfg");

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
$stomp->send(
	{ destination => $queue, body => $_ } );
}
$stomp->disconnect;
