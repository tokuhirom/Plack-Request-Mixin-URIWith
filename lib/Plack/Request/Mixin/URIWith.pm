package Plack::Request::Mixin::URIWith;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use Carp ();
use URI::QueryParam;

sub uri_with {
    my( $self, $args, $behavior) = @_;

    Carp::carp( 'No arguments passed to uri_with()' ) unless $args;

    my $append = 0;
    if((ref($behavior) eq 'HASH') && defined($behavior->{mode}) && ($behavior->{mode} eq 'append')) {
        $append = 1;
    }

    my $params = do {
        foreach my $value ( values %$args ) {
            next unless defined $value;
            for ( ref $value eq 'ARRAY' ? @$value : $value ) {
                $_ = "$_";
                utf8::encode($_) if utf8::is_utf8($_);
            }
        }

        my %params = %{ $self->uri->query_form_hash };
        foreach my $key ( keys %{$args} ) {
            my $val = $args->{$key};
            if ( defined($val) ) {

                if ( $append && exists( $params{$key} ) ) {

                  # This little bit of heaven handles appending a new value onto
                  # an existing one regardless if the existing value is an array
                  # or not, and regardless if the new value is an array or not
                    $params{$key} = [
                        ref( $params{$key} ) eq 'ARRAY'
                        ? @{ $params{$key} }
                        : $params{$key},
                        ref($val) eq 'ARRAY' ? @{$val} : $val
                    ];

                }
                else {
                    $params{$key} = $val;
                }
            }
            else {

                # If the param wasn't defined then we delete it.
                delete( $params{$key} );
            }
        }
        \%params;
    };

    my $uri = $self->uri->clone;
    $uri->query_form($params);

    return $uri;
}


1;
__END__

=encoding utf8

=head1 NAME

Plack::Request::Mixin::URIWith - $req->uri_with() for Plack::Request.

=head1 SYNOPSIS

    package My::Request;
    use parent qw/Plack::Request Plack::Request::Mixin::URIWith/;

    package main;

    my $req = My::Request->new($env);
    $req->uri_with({key => 'val'});

=head1 DESCRIPTION

Plack::Request::Mixin::URIWith is mixin library for Plack::Request.

This mixin provides uri rewriter.

=head2 $req->uri_with( { key => 'value' } );

Returns a rewritten URI object for the current request. Key/value pairs
passed in will override existing parameters. You can remove an existing
parameter by passing in an undef value. Unmodified pairs will be
preserved.

You may also pass an optional second parameter that puts C<uri_with> into
append mode:

  $req->uri_with( { key => 'value' }, { mode => 'append' } );

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

some part of the code was taken from L<Catalyst>.

=head1 THANKS TO

L<Catalyst> committers.

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

some part of code/document is taken from L<Catalyst>.

=cut
