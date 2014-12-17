#!/usr/bin/perl -w
use strict;


open IN, '/var/games/nethack/logfile';
my @log = <IN>;
close IN;

open OUT, ">", "/home/endorphant/scripts/www/nethacklog.html";
select OUT;
#print @log;

print "<ol>\n";

foreach (@log) {
	my @line = split(' ', $_);
	shift(@line);
	print "<li>";
	print join(' ', @line);
	print "</li>\n";
}

print "</ol>";

close OUT;
