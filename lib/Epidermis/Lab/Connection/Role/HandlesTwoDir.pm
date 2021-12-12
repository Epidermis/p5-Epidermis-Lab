package Epidermis::Lab::Connection::Role::HandlesTwoDir;
# ABSTRACT: Role for handles that are two-directional

use Moo::Role;
use MooX::Should;

use Types::Standard qw(InstanceOf);

has handle => (
	is => 'rwp',
	should => InstanceOf['IO::Handle'],
	init_arg => undef,
);

# Read and write handles are the same.
sub read_handle  { return $_[0]->handle; }
sub write_handle { return $_[0]->handle; }

with qw(Epidermis::Lab::Connection::Role::Handles);

1;
