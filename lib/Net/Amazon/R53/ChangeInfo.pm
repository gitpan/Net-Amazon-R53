#
# This file is part of Net-Amazon-R53
#
# This software is Copyright (c) 2012 by Campus Explorer, Inc.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Net::Amazon::R53::ChangeInfo;
{
  $Net::Amazon::R53::ChangeInfo::VERSION = '0.002'; # TRIAL
}

# ABSTRACT: Contains change info for aidempotent Route53 requests

use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints 'enum';
use MooseX::AttributeShortcuts;
use MooseX::StrictConstructor;

use constant ValidStatuses => enum [ qw{ PENDING INSYNC } ];

with 'MooseX::Traitor';
with
    'Net::Amazon::R53::Role::NewFromRawData',
    'Net::Amazon::R53::Role::ParentR53',
    ;


has id           => (is => 'ro',  isa => 'Str',         required => 1);
has status       => (is => 'rwp', isa => ValidStatuses, required => 1);
has submitted_at => (is => 'ro',  isa => 'Str',         required => 1);


sub is_complete { shift->status eq 'INSYNC' }

__PACKAGE__->meta->make_immutable;
!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Campus Explorer, Inc aidempotent PENDING INSYNC

=head1 NAME

Net::Amazon::R53::ChangeInfo - Contains change info for aidempotent Route53 requests

=head1 VERSION

This document describes version 0.002 of Net::Amazon::R53::ChangeInfo - released January 09, 2013 as part of Net-Amazon-R53.

=head1 DESCRIPTION

This class represents a information corresponding to a change submitted to
Route53.  You will probably never need to create one of these yourself.

=head1 REQUIRED ATTRIBUTES

These attributes are required, and must have their values supplied during object construction.

=head2 id

The change id as returned from Route53.

=head2 status

The status as of last check; will be either 'PENDING' or 'INSYNC'.

=head2 submitted_at

The date/time the request this change identified was submitted to Route53.

=head1 METHODS

=head2 is_complete

Returns true if the request is complete (that is, the request has been
accepted by Route53 and propagated through the Route53 infrastructure).

Note that this is the same as status being 'INSYNC'.

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
