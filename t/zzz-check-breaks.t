use strict;
use warnings;

# this test is similar to what is generated by Dist::Zilla::Plugin::Test::CheckBreaks 0.007

use Test::More;
eval 'require CPAN::Meta::Requirements; 1'
    or plan skip_all => 'CPAN::Meta::Requirements required for checking breakages';
eval 'use CPAN::Meta::Check 0.007; 1'
    or plan skip_all => 'CPAN::Meta::Check 0.007 required for checking breakages';

my $breaks = {
    'HTML::Restrict' => '== 2.1.5',
};

pass 'checking breakages...';

my $reqs = CPAN::Meta::Requirements->new;
$reqs->add_string_requirement($_, $breaks->{$_}) foreach keys %$breaks;

our $result = CPAN::Meta::Check::check_requirements($reqs, 'conflicts');

if (my @breaks = sort grep { defined $result->{$_} } keys %$result)
{
    diag 'Breakages found with Moo';
    diag "$result->{$_}" for @breaks;
    diag "\n", 'You should now update these modules!';
}

done_testing;