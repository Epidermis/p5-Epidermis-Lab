package Epidermis::Lab::Test::Connection::Serial::Socat;
# ABSTRACT: Serial pair using socat

use Mu;
use MooX::Should;

use Types::Standard qw(ArrayRef Str);
use Types::Common::Numeric qw(IntRange);

use Path::Tiny;

use File::Which;

use constant SOCAT_BIN => 'socat';

lazy _pty_tempdir => sub {
	my $tmpdir = Path::Tiny->tempdir;
	$tmpdir->mkpath;
	$tmpdir;
};

has message_level => (
	is => 'ro',
	should => IntRange[0,4],
	default => sub { 0 },
);

has socat_opts => (
	is => 'ro',
	should => ArrayRef[Str],
	default => sub { [] },
);

lazy _pty_pair => sub {
	my ($self) = @_;
	[ my @ptys = map {
		$self->_pty_tempdir->child("pty$_");
	} 0..1 ];
};

sub pty0 { $_[0]->_pty_pair->[0] }
sub pty1 { $_[0]->_pty_pair->[1] }

lazy command_arguments => sub {
	my ($self) = @_;
	my @socat_pty_config = qw(pty raw echo=0);
	[
		( qw(-d) x $self->message_level ),
		@{ $self->socat_opts },
		(
		map {
			join(",", @socat_pty_config, "link=$_"),
		} @{ $self->_pty_pair }
		)
	];
};

lazy command => sub {
	my ($self) = @_;
	my @cmd = (
		SOCAT_BIN,
		@{ $self->command_arguments },
	);
	\@cmd;
};

sub BUILD {
	die "Requires socat to build serial port pair" unless which(SOCAT_BIN);
}

sub DEMOLISH {
}

1;
