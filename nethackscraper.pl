#!/usr/bin/perl -w
use strict;

open IN, "/var/games/nethack/logfile";
my @log = <IN>;
close IN;

open IN, "/home/endorphant/public_html/nethacklog.txt";
my @old = <IN>;
close IN;

my @new;

foreach (@old) {
	push (@new, $_);
}

my $i = 0;

foreach my $newEntry (@log) {
	foreach my $oldEntry (@old) {
		if ($newEntry =~ $oldEntry) {	
			delete $log[$i];
		} 
	}
	$i++;
}

foreach (@log) {
	push(@new, $_);
}


open OUT, ">", "/home/endorphant/public_html/nethacklog.txt";
select OUT;
print @new;
close OUT;
