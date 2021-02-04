package Epidermis::Lab::Connection::Serial;
# ABSTRACT: A connection for serial binary data exchange

use Moo;

use Fcntl ();
use if $^O ne 'MSWin32', 'IO::Termios', ();
use if $^O ne 'MSWin32', 'IO::Stty', ();

has device => (
	is => 'ro',
	required => 1,
);

has mode => (
	is => 'ro',
	predicate => 1,
);

has handle => (
	is => 'rwp',
	init_arg => undef,
);

sub is_open {
	my ($self) = @_;
	defined $self->handle;
}

sub open {
	my ($self) = @_;

	sysopen my $fh, $self->device, Fcntl::O_RDWR
		or die "sysopen failed on @{[ $self->device ]}: $!";
	my $handle = IO::Termios->new( $fh )
		or die "using IO::Termios failed on @{[ $self->device ]}: $!";
	$self->_set_handle( $handle );
	if( $self->has_mode ) {
		$self->handle->set_mode( $self->mode );
	}
}

1;
