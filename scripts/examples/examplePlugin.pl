#!/usr/bin/perl

#This example perl script is used to customise an rdp file generated by scalus before presenting it to Microsoft Remote Desktop
#
my $spass="";
#uncomment and set the password here if required from the output of :
#("mypassword" | ConvertTo-SecureString -AsPlainText -Force) | ConvertFrom-SecureString; 
#$spass="myencryptedpassword";

my $filename=$ARGV[0];

my %settings = (
    'desktopwidth' =>   'i:200' ,
    'desktopheight'=>  'i:200',
    'desktopwidth' =>  'i:1024',
    'desktopheight'=>  'i:768',
    'session bpp'  =>   'i:24',
    'winposstr'    =>    's:0,1,1955,64,3253,113'
);

if ((not defined $filename) or 
	(not (-e $filename)) or
	(not (-r $filename)) or
	(not (-w $filename)))
{
    print "ERROR:invalid file: ${filename}\n";
    exit;
}

my $tmpfile = "${filename}.tmp";

open(DATA, "<${filename}") or die "ERROR:Couldnt open file ${filename}, $!";
open(TOFILE, ">${tmpfile}") or die "ERROR:Couldnt open file ${tmpfile}, $!";
while (<DATA>){
	chomp;
	my ($key, $valtype, $val) = split /:/, $_;
	if (not (exists $settings{$key})) {
		if (($key ne "password 51") or ($spass == ""))
		{
			$settings{$key} = "${valtype}:${val}";
		} 
	}

}
close (DATA);

for (keys %settings)  {
	print TOFILE "$_:$settings{$_}\n";
}
if ($spass != "")
{
	print TOFILE "password 51:b:${spass}";
}
close (TOFILE);

unlink(${filename});
rename(${tmpfile}, ${filename});
