use utf8;
use strict;
use Test::More;

BEGIN { $ENV{CATALYST_DEBUG} = 1; }
use Data::Section::Simple qw(get_data_section);
use Encode;
use IO::CaptureOutput qw(capture);
use URI;

sub Dump { require YAML::Syck; goto &YAML::Syck::Dump }

{
    require Catalyst::Utils;;
    no strict 'refs';
    *{"Catalyst::Utils::term_width"} = sub { 60 };
}

capture { use_ok('Catalyst::Test', 't::lib::TestApp') };

{
    my $uri = URI->new("/");
    $uri->query_form( いただきます => "ごちそうさま" );

    my $out;
    my ($res, $c);
    capture { ($res, $c) = ctx_request($uri->as_string) } \$out, \$out;

    my $params = $c->req->params;
    is_deeply($params, { いただきます => "ごちそうさま" } ) or diag Dump $c->req->params;

    is( $res->content, "Hello World!" );

    $out = decode('utf8', $out);
    ok( $out =~ /\Q@{[ get_data_section('good01') ]}\E/ ) or diag $out;
}

done_testing();

__DATA__

@@ good01
.-------------------------------------+------------------.
| Parameter                           | Value            |
+-------------------------------------+------------------+
| いただきます                        | ごちそうさま     |
'-------------------------------------+------------------'
