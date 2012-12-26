#
# This file is part of Net-Amazon-R53
#
# This software is Copyright (c) 2012 by Campus Explorer, Inc.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Net::Amazon::R53::AtomicChange;
{
  $Net::Amazon::R53::AtomicChange::VERSION = '0.001'; # TRIAL
}

# ABSTRACT: Representation of an atomic change

use Moose;
use namespace::autoclean;
use Moose::Autobox;
use MooseX::AttributeShortcuts;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;

use aliased 'MooseX::CoercePerAttribute';

use constant ArrayOfStubs   => 'ArrayRef[Net::Amazon::R53::ResourceRecordSet::Stub]';
use constant ArrayOfChanges => 'ArrayRef[Net::Amazon::R53::ResourceRecordSet::Change]';

use constant HZ     => class_type 'Net::Amazon::R53::HostedZone';
use constant Stub   => class_type 'Net::Amazon::R53::ResourceRecordSet::Stub';
use constant Change => class_type 'Net::Amazon::R53::ResourceRecordSet::Change';

with 'MooseX::Traitor';
with 'Net::Amazon::R53::Role::ParentR53';


has [ qw{ alpha omega } ] => (
    traits => [ CoercePerAttribute ],
    is       => 'ro',
    isa      => ArrayOfStubs,
    required => 1,
    coerce => {
        HZ, sub { $_->resource_record_sets },
    },
);


has [ qw{ to_delete to_create } ] => (
    is       => 'lazy',
    isa      => ArrayOfStubs,
    builder  => 1,
    init_arg => undef,
);

sub _build_to_delete { shift->__builder('DELETE') }
sub _build_to_create { shift->__builder('CREATE') }

sub __builder {
    my ($self, $action) = @_;

    my @records =
        map  { $_->record            }
        grep { $_->action eq $action }
        $self->changes->flatten
        ;

    return \@records;
}


has changes => (
    traits   => ['Array'],
    is       => 'lazy',
    isa      => ArrayOfChanges,
    init_arg => undef,

    handles => {
        null_changeset    => 'is_empty',
        has_no_changes    => 'is_empty',
        has_changes       => 'count',
        number_of_changes => 'count',
        all_changes       => 'elements',
    },
);

sub _build_changes {
    my $self = shift @_;

    my $alpha = $self->alpha;
    my $omega = $self->omega;

    # in alpha but not omega -> delete
    # in omega but not alpha -> add
    my @delete = grep { $omega->none == $_ } $alpha->flatten;
    my @create = grep { $alpha->none == $_ } $omega->flatten;

    # return early if there's nothing left to do
    return [] unless @delete + @create;

    # only @create and @delete matter for our purposes anymore;
    # the rest are irrelevant to our operation

    my $_create = do {
        my $class = $self->resource_record_set__change_class;
        my $r53   = $self->r53;
        sub { $class->new(r53 => $r53, action => shift, record => shift) };
    };

    return [
        ( map { $_create->(CREATE => $_) } @create ),
        ( map { $_create->(DELETE => $_) } @delete ),
    ];
}

__PACKAGE__->meta->make_immutable;
!!42;

__END__

=pod

=encoding utf-8

=for :stopwords Chris Weyl Campus Explorer, Inc

=head1 NAME

Net::Amazon::R53::AtomicChange - Representation of an atomic change

=head1 VERSION

This document describes version 0.001 of Net::Amazon::R53::AtomicChange - released December 26, 2012 as part of Net-Amazon-R53.

=head1 SYNOPSIS

    # we have 2 sets of Stubs; a before (alpha) and after (omega)
    my $r53    = Net::Amazon::R53->new(...);
    my $hz     = $r53->hosted_zone_by_id('XXX');
    my @to_rrs = [ ... ];

    my $ac = $r53->atomic_change_class->new(
        alpha => [ $hz->resource_record_sets ],
        omega => [ @to_rrs                   ],
    );

    # apply our change to the zone in question; dies on failure
    my $change = $r53
      ->hosted_zone_by_id($id)
      ->apply_atomic_change($ac)
      ;

    # alternatively, just allow alpha to coerce the hosted zone instance
    my $ac = $r53->atomic_change_class->new(
        alpha => $hz,
        omega => [ @to_rrs ],
    );

=head1 DESCRIPTION

This class takes two sets of L<Net::Amazon::ResourceRecordSet::Stub>s and
calculates the CREATE and DELETE commands that would be needed to transform
the first set (alpha) into the second (omega).

Both sets can be specified as references to arrays of
L<Stubs|Net::Amazon::ResourceRecordSet::Stub> or as
L<HostedZone|Net::Amazon::R53::HostedZone> instances.  If specified as
HostedZone instances, they will be coerced to an array reference of Stubs
(remember that L<Net::Amazon::ResourceRecordSet> is actually a descendent of
L<Net::Amazon::ResourceRecordSet::Stub>, so they can be legally used here).

Note that we do not actually perform any changes; we merely calculate and
validate. To actually apply this change to a hosted zone, see
L<Net::Amazon::R53::HostedZone/apply_atomic_change>.

=head1 REQUIRED ATTRIBUTES

These attributes are required, and must have their values supplied during object construction.

=head2 alpha

This is the set of the "from" resource records.

Legal values:

* An ArrayRef of L<Stubs|Net::Amazon::R53::ResourceRecordSet::Stub>.

* L<HostedZone|Net::Amazon::R53::HostedZone> (coerced via
L<Net::Amazon::R53::HostedZone/resource_record_sets>).

=head2 omega

This is the set of the "to" resource records.

Legal values:

* An ArrayRef of L<Stubs|Net::Amazon::R53::ResourceRecordSet::Stub>.

* L<HostedZone|Net::Amazon::R53::HostedZone> (coerced via
L<Net::Amazon::R53::HostedZone/resource_record_sets>).

=head1 LAZY ATTRIBUTES

These attributes are lazily constructed from another source (e.g. required attributes, external source, a BUILD() method, or some combo thereof). You can set these values at construction time, though this is generally neither required nor recommended.

=head2 to_delete

The list of DELETE changes.

This attribute cannot be populated via the constructor.

=head2 to_create

The list of CREATE changes.

This attribute cannot be populated via the constructor.

=head2 changes

This is the set of L<Net::Amazon::Route53::ResourceRecordSet::Change>
representing what needs to be done to get from our alpha to our omega.

That is, this attribute contains all the C<DELETE> and C<CREATE> requests
needed to transform set alpha into set omega.

This attribute cannot be populated via the constructor.

=head1 METHODS

=head2 has_changes()

True if we have any changes to make.

=head2 has_no_changes(), null_changeset()

True if we have no changes to make (that is, alpha and omega are equivalent).

=head2 number_of_changes()

Our count of all changes.

=head2 all_changes()

All of our changes, but as a list, not an ArrayRef.

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
