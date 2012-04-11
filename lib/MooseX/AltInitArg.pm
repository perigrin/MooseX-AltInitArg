package MooseX::AltInitArg;
use Moose();

use Moose::Exporter;
use MooseX::AltInitArg::Meta::Trait::Attribute;

Moose::Exporter->setup_import_methods(
    class_metaroles => { class => ['MooseX::AltInitArg::Meta::Trait::Class'] }
);

1;
__END__
