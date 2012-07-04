#! /usr/bin/perl 
#use strict;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use JSON;

my $scilab="pgrep scilab.cgi|wc -l";
open (CMD,"$scilab|");
     my $returnVal=<CMD>;
     close CMD;

if($returnVal > 1)
{exit 1};

system("killall -s INT python.cgi");
system("killall -s INT c.cgi");
system("killall -s INT cpp.cgi");


system("rm /var/www/html/flag");
system("rm /tmp/pysave/*.py");
system("rm /tmp/1.cpp /tmp/cpbin /tmp/cperror");
system("rm /tmp/1.c /tmp/cbin /tmp/cerror /tmp/1.py");
system("rm /var/www/html/scilab/tmp/*.cde");


my $request = new CGI;
my $incode=$request->param('code');
my $flag_save1=$request->param('flag_save1');
my $flag_save=$request->param('flag_save');
my $check = $request->param('check');
my $filename1=$request->param('filename1');
my $filename=$request->param('filename');
my $graphicsmode=$request->param('graphicsmode');
my $codefile="/var/www/html/scilab/tmp/1.cde";
my $codefilePlot="/var/www/html/scilab/tmp/plot.cde";
my $errorfile="/var/www/html/scilab/tmp/1.err";
my $imagepath="/var/www/html/scilab/tmp/1.gif";
my $results;


if($flag_save==1)
  {system("cp $imagepath /tmp/scisaveimg/$filename.gif");
    exit 1;}
    system("rm /var/www/html/scilab/tmp/1.gif");



if ($graphicsmode)
    {guimode();}
else{noguimode();}

sub guimode{
	$< = 0;
	open CODE,">$codefilePlot";
	print CODE "mode(-1);\ntry\nscf(0);\n";
	print CODE $incode;
	print CODE "\nmode(-1);\nxs2gif(0,\'$imagepath\');\nexit();\ncatch\n[error_message,error_number]	=lasterror(%t);\n";
	print CODE "ukm=file(\'open\',\'$errorfile\');\nwrite(ukm,error_message);\nfile(\'close\',ukm);\n";
	print CODE "xdel(winsid());\nend;\nexit();";
	close CODE;


    print "Content-type: text/html\n\n";
	my $error="";
        my $output="som thing";
	if (-e $errorfile){
		open (ERROR,$errorfile);
		my @error=<ERROR>;
		close ERROR;
		$error=join("",@error);
		unlink $errorfile;
	}
	



    if($flag_save1==1)
      {open CODE,">$codefilePlot";
	   print CODE $incode;
       close CODE;
       system("mv $codefilePlot /tmp/scisave/$filename1.sce");
            }

	while(1)
    {
    #if(-z "/var/www/html/flag")
    if(-s $imagepath)
#write code to check gif and error file instead of flag
   {     
    my $output=join("",@data);
	$output =~ s/exit\(\);//g;
	$output =~ s/-->catch//g;
	$results->{"output"}=$output;
	$results->{"image"}=1;
	$results->{"imagefile"}=$imagepath;
	$results->{"error"}=$error;
	my $json=objToJson($results);
	print $json;
	system("rm /var/www/html/flag");
	last;
   }
    }
}

sub noguimode{

	open CODE,">$codefile";
	print CODE "mode(-1);\nlines(0);\ntry\nmode(1);\n";
	print CODE $incode;
	print CODE "\nexit();\ncatch\nmode(-1);\n			[error_message,error_number,line,fun]=lasterror(%t);\n";
	print CODE "ukm=file(\'open\',\'$errorfile\');\nwrite(ukm,error_message);\nfile(\'close\',ukm);\n";
	print CODE "\nend;";
	print CODE "\nend;\nexit();";
	close CODE;

	print "Content-type: text/html\n\n";
	$< = 0;

	my $error;
	if (-e $errorfile){
		open (ERROR,$errorfile);
		my @error=<ERROR>;
		close ERROR;
		$error=join("",@error);
	}

    if($flag_save1==1)
        {   
	        open CODE,">$codefile";
	        print CODE $incode;
           close CODE;
            system("cp $codefile /tmp/scisave/$filename1.sce");}

	while(1)
    {
    if(-z "/var/www/html/flag")
   {     
    my $output=join("",@data);
	$output =~ s/exit\(\);//g;
	$output =~ s/-->catch//g;
	$results->{"output"}=$output;
	$results->{"image"}=0;
	$results->{"imagefile"}="";
	$results->{"error"}=$error;
	my $json=objToJson($results);
	print $json;
	system("rm /var/www/html/flag");
	last;
   }
    }

}

