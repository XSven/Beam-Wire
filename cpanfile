requires "Beam::Emitter" => "0";
requires "Beam::Service" => "0";
requires "Config::Any" => "0.23";
requires "Data::DPath" => "0.51";
requires "Module::Runtime" => "0";
requires "Moo" => "0";
requires "Path::Tiny" => "0.055";
requires "Throwable" => "0";
requires "Types::Standard" => "0";
requires "YAML" => "0";
recommends "JSON" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::Deep" => "0";
  requires "Test::Differences" => "0.64";
  requires "Test::Exception" => "0";
  requires "Test::Lib" => "0";
  requires "Test::More" => "1.001005";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "CPAN::Meta::Requirements" => "2.120620";
  requires "ExtUtils::MakeMaker" => "0";
  requires "Module::Metadata" => "0";
};
