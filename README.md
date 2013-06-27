# NAME

Catalyst::Plugin::Text::SimpleTable::UTF8 - テストサーバーでのテーブル表示で、UTF8が崩れないようにする。

# SYNOPSIS

Catalystアプリで。

    package TestApp;

    use Moose;
    extends qw(Catalyst);

    __PACKAGE__->config(
        encoding => 'utf8',
    );

    override _default_plugins => sub { map { $_ eq "Unicode::Encoding" ? $_."::HashKey" : () } super };

    __PACKAGE__->setup(
        "Text::SimpleTable::UTF8",
    );

コンソールは。

    [info] *** Request 1 (1.000/s) [71637] [Thu Jun 27 02:50:43 2013] ***
    [debug] Path is "/"
    [debug] "GET" request for "/" from "127.0.0.1"
    [debug] Query Parameters are:
    .-------------------------------------+------------------.
    | Parameter                           | Value            |
    +-------------------------------------+------------------+
    | いただきます                        | ごちそうさま     |
    '-------------------------------------+------------------'
    [debug] Response Code: 200; Content-Type: unknown; Content-Length: 12
    [info] Request took 0.004665s (214.362/s)
    .----------------------------------------+-----------.
    | Action                                 | Time      |
    +----------------------------------------+-----------+
    | /index                                 | 0.000118s |
    '----------------------------------------+-----------'
