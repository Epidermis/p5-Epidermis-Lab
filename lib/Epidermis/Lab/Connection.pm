package Epidermis::Lab::Connection;

use Moo;
use MooX::Should;

use Types::Standard qw(InstanceOf);

has handle => (
	is => 'rwp',
	should => InstanceOf['IO::Handle'],
	init_arg => undef,
);

1;
