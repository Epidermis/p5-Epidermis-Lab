package Epidermis::Lab::Connection::Role::HandlesTwoDir;
# ABSTRACT: Role for handles that are two-directional

use Moo::Role;
use MooX::Should;

use Types::Standard qw(FileHandle);

has handle => (
	is => 'rwp',
	should => FileHandle,
	init_arg => undef,
);

# Read and write handles are the same.
sub read_handle  { return $_[0]->handle; }
sub write_handle { return $_[0]->handle; }

sub io_async_setup_keep {
	my ($self) = @_;
	return (
		$self->handle ,=> ['keep'],
	);
}

with qw(Epidermis::Lab::Connection::Role::Handles);

1;
