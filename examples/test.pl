#!/usr/bin/env perl
use strict;
use warnings;
use SDLx::App;
use SDLx::Controller::FPS;

my $app = SDLx::App->new();

my $controller = SDLx::Controller::FPS->new(
    fps        => 15,
    move_ratio => 2,
    eoq        => 1,
);

my $rect = {
    x => 0,
    y => 0,
    w => 25,
    h => 25,
};

$controller->add_move_handler(
    sub {
        $rect->{x} += 1;
        $rect->{y} += 1;
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

