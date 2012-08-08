#! /usr/bin/perl
#use strict;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use JSON;

my $python="pgrep python.cgi|wc -l";
open (CMD,"$python|");
     my $returnVal=<CMD>;
     close CMD;

if($returnVal > 1)
{exit 1};

system("killall -s INT scilab.cgi");
system("killall -s INT c.cgi");
system("killall -s INT cpp.cgi");

system("rm /var/www/html/flag");
system("rm /tmp/pysave/*.py");
system("rm /tmp/1.cpp /tmp/cpbin /tmp/cperror");
system("rm /tmp/1.c /tmp/cbin /tmp/cerror /tmp/1.py");
system("rm /var/www/html/scilab/tmp/*.cde /var/www/html/scilab/tmp/1.gif");
my $request = new CGI;
my $incode=$request->param('code');
my $flag_save1=$request->param('flag_save1');
my $check = $request->param('check');
my $filename1=$request->param('filename1');
my $codefile="/tmp/1.py";
my $results;
	open CODE,">$codefile";
	print CODE $incode;
	close CODE;
	print "Content-type: text/html\n\n";
	my $path=$ENV{'PATH'};
	$< = 0;


if($flag_save1==1)
        {system("/bin/cp /tmp/1.py /tmp/pysave/$filename1.py");
         exit 1;}


while(1)
{
if(-z "/var/www/html/flag") 
{       my @error;
	my $output;
	$results->{"output"}="";
	$results->{"error"}=$error;
	my $json=objToJson($results);
	print $json;
	system("rm /var/www/html/flag");
	last;
}
}


