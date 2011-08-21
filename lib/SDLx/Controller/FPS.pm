package SDLx::Controller::FPS;
use strict;
use warnings;

# ABSTRACT: Fixed FPS controller for SDL

use Carp;
use Scalar::Util qw(refaddr);
use SDLx::FPS;

use base qw(SDLx::Controller);

my %_fps;
my %_move_ratio;
my %_stop;

sub new {
    my ( $class, %args ) = @_;

    my $fps   = exists $args{fps}        ? $args{fps}        : 30;
    my $ratio = exists $args{move_ratio} ? $args{move_ratio} : 1;

    if ( $ratio != int $ratio ) {
        carp "move_ratio must be an integer\n";
        $ratio = int $ratio;
    }

    $class = ref $class ? ref $class : $class;

    my $self = $class->SUPER::new(%args);

    my $ref = refaddr $self;

    $_fps{$ref} = SDLx::FPS->new( fps => $fps );
    $_move_ratio{$ref} = $ratio;

    return bless $self, $class;
}

sub DESTROY {
    my $self = shift;

    my $ref = refaddr $self;

    delete $_fps{$ref};
    delete $_move_ratio{$ref};
    delete $_stop{$ref};
}

sub run {
    my $self = shift;

    my $ref = refaddr $self;

    my $fps   = $_fps{$ref};
    my $ratio = $_move_ratio{$ref};

    $_stop{$ref} = 0;

    while ( !$_stop{$ref} ) {
        $self->_event($ref);

        for ( 1 .. $ratio ) {
            $self->_move($ref);
        }

        $fps->delay();

        $self->_show($ref);
    }
}

sub stop { $_stop{ refaddr $_[0] } = 1 }

1;
