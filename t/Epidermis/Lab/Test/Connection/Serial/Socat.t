#!/usr/bin/env perl

use Test::Most tests => 1;

use lib 't/lib';

use aliased 'Epidermis::Lab::Connection::Serial' => 'Connection::Serial';
use aliased 'Epidermis::Lab::Test::Connection::Serial::Socat';
use aliased 'Epidermis::Lab::Test::Connection::Serial::Socat::Role::WithChild';
use Try::Tiny;
use Moo::Role ();

subtest "Test socat serial pair" => sub {
SKIP: {
	my $socat = try {
		Moo::Role->create_class_with_roles(Socat, WithChild)
			->new;
	} catch {
		skip $_;
	};

	$socat->start_via_child;
	# wait until file created
	my $sleep_count = 0; sleep 1 while ! -e $socat->pty0 && $sleep_count++ < 2;

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
