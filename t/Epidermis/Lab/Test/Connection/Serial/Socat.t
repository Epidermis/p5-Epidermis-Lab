#!/usr/bin/env perl

use Test2::V0;
plan tests => 1;

use lib 't/lib';

use aliased 'Epidermis::Lab::Connection::Serial' => 'Connection::Serial';
use aliased 'Epidermis::Lab::Test::Connection::Serial::Socat';
use aliased 'Epidermis::Lab::Test::Connection::Serial::Socat::Role::WithChild';
use Try::Tiny;
use Scalar::Util qw(refaddr);
use Moo::Role ();

subtest "Test socat serial pair" => sub {
	my $socat = try {
		Moo::Role->create_class_with_roles(Socat, WithChild)
			->new;
	} catch {
		skip_all $_;
	};

	$socat->start_via_child;

	my $sender_conn = Connection::Serial->new(
		device => $socat->pty0,
		mode => "9600,8,n,1",
	);
	ok $sender_conn->handle, 'sender handle';

	is refaddr $sender_conn->read_handle, refaddr $sender_conn->write_handle, 'reader and writer are the same';

	my $receiver_conn = Connection::Serial->new(
		device => $socat->pty1,
		mode => "9600,8,n,1",
	);
	ok $receiver_conn->handle, 'receiver handle';
};

done_testing;
