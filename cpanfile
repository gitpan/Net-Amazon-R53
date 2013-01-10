requires "Data::Compare" => "0";
requires "Data::UUID" => "0";
requires "File::ShareDir::ProjectDistDir" => "0";
requires "HTTP::Request" => "0";
requires "LWP::UserAgent::Determined" => "0";
requires "List::AllUtils" => "0";
requires "Moose" => "0";
requires "Moose::Autobox" => "0";
requires "Moose::Role" => "0";
requires "Moose::Util::TypeConstraints" => "0";
requires "MooseX::AlwaysCoerce" => "0";
requires "MooseX::AttributeShortcuts" => "0.017";
requires "MooseX::CascadeClearing" => "0";
requires "MooseX::CoercePerAttribute" => "0";
requires "MooseX::MarkAsMethods" => "0";
requires "MooseX::Params::Validate" => "0";
requires "MooseX::RelatedClasses" => "0";
requires "MooseX::StrictConstructor" => "0";
requires "MooseX::Traitor" => "0";
requires "MooseX::Types::Common::Numeric" => "0";
requires "MooseX::Types::Common::String" => "0";
requires "MooseX::Types::Moose" => "0";
requires "MooseX::Types::Path::Class" => "0";
requires "MooseX::Types::VariantTable" => "0";
requires "Net::Amazon::Signature::V3" => "0";
requires "Net::DNS" => "0.71";
requires "String::CamelCase" => "0";
requires "Template" => "0";
requires "XML::Simple" => "0";
requires "aliased" => "0";
requires "autobox::Core" => "0";
requires "constant" => "0";
requires "namespace::autoclean" => "0";
requires "overload" => "0";
requires "perl" => "v5.10.0";
requires "utf8" => "0";

on 'test' => sub {
  requires "Net::DNS" => "0";
  requires "Net::DNS::ZoneFile" => "0";
  requires "Path::Class" => "0";
  requires "Readonly" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::More" => "0.88";
  requires "Test::Requires" => "0";
  requires "Tie::IxHash" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
  requires "File::ShareDir::Install" => "0.03";
};

on 'develop' => sub {
  requires "version" => "0.9901";
};
