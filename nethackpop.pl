#!/usr/bin/perl -w
use strict;
#use List::MoreUtils qw(uniq);


open IN, '/var/games/nethack/logfile';
my @log = <IN>;
close IN;

open OUT, ">", "www/nethackizens.html";
select OUT;

my @userCount;

my %empires;

# NOTES
# let's make a map of empire=>array; array contains male/female and alignment count

print "
<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n
<html>\n
<head>\n
<title>server nethack demographics</title>\n
<link href=\"/screen.css\" type=\"text/css\" rel=\"stylesheet\" />\n
</head>\n
<body>\n
<h1><a href=\"index.html\">~endorphant</a>@<a href=\"../\">ctrl-c.club</a></h1>\n
<h3>server nethack demographics</h3>\n ";


#print "<ul>\n";

foreach (@log) {
	my @line = split(' ', $_);
	my $role = $line[11];
	my $race = $line[12];
	my $gender = $line[13];
	my $align = $line[14];
	my @tomb = split(',', $line[15]);
	my $user = shift(@tomb);
	
	push(@userCount, $user);	

	#print "<li>";
	#print "user: $user; race: $race; role: $role; gender: $gender; alignment: $align"; #DEBUG LINE
	#print "</li>\n";
}

#my @users = uniq(@userCount);

my @users;

foreach my $self (@userCount) {
	if (grep {$_ eq $self } @users) {
	} else {
		push(@users, $self);
	}
}

print "</ul>\n
<ul>\n";

foreach my $target (@users) {
	my $count;
	foreach my $curr (@userCount) {
		if ($curr =~ $target) {
			$count++;
		}
	}

	print "<li>the empire of $target has a population of $count</li>\n";
}

print "</ul>\n</body>\n</html>\n";
close OUT;
