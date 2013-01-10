#
# This file is part of Net-Amazon-R53
#
# This software is Copyright (c) 2012 by Campus Explorer, Inc.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Net::Amazon::R53::ResourceRecordSet;
{
  $Net::Amazon::R53::ResourceRecordSet::VERSION = '0.002'; # TRIAL
}

# ABSTRACT: A representation of a ResourceRecordSet

use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints 'enum';
use MooseX::AlwaysCoerce;
use MooseX::AttributeShortcuts 0.017;
use MooseX::Types::Moose ':all';
use MooseX::Types::Common::Numeric ':all';
use MooseX::Types::Common::String ':all';

extends 'Net::Amazon::R53::ResourceRecordSet::Stub';

with 'MooseX::Traitor';
with
    'Net::Amazon::R53::Role::NewFromRawData',
    'Net::Amazon::R53::Role::ParentR53',
    ;

has r53_rrs_type => (
    is  => 'lazy',
    isa => enum [ qw{ standard alias weighted weighted_latency latency } ],
);

# XXX this feels... bad

sub _build_r53_rrs_type {
    my $self = shift @_;

    my $has_set_id  = $self->has_set_identifier;
    my $has_alias   = $self->has_alias_target;
    my $has_weight  = $self->has_weight;
    my $has_region  = $self->has_region;

    return 'standard'
        unless $has_set_id || $has_alias || $has_weight || $has_region;

    if ($has_alias) {

        confess 'invalid rrs type'
            if $has_set_id || $has_weight || $has_region;

        return 'alias';
    }

    ### assert: !$has_alias;

    # at least one remaining is false
    confess 'invalid rrs type'
        if $has_region && $has_set_id && $has_weight;

    return 'weighted_latency'
        if $has_weight && $has_set_id;

    ### assert: !$has_region

    return 'weighted'
        if $has_weight;

    ### assert: $has_region
    return 'latency';
}

sub is_standard_record_set   { shift->r53_rrs_type eq 'standard' }

__PACKAGE__->meta->make_immutable;
!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Campus Explorer, Inc

=head1 NAME

Net::Amazon::R53::ResourceRecordSet - A representation of a ResourceRecordSet

=head1 VERSION

This document describes version 0.002 of Net::Amazon::R53::ResourceRecordSet - released January 09, 2013 as part of Net-Amazon-R53.

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
