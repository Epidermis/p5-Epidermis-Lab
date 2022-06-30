package Epidermis::Lab::Role::ConnectionHandles;
# ABSTRACT: Role that provides I/O handles via Connection

use Moo::Role;
use MooX::Should;
use Types::Standard  qw(ConsumerOf);

has connection => (
	is => 'ro',
	should => ConsumerOf['Epidermis::Lab::Connection::Role::Handles'],
	required => 1,
	handles => [ qw(read_handle write_handle) ],
);

1;
