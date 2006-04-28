use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Catalyst::Test 'TestApp';
use HTTP::Request::Common;
use Data::Dumper;

plan tests => 3;

# test a single file upload
{
    my $request = POST(
        "http://localhost/upload",
        'Content-Type' => 'multipart/form-data',
        'Content'      => [
            'file1' => [
                undef,
                'foo.txt',
                'Content-Type' => 'text/plain',
                Content => 'x' x 1024,
            ],
            'file2' => [
                undef,
                'bar.txt',
                'Content-Type' => 'text/plain',
                Content => 'y' x 1024,
            ],
        ]
    );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Upload ok' );

    my $content = $response->content;
    ok( $content =~ /^(0|-1)$/xms, 'Scan ok' )
}
