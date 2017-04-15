use strict;
use warnings;
no warnings 'once';
use Test::More;
use Test::Fatal;
use Data::Dumper;

use Sub::Quote qw(
  quotify
);

my $dump = sub {
  local $Data::Dumper::Terse = 1;
  my $d = Data::Dumper::Dumper($_[0]);
  $d =~ s/\s+$//;
  $d;
};

sub is_numeric {
  my $val = shift;
  my $sv = B::svref_2object(\$val);
  !!($sv->FLAGS & ( B::SVp_IOK | B::SVp_NOK ) )
}

my @strings = (0, 1, "\x00", "a", "\xFC", "\x{1F4A9}");

my @failed = grep {
  my $o = eval quotify($_);
  !(defined $o ? ($o eq $_ && is_numeric($o) == is_numeric($_) ) : !defined $_)
} @strings;

ok !@failed, "evaling quotify returns same value for all strings"
  or diag "Failed strings: " . join(' ', map { $dump->($_) } @failed);

SKIP: {
  skip "working utf8 pragma not available", 1
    if "$]" < 5.008_000;
  my $eval_utf8 = eval 'sub { eval "use utf8; " . quotify($_[0]) }';

  my @failed_utf8 = grep { my $o = $eval_utf8->($_); !defined $o || $o ne $_ }
    @strings;
  ok !@failed_utf8, "evaling quotify under utf8 returns same value for all strings"
    or diag "Failed strings: " . join(' ', map { $dump->($_) } @failed_utf8);
}

unlike Sub::Quote::quotify($_), qr/[^0-9.-]/,
  "quotify preserves $_ as number"
  for 0, 1, 1.5, 0.5, -10;

done_testing;
