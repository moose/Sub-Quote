use strict;
use warnings;
no warnings 'once';
use B;
eval { require XString };
BEGIN {
  local $utf8::{is_utf8};
  local $B::{perlstring};
  local $XString::{perlstring};
  require Sub::Quote;
}
die "Unable to disable utf8::is_utf8 and B::perlstring for testing"
  unless !Sub::Quote::_HAVE_IS_UTF8 && ! (
    \&Sub::Quote::_perlstring == \&B::perlstring
    || \&Sub::Quote::_perlstring == \&XString::perlstring
  );
do './t/quotify.t' or die $@ || $!;
