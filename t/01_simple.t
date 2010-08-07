use strict;
use warnings;
use utf8;
use Test::More;

{
    package Req;
    use base qw/Plack::Request Plack::Request::Mixin::URIWith/;
}

my $req = Req->new({HTTP_HOST => 'example.com', PATH_INFO => '/foo/', SCRIPT_NAME => '/bar/', QUERY_STRING => 'key=orig'});
is $req->uri_with({key => 'value'}), 'http://example.com/bar/foo/?key=value';
is $req->uri_with({key => 'ジョン'}), 'http://example.com/bar/foo/?key=%E3%82%B8%E3%83%A7%E3%83%B3';
is $req->uri_with({key => 'ジョン'}, {mode => 'append'}), 'http://example.com/bar/foo/?key=orig&key=%E3%82%B8%E3%83%A7%E3%83%B3', 'append mode';

done_testing;

