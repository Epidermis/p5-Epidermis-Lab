package Epidermis::Lab::Test::Connection::Serial::Socat::Role::WithChild;
# ABSTRACT: Use Child to manage process

use Moo::Role;

use Child;
use Object::Util magic => 0;

requires 'command';

has _child_proc => (
	is => 'rw',
);

sub start_via_child {
	my ($self) = @_;
	my @cmd = @{ $self->command };
	my $child = Child->new(sub {
		my ($parent) = @_;
		#print "@cmd\n";
		exec( @cmd );
	});

	$self->_child_proc($child->start);
}

after DEMOLISH => sub {
	my ($self) = @_;
	$self->_child_proc->$_call_if_object( kill => 9 );
};

1;
