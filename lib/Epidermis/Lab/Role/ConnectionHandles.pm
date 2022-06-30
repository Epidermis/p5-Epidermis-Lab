package Epidermis::Lab::Role::ConnectionHandles;
# ABSTRACT: Role that provides I/O handles via Connection

use Moo::Role;
use MooX::Should;
use Types::Standard  qw(ConsumerOf);

requires qw(read_handle write_handle);

has connection => (
	is => 'ro',
	should => ConsumerOf['Epidermis::Lab::Connection::Role::Handles'],
	required => 1,
	# implemented via BUILDARGS
	#handles => [ qw(read_handle write_handle) ],
);

around BUILDARGS => sub {
	my ( $orig, $class, @orig_args ) = @_;
	my $args = $class->$orig(@orig_args);

	if( exists $args->{connection} ) {
		for my $handle (qw(read_handle write_handle)) {
			$args->{$handle} = $args->{connection}->$handle;
		}
	}

	return $args;
};

1;
