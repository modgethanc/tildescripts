#!/usr/bin/perl -w
use strict;

open IN, '/var/games/nethack/logfile';
my @log = <IN>;
close IN;

open OUT, ">", "www/nethackizens.html";
select OUT;

print "
<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n
<html>\n
<head>\n
<title>server nethack demographics</title>\n
<link href=\"/screen.css\" type=\"text/css\" rel=\"stylesheet\" />\n
</head>\n
<body>\n
<h1><a href=\"index.html\">~endorphant</a>@<a href=\"../\">ctrl-c.club</a></h1>\n
<h3>server nethack demographics</h3>\n
<ul>\n";

foreach (@log) {
	my @line = split(' ', $_);
	my $role = $line[11];
	my $race = $line[12];
	my $gender = $line[13];
	my $align = $line[14];
	my @tomb = split(',', $line[15]);
	my $user = shift(@tomb);
	
	
	print "<li>";
	print "user: $user; race: $race; role: $role; gender: $gender; alignment: $align"; #DEBUG LINE
	print "</li>\n";
}

print "</ul>\n</body>\n</html>\n";
close OUT;
