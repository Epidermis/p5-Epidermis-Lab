package Epidermis::Lab::Test::Connection::Serial::Socat;
# ABSTRACT: Serial pair using socat

use Mu;

use Path::Tiny;

use File::Which;
use Child;
use Object::Util magic => 0;

has _proc => (
	is => 'rw',
);

lazy _pty_tempdir => sub {
	my $tmpdir = Path::Tiny->tempdir;
	$tmpdir->mkpath;
	$tmpdir;
};

lazy _pty_pair => sub {
	my ($self) = @_;
	my $sender_pty = $self->_pty_tempdir->child("sender-side");
	my $receiver_pty = $self->_pty_tempdir->child("receiver-side");

	my @socat_pty_config = qw(pty raw echo=0);
	my @cmd = (
		qw(socat),
		#qw(-d -d -d -d),
		#qw(-d -d),
		join(",", @socat_pty_config, "link=$sender_pty"),
		join(",", @socat_pty_config, "link=$receiver_pty"),
	);
	my $child = Child->new(sub {
		my ($parent) = @_;
		#print "@cmd\n";
		exec( @cmd );
	});

	$self->_proc($child->start);
	sleep 1;

	[ $sender_pty, $receiver_pty ];
};

sub sender_pty   { $_[0]->_pty_pair->[0] }
sub receiver_pty { $_[0]->_pty_pair->[1] }


sub BUILD {
	die "Requires socat to build serial port pair" unless which('socat');
}

sub DEMOLISH {
	my ($self) = @_;
	$self->_proc->$_call_if_object( kill => 9 );
}

1;
