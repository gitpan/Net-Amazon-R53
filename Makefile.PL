
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "An interface to Amazon's Route53",
  "AUTHOR" => "Chris Weyl <cweyl\@alumni.drew.edu>",
  "BUILD_REQUIRES" => {
    "Net::DNS" => 0,
    "Net::DNS::ZoneFile" => 0,
    "Path::Class" => 0,
    "Readonly" => 0,
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "Test::Requires" => 0,
    "Tie::IxHash" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "Net-Amazon-R53",
  "EXE_FILES" => [],
  "LICENSE" => "lgpl",
  "NAME" => "Net::Amazon::R53",
  "PREREQ_PM" => {
    "Data::Compare" => 0,
    "Data::UUID" => 0,
    "File::ShareDir::ProjectDistDir" => 0,
    "HTTP::Request" => 0,
    "LWP::UserAgent" => 0,
    "List::AllUtils" => 0,
    "Moose" => 0,
    "Moose::Autobox" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::AlwaysCoerce" => 0,
    "MooseX::AttributeShortcuts" => "0.017",
    "MooseX::CascadeClearing" => 0,
    "MooseX::CoercePerAttribute" => 0,
    "MooseX::MarkAsMethods" => 0,
    "MooseX::Params::Validate" => 0,
    "MooseX::RelatedClasses" => 0,
    "MooseX::StrictConstructor" => 0,
    "MooseX::Traitor" => 0,
    "MooseX::Types::Common::Numeric" => 0,
    "MooseX::Types::Common::String" => 0,
    "MooseX::Types::Moose" => 0,
    "MooseX::Types::Path::Class" => 0,
    "MooseX::Types::VariantTable" => 0,
    "Net::Amazon::Signature::V3" => 0,
    "Net::DNS" => "0.71",
    "String::CamelCase" => 0,
    "Template" => 0,
    "XML::Simple" => 0,
    "aliased" => 0,
    "autobox::Core" => 0,
    "constant" => 0,
    "namespace::autoclean" => 0,
    "overload" => 0,
    "utf8" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t t/live/*.t t/loaders/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


