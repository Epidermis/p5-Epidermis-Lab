package Epidermis::Lab::Connection::Generic;
# ABSTRACT: A generic connection for read and write

use Moo;
use MooX::Should;

use Types::Standard qw(FileHandle);

has [qw(read_handle write_handle)] => (
	is => 'ro',
	should => FileHandle,
);

sub io_async_setup_keep {
	my ($self) = @_;
	return (
		$self->read_handle  ,=> ['keep'],
		$self->write_handle ,=> ['keep'],
	);
}

with qw(Epidermis::Lab::Connection::Role::Handles);

1;
