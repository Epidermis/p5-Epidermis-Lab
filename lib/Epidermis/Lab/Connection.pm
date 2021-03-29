package Epidermis::Lab::Connection;

use Moo;

has handle => (
	is => 'rwp',
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
