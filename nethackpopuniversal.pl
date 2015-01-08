#!/usr/bin/perl -w
#use strict;
use feature qw(switch);
no warnings 'experimental::smartmatch';

open IN, '/home/endorphant/scripts/town.txt';
my @town = <IN>;
close IN;

open IN, '/home/endorphant/scripts/farm.txt';
my @farm = <IN>;
close IN;

open IN, '/home/endorphant/scripts/ctrlc.txt';
my @ctrlc = <IN>;
close IN;

open IN, '/home/endorphant/scripts/club6.txt';
my @club6 = <IN>;
close IN;

my @universal;
push(@universal, @town);
push(@universal, @farm);
push(@universal, @ctrlc);
push(@universal, @club6);

open IN, '/home/endorphant/scripts/empireheader.txt';
my @header = <IN>;
close IN;

sub parseLog {
	my @log = @{$_[0]};
	my %empires = ();

	foreach (@log) {
		my @line = split(' ', $_);
		my $role = $line[11];
		my $race = $line[12];
		my $gender = $line[13];
		my $align = $line[14];
		my @tomb = split(',', $line[15]);
		my $user = shift(@tomb);
		my $score = $line[1];
		
		if (!exists $empires{$user}) {
			$empires{$user} = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			# 0 pop 1 m 2 f 3 chao 4 neu 5 law 6 hum 7 dwa 8 elf 9 gno 10 orc 11 score
		} 
	
		$empires{$user}[0]++;
		$empires{$user}[11] += $score;
		
		given ($gender) {
			when (/Mal/) { $empires{$user}[1]++ ;}
			when (/Fem/) { $empires{$user}[2]++ ;}
		}
	
		given ($align) {
			when (/Cha/) { $empires{$user}[3]++ ;}
			when (/Neu/) { $empires{$user}[4]++ ;}
			when (/Law/) { $empires{$user}[5]++ ;}
		}
		
		given ($race) {
			when (/Hum/) { $empires{$user}[6]++ ;}
			when (/Dwa/) { $empires{$user}[7]++ ;}
			when (/Elf/) { $empires{$user}[8]++ ;}
			when (/Gno/) { $empires{$user}[9]++ ;}
			when (/Orc/) { $empires{$user}[10]++ ;}
		}	
	}
	return %empires;
}

sub printEmpire {
	my %empires = %{$_[0]};
	my $local = $_[1];

	for (sort keys %empires) {
 		my $alignment = "divided";
	
		if (($empires{$_}[3] > $empires{$_}[4]) && ($empires{$_}[3] > $empires{$_}[5])) {
			$alignment = "chaotic";
		}
	
		if (($empires{$_}[4] > $empires{$_}[3]) && ($empires{$_}[4] > $empires{$_}[5])) {
			$alignment = "neutral";
		}

		if (($empires{$_}[5] > $empires{$_}[4]) && ($empires{$_}[5] > $empires{$_}[3])) {
			$alignment = "lawful";
		}

		my $civ = "venture";

		if ($empires{$_}[0] > 1) { $civ = "party"; }
		if ($empires{$_}[0] > 4) { $civ = "gang"; }
		if ($empires{$_}[0] > 11) { $civ = "patrol"; }
		if ($empires{$_}[0] > 24) { $civ = "outpost"; }
		if ($empires{$_}[0] > 39) { $civ = "village"; }
		if ($empires{$_}[0] > 59) { $civ = "township"; }
		if ($empires{$_}[0] > 99) { $civ = "enclave"; }
		if ($empires{$_}[0] > 139) { $civ = "territories"; }

		my @races;

		if ($empires{$_}[6] > 0) { push(@races, "human"); }
		if ($empires{$_}[7] > 0) { push(@races, "dwarven"); }
		if ($empires{$_}[8] > 0) { push(@races, "elven"); }
		if ($empires{$_}[9] > 0) { push(@races, "gnomish"); }
		if ($empires{$_}[10] > 0) { push(@races, "orcish"); }
		
		my $lineup;
	
		if ($#races > 2) { $lineup = "multiracial"; }
		else { $lineup = join("/", @races);}
		
		my $worth = int($empires{$_}[11] / $empires{$_}[0]);
	
		print "<li><b>the $alignment $lineup $civ of ";
		if ($local !~ /none/) {
			print "<a href=\"$local/~$_\">";
		}	
		print "~$_</a></b><br />\n
			total net worth: $empires{$_}[11]<br />\n
			pop: $empires{$_}[0]; avg net worth: $worth<br />\n
			gender ratio: $empires{$_}[1]:$empires{$_}[2]</li>\n";
		print "<br />\n";
	}
}

my %ctrlcEmpires = &parseLog(\@ctrlc);
my %townEmpires = &parseLog(\@town);
my %farmEmpires = &parseLog(\@farm);
my %club6Empires = &parseLog(\@club6);
my %universalEmpires = &parseLog(\@universal);

open OUT, ">", "/home/endorphant/scripts/www/nethackempire.html";
select OUT;

print @header;

print "<h3>universal nethack demographics</h3>\n";
print "<ul>\n";
&printEmpire(\%universalEmpires, "none");
print "</ul>\n";

print "<h3>the continent of <a href=\"http://ctrl-c.club\">kutrlcilia</a></h3>\n";
print "<ul>\n";
&printEmpire(\%ctrlcEmpires, "http://ctrl-c.club");
print "</ul>\n";
print "<p><small><i>sourced from <a href=\"http://ctrl-c.club/~endorphant/nethacklog.txt\">ctrl-c.club server nethack logs</a></i></small></p>\n";

print "<h3>the continent of <a href=\"http://tilde.town\">townnia</a></h3>\n";
print "<ul>\n";
&printEmpire(\%townEmpires, "http://tilde.town");
print "</ul>\n";
print "<p><small><i>sourced from <a href=\"http://tilde.town/~endorphant/nethacklog.txt\">tilde.town server nethack logs</a></i></small></p>\n";

print "<h3>the continent of <a href=\"http://tilde.farm\">farmia</a></h3>\n";
print "<ul>\n";
&printEmpire(\%farmEmpires, "http://tilde.farm");
print "</ul>\n";
print "<p><small><i>sourced from <a href=\"http://tilde.farm/~endorphant/nethacklog.txt\">tilde.farm server nethack logs</a></i></small></p>\n";

print "<h3>the continent of <a href=\"http://club6.nl\">sixenlla</a></h3>\n";
print "<ul>\n";
&printEmpire(\%club6Empires, "http://club6.nl");
print "</ul>\n";
print "<p><small><i>sourced from <a href=\"http://club6.nl/json/nethacklog.txt\">club6.nl server nethack logs</a></i></small></p>\n";

print "<p><i>contact me on any tildebox we share if you want to add an outside servr to this page!</i><p>\n";
print "</body>\n</html>\n";
close OUT;
