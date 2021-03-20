#!/usr/bin/env perl

use Test::Most tests => 1;

use lib 't/lib';

use aliased 'Epidermis::Lab::Connection::Serial' => 'Connection::Serial';
use aliased 'Epidermis::Lab::Test::Connection::Serial::Socat';
use Try::Tiny;

subtest "Test socat serial pair" => sub {
SKIP: {
	my $socat = try {
		Socat->new;
	} catch {
		skip $_;
	};

	$socat->start;

	my $sender_conn = Connection::Serial->new(
		device => $socat->pty0,
		mode => "9600,8,n,1",
	);
	$sender_conn->open_handle;

	my $receiver_conn = Connection::Serial->new(
		device => $socat->pty1,
		mode => "9600,8,n,1",
	);
	$receiver_conn->open_handle;

	pass;
}
};

done_testing;
