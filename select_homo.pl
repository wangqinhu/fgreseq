#!/usr/bin/perl

open (IN, $ARGV[0]) or die $!;

while (<IN>) {
	print $_ unless /\t0\/1:/;
}
close IN;
