#
# This file is part of Net-Amazon-R53
#
# This software is Copyright (c) 2012 by Campus Explorer, Inc.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Net::Amazon::R53::Role::ParentR53;
{
  $Net::Amazon::R53::Role::ParentR53::VERSION = '0.001'; # TRIAL
}

# ABSTRACT: A role bestowing a parent link

use Moose::Role;
use utf8;
use namespace::autoclean;


my $_same = sub { $_[0] => $_[0] };

has r53 => (
    is       => 'ro',
    isa      => 'Net::Amazon::R53',
    required => 1,

    # TODO strictly for now -- need to autoconstruct role to provide the correct
    # parent attributes for us related classes
    handles => [ qw{
        atomic_change_class
        change_info_class
        resource_record_set_class
        resource_record_set__stub_class
        resource_record_set__change_class
    } ],
);

!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Campus Explorer, Inc

=head1 NAME

Net::Amazon::R53::Role::ParentR53 - A role bestowing a parent link

=head1 VERSION

This document describes version 0.001 of Net::Amazon::R53::Role::ParentR53 - released December 26, 2012 as part of Net-Amazon-R53.

=head1 REQUIRED ATTRIBUTES

These attributes are required, and must have their values supplied during object construction.

=head2 r53

The L<Net::Amazon::R53> this class belongs to.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Net::Amazon::R53|Net::Amazon::R53>

=back

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Campus Explorer, Inc.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
