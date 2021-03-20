package Epidermis::Lab::Test::Connection::Serial::Socat::Role::WithChild;
# ABSTRACT: Use Child to manage process

use Moo::Role;

use Child;
use Object::Util magic => 0;
use Time::HiRes qw(sleep);

use constant SLEEP_INTERVAL => 0.001;

requires 'command';

has _child_proc => (
	is => 'rw',
);

sub start_via_child {
	my ($self) = @_;
	my @cmd = @{ $self->command };
	my $child = Child->new(sub {
		my ($parent) = @_;
		exec( @cmd );
	});

	$self->_child_proc($child->start);

	# wait until files created or 2 seconds
	my $actual_sleep = 0;
	$actual_sleep += sleep SLEEP_INTERVAL while ! $self->_ptys_exist && $actual_sleep < 2;
	if( ! $self->_ptys_exist ) {
		die "Could not create ptys";
	}
}

sub _ptys_exist {
	my ($self) = @_;
	-e $self->pty0 && -e $self->pty1;
}

after DEMOLISH => sub {
	my ($self) = @_;
	$self->_child_proc->$_call_if_object( kill => 9 );
};

1;
