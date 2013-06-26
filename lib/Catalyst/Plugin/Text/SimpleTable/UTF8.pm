package Catalyst::Plugin::Text::SimpleTable::UTF8;

use Moose::Role;
use Text::SimpleTable::UTF8;

my @logs = do {
    require Catalyst;
    grep { /^log_/ } Catalyst->meta->get_method_list;
};

around \@logs => sub {
    my $orig = shift;
    my $c = shift;

    no strict 'refs';
    no warnings 'redefine';
    local *{"Text::SimpleTable::new"} = sub {
        shift;
        Text::SimpleTable::UTF8->new(@_);
    };

    $c->$orig(@_);
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Catalyst::Plugin::Text::SimpleTable::UTF8 - テストサーバーでのテーブル表示で、UTF8が崩れないようにする。

=head1 SYNOPSIS

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

=cut
