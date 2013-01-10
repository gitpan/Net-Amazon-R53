#
# This file is part of Net-Amazon-R53
#
# This software is Copyright (c) 2012 by Campus Explorer, Inc.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Net::Amazon::R53::Role::NewFromRawData;
{
  $Net::Amazon::R53::Role::NewFromRawData::VERSION = '0.002'; # TRIAL
}

# ABSTRACT: Constructs instances from just the returned raw_data

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

use String::CamelCase 'decamelize';

# debugging...
#use Smart::Comments '###';


has raw_data => (is => 'ro', isa => 'HashRef', required => 1);


sub new_from_raw_data {
    my ($class, $r53, $raw_data, @other_args) = @_;

    my %params = (raw_data => $raw_data);
    my $meta = $class->meta;

    for my $key (keys %$raw_data) {

        my $att_name = decamelize $key;
        $key =~ s/::/__/g;
        $params{$att_name} = $raw_data->{$key}
            if $meta->find_attribute_by_name($att_name);
    }

    ### %params
    return $class->new(r53 => $r53, %params, @other_args);
}

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Campus Explorer, Inc

=head1 NAME

Net::Amazon::R53::Role::NewFromRawData - Constructs instances from just the returned raw_data

=head1 VERSION

This document describes version 0.002 of Net::Amazon::R53::Role::NewFromRawData - released January 09, 2013 as part of Net-Amazon-R53.

=head1 ATTRIBUTES

=head2 raw_data <HashRef>

The raw, parsed data from Route53.  This attribute is required.

=head1 METHODS

=head2 new_from_raw_data(<r53 instance>, <raw data hashref>)

This is an alternate constructor that creates an instance based on the raw
data returned by Route53; it's generally used internally.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Net::Amazon::R53|Net::Amazon::R53>

=back

=head1 AUTHOR

Chris Weyl <cweyl@campusexplorer.com>

=head1 CONTRIBUTOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Campus Explorer, Inc.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
