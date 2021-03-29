package Epidermis::Lab::Connection;

use Moo;
use MooX::Should;

use Types::Standard qw(InstanceOf);

has handle => (
	is => 'rwp',
	should => InstanceOf['IO::Handle'],
	init_arg => undef,
);

sub is_open {
	my ($self) = @_;
	defined $self->handle;
}

sub open_handle {
	my ($self) = @_;
	...
}

1;
