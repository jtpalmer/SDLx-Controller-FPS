#!/usr/bin/env perl
use strict;
use warnings;
use SDL::Event;
use SDL::Events;
use SDLx::App;
use SDLx::Controller::FPS;

print <<'EOT';
Press 1, 2 or 3 to change the ratio of "moves" to "shows"
EOT

my $app = SDLx::App->new(
    w => 320,
    h => 240,
);

my $fps = 30;

my $controller = SDLx::Controller::FPS->new(
    fps => $fps,
    eoq => 1,
);

my $rect = {
    x  => 0,
    y  => 0,
    w  => 25,
    h  => 25,
    vx => 1.5,
    vy => 1.5,
};

$controller->add_event_handler(
    sub {
        my ($event) = @_;

        if ( $event->type == SDL_KEYDOWN ) {

            my $key = SDL::Events::get_key_name( $event->key_sym );

            if ( $key =~ /^[123]$/ ) {
                $controller->fps( $fps / $key );
                $controller->move_ratio($key);
            }
        }
    }
);

$controller->add_move_handler(
    sub {
        $rect->{x} += $rect->{vx};
        $rect->{y} += $rect->{vy};

        if ( $rect->{vx} < 0 && $rect->{x} < 0 ) {
            $rect->{vx} *= -1;
        }

        if ( $rect->{vy} < 0 && $rect->{y} < 0 ) {
            $rect->{vy} *= -1;
        }

        if ( $rect->{vx} > 0 && $rect->{x} > $app->w - $rect->{w} ) {
            $rect->{vx} *= -1;
        }

        if ( $rect->{vy} > 0 && $rect->{y} > $app->h - $rect->{h} ) {
            $rect->{vy} *= -1;
        }
    }
);

$controller->add_show_handler(
    sub {
        $app->draw_rect( undef, 0 );
        $app->draw_rect( [ @$rect{qw( x y w h )} ], 0xFF000000 );
        $app->update();
    }
);

$controller->run();

