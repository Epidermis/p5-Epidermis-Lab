package Epidermis::Lab::Test::Connection::Pipely;
# ABSTRACT: Create test connections using IO::Pipely

use Mu;
use IO::Pipely qw(socketpairly);
use Fcntl;

use Epidermis::Lab::Connection::Generic;

lazy _globs => sub {
	[ my (
		$side_a_read,  $side_a_write,
		$side_b_read,  $side_b_write,
	) = socketpairly() ];
};

lazy connection0 => sub {
	my ($self) = @_;
	Epidermis::Lab::Connection::Generic->new(
		read_handle  => $self->_globs->[0],
		write_handle => $self->_globs->[1],
	)
};

lazy connection1 => sub {
	my ($self) = @_;
	Epidermis::Lab::Connection::Generic->new(
		read_handle  => $self->_globs->[2],
		write_handle => $self->_globs->[3],
	)
};

sub init { }

1;
