use strict;
use warnings;
no warnings 'once';
use B;
BEGIN {
  local $utf8::{is_utf8};
  require Sub::Quote;
}
die "Unable to disable utf8::is_utf8 and B::perlstring for testing"
  unless !Sub::Quote::_HAVE_IS_UTF8;
do './t/quotify.t' or die $@ || $!;
