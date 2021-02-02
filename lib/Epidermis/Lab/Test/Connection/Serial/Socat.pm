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
	my @ptys = map {
		$self->_pty_tempdir->child("pty$_");
	} 0..1;

	my @socat_pty_config = qw(pty raw echo=0);
	my @cmd = (
		qw(socat),
		#qw(-d -d -d -d),
		#qw(-d -d),
		(
		map {
			join(",", @socat_pty_config, "link=$_"),
		} @ptys
		)
	);
	my $child = Child->new(sub {
		my ($parent) = @_;
		#print "@cmd\n";
		exec( @cmd );
	});

	$self->_proc($child->start);
	sleep 1;

	\@ptys;
};

sub pty0 { $_[0]->_pty_pair->[0] }
sub pty1 { $_[0]->_pty_pair->[1] }


sub BUILD {
	die "Requires socat to build serial port pair" unless which('socat');
}

sub DEMOLISH {
	my ($self) = @_;
	$self->_proc->$_call_if_object( kill => 9 );
}

1;
