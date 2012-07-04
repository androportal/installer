#! /usr/bin/perl 
#use strict;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use Data::UUID;
use JSON;
my $request = new CGI;
my $ug = Data::UUID->new;
my $uuid=$ug->create_str();
my $file=$ug->to_string($uuid);
my $incode=$request->param('code');
if ($incode =~ m/unix_w|unix_g|unix_s|unix_x|unix|host|dir/){
	$error="Shell Command (sh) execution disabled";
	$results->{"output"}="";
	$results->{"image"}=0;
	$results->{"imagefile"}="";
	$results->{"error"}=$error;
	my $json=objToJson($results);
        print "Content-type: text/html\n\n";
	print $json;
	exit;
}
my $graphicsmode=$request->param('graphicsmode');
my $codefile="/var/www/html/scilab/tmp/$file.cde";
my $errorfile="/var/www/html/scilab/tmp/$file.err";
my $imagepath="/var/www/html/scilab/tmp/$file.gif";
my $results;
if ($graphicsmode){
	guimode();
}
else{
	noguimode();
}
sub guimode{
	$< = 0;
	$ENV{'SCI'}="/usr/lib/scilab-4.1.1";
	$ENV{'TMPDIR'}="/var/www/html/scilab";
	$ENV{'SCIDIR'}="/usr/lib/scilab-4.1.1";
	$ENV{'HOME'}="/var/www/html/scilab";
	$ENV{'DISPLAY'}=":1.0";
	$ENV{'LD_LIBRARY_PATH'}=$ENV{'SCI'}."/bin:".$ENV{'SCI'}."/libs";
	$ENV{'SHLIB_PATH'}=$ENV{'SCI'}."/bin:".$ENV{'SCI'}."/libs";
	$ENV{'TCL_LIBRARY'}=$ENV{'SCI'}."/tcl/tcl8.4";
	$ENV{'TK_LIBRARY'}=$ENV{'SCI'}."/tcl/tk8.4";
	my $cmd="/usr/lib/scilab-4.1.1/bin/scilex -nb -f $codefile";
	open CODE,">$codefile";
	print CODE "mode(-1);\ntry\nscf(0);\n";
	print CODE $incode;
	print CODE "\nmode(-1);\nxs2gif(0,\'$imagepath\');\nexit();\ncatch\n[error_message,error_number]	=lasterror(%t);\n";
	print CODE "ukm=file(\'open\',\'$errorfile\');\nwrite(ukm,error_message);\nfile(\'close\',ukm);\n";
	print CODE "xdel(winsid());\nend;\nexit();";
	close CODE;
        print "Content-type: text/html\n\n";
	open (CMD,"$cmd|");
	my @data=<CMD>;
	close CMD;
	my $error="";
        my $output="som thing";
	if (-e $errorfile){
		open (ERROR,$errorfile);
		my @error=<ERROR>;
		close ERROR;
		$error=join("",@error);
		unlink $errorfile;
	}
	my $output=join("",@data);
	#$output =~ s/exit\(\);//g;
	#$output =~ s/-->catch//g;
	unlink $codefile;
	$results->{"output"}=$output;
	$results->{"image"}=1;
	$results->{"imagefile"}="./tmp/$file.gif";
	$results->{"error"}=$error;
	my $json=objToJson($results);
	print $json;
}
sub noguimode{
	open CODE,">$codefile";
	print CODE "mode(-1);\nlines(0);\ntry\nmode(1);\n";
	print CODE $incode;
	print CODE "\nexit();\ncatch\nmode(-1);\n			[error_message,error_number,line,fun]=lasterror(%t);\n";
	print CODE "ukm=file(\'open\',\'$errorfile\');\nwrite(ukm,error_message);\nfile(\'close\',ukm);\n";
	print CODE "\nend;\nexit();";
	close CODE;
	print "Content-type: text/html\n\n";
	my $path=$ENV{'PATH'};
	$ENV{'PATH'}=$path.":/usr/lib/scilab-4.1.1/bin/";
	$< = 0;
	$ENV{'SCI'}="/usr/lib/scilab-4.1.1";
	$ENV{'TMPDIR'}="var/www/html/scilab";
	$ENV{'SCIDIR'}="/usr/lib/scilab-4.1.1";
	$ENV{'HOME'}="/var/www/html/scilab";
	$ENV{'DISPLAY'}=":0.0";
	$ENV{'LD_LIBRARY_PATH'}=$ENV{'SCI'}."/bin:".$ENV{'SCI'}."/libs";
	$ENV{'SHLIB_PATH'}=$ENV{'SCI'}."/bin:".$ENV{'SCI'}."/libs";
	$ENV{'TCL_LIBRARY'}=$ENV{'SCI'}."/tcl/tcl8.4";
	$ENV{'TK_LIBRARY'}=$ENV{'SCI'}."/tcl/tk8.4";
	my $cmd="/usr/lib/scilab-4.1.1/bin/scilex -nogui -nb -f $codefile";
	open (CMD,"$cmd|");
	my @data=<CMD>;
	close CMD;
	my $error;
	if (-e $errorfile){
		open (ERROR,$errorfile);
		my @error=<ERROR>;
		close ERROR;
		$error=join("",@error);
	}
	my $output=join("",@data);
	$output =~ s/exit\(\);//g;
	$output =~ s/-->catch//g;
	unlink $codefile;
	unlink $errorfile;
	$results->{"output"}=$output;
	$results->{"image"}=0;
	$results->{"imagefile"}="";
	$results->{"error"}=$error;
	my $json=objToJson($results);
	print $json;
}
