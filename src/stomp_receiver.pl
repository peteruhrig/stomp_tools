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

my $stomp = Net::Stomp->new( { 
	hostname => $config_hash->{hostname}, 
	port => $config_hash->{port} } );
if ($config_hash->{username}) {
	$stomp->connect( { login => $config_hash->{username} , passcode => $config_hash->{password} } ) or die "connection failed; credentials wrong?";
}
else {
	$stomp->connect() or die "connection failed; credentials necessary?";
}
$stomp->subscribe(
	{   destination             => $queue,
		'ack'                   => 'client',
		'activemq.prefetchSize' => $config_hash->{activemq_prefetchSize},
		'timeout'               => $config_hash->{timeout}
	}
);

my $frame = $stomp->receive_frame({ timeout => $config_hash->{timeout} }) or die "Timeout\n";

print $frame->body;
print STDERR "Dequeued Element is ", $frame->body, "\n";
$stomp->ack( { frame => $frame } );
$stomp->disconnect;
