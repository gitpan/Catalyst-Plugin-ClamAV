package TestApp;

use strict;
use Catalyst;
use Data::Dumper;

our $VERSION = '0.01';

TestApp->config(
    name   => 'TestApp',
    clamav => {
       socket_name => $ENV{CLAMAV_SOCKET_NAME},
       socket_host => $ENV{CLAMAV_SOCKET_HOST},
       socket_port => $ENV{CLAMAV_SOCKET_PORT},
    },
);

# Fail gracefully if we don't have FastMmap
TestApp->setup( qw/ClamAV/ );

sub upload : Local {
    my ( $self, $c ) = @_;

    my $num = $c->clamscan( 'file1', 'file2' );
    if($num > 0){
        $c->log->info('VIRUS found.');
    } elsif ($num == 0) {
        $c->log->info('VIRUS not found.');
    } else {
        $c->log->info('not checked.');
    }

    $c->res->output( $num );
}

1;
