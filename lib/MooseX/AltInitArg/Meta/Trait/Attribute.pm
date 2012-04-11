package MooseX::AltInitArg::Meta::Trait::Attribute;
use Moose::Role;
use Moose::Util::TypeConstraints;
Moose::Util::meta_attribute_alias 'AltInitArg';

# ABSTRACT: attribute metaclass trait 


subtype 'MooseX::AltInitArg::ArrayRef', as 'ArrayRef[Str]';
coerce  'MooseX::AltInitArg::ArrayRef', from 'Str', via { [$_] };


has alt_init_args => (
    is         => 'ro',
    isa        => 'MooseX::AltInitArg::ArrayRef',
    coerce     => 1,
    predicate  => 'has_alt_init_args',
);


around initialize_instance_slot => sub {
    my $orig = shift;
    my $self = shift;
    my ($meta_instance, $instance, $params) = @_;

    return $self->$orig(@_)
        # don't run if we haven't set any alt_init_args
        # don't run if init_arg is explicitly undef
        unless $self->has_alt_init_args && $self->has_init_arg;

    if (my @alternates = grep { exists $params->{$_} } @{ $self->alt_init_args }) {
        if (exists $params->{ $self->init_arg }) {
            push @alternates, $self->init_arg;
        }

        $self->associated_class->throw_error(
            'Conflicting init_args: (' . join(', ', @alternates) . ')'
        ) if @alternates > 1;

        $params->{ $self->init_arg } = delete $params->{ $alternates[0] };
    }
    $self->$orig(@_);
};

no Moose::Role;

1;

__END__
