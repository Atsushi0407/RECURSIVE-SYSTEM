#!/usr/bin/env perl
$file = $ARGV[0];
$head = "";
%rls = ();
@script = ();
@vals = ();
$copt = '$-C';
while(<>){
	chomp;
	if($_ =~ /^\$ER\$/){
		$head = $_;
		$copt = '$-Cr';
	}elsif($_ =~ /^\$E\$/){
		$head = $_;
	}elsif($_ =~ /\t->\t/){
		($k,$v) = split(/\t->\t/,$_);
		$rls{$k} = $v;
	}else{
		push(@script,$_);
	}
}
# header
$stage = $head;
$stage =~ s/\(.*$//;
if($stage =~ /DRY/){
	$next = $stage;
	$next =~ s/DRY/FED/;
}
print "$next\n";

# for target application
if( "$rls{'$X$Application'}" eq '$X$Mathematica' ){
	$fedfile = $file.".dry.fed";
	$comfile = $file.".dry.fed.com";
	open(DATA,">",$comfile);
	print DATA "cat ".$fedfile." | "."math";
	close(DATA);
	# create metacomannd
	$meta '$M$./tq.o ($-FW,',$copt.')';
	print $meta;
	print "\n";
	print '$X$Get($`~/gitsrc/MATH_SCRIPT/SCRIPTS/DataFederation.m)';
	print "\n";
}elsif( "$rls{'$X$Application'}" eq '$X$Python' && "$rls{'$X$DDF'}" eq '$X$PackedData'){
#	$fedfile = $file.".dry.fed";
	$comfile = $file.".dry.fed.com";
	$target = $rls{'$X$Target'};
#        if(length($rls{'$X$FederationFile'}) > 0){
#		$fed1file = $rls{'$X$FederationFile'};
#		$fed1file =~ s/^\$`//;
#	}
	$target =~ s/^\$`//;
        $fedfile = $rls{'$X$FederationFile'};
	$fedfile =~ s/^\$`//;
        if(length($rls{'$X$B_FederationFile'}) > 0){
		$bfedfile = $rls{'$X$B_FederationFile'};
		$bfedfile =~ s/^\$`//;
	}else {
		$bfedfile = "";
	}        
	if(length($rls{'$X$A_FederationFile'}) > 0){
		$afedfile = $rls{'$X$A_FederationFile'};
		$afedfile =~ s/^\$`//;
	} else {
		$afedfile = "";
	}
	open(DATA,">",$comfile);
	print DATA "$bfedfile\n";
	print DATA "python"," $fedfile"," $target\n";
	print DATA "$afedfile\n";
	close(DATA);
}elsif( "$rls{'$X$Application'}" eq '$X$ruby' && "$rls{'$X$DDF'}" eq '$X$PackedData'){
#	$fedfile = $file.".dry.fed";
	$comfile = $file.".dry.fed.com";
	$target = $rls{'$X$Target'};
#        if(length($rls{'$X$FederationFile'}) > 0){
#		$fed1file = $rls{'$X$FederationFile'};
#		$fed1file =~ s/^\$`//;
#	}
	$target =~ s/^\$`//;
        $fedfile = $rls{'$X$FederationFile'};
	$fedfile =~ s/^\$`//;
        if(length($rls{'$X$B_FederationFile'}) > 0){
		$bfedfile = $rls{'$X$B_FederationFile'};
		$bfedfile =~ s/^\$`//;
	}else {
		$bfedfile = "";
	}        
	if(length($rls{'$X$A_FederationFile'}) > 0){
		$afedfile = $rls{'$X$A_FederationFile'};
		$afedfile =~ s/^\$`//;
	} else {
		$afedfile = "";
	}
	open(DATA,">",$comfile);
	print DATA "$bfedfile\n";
	print DATA "ruby"," $fedfile"," $target\n";
	print DATA "$afedfile\n";
	close(DATA);
}elsif( "$rls{'$X$Application'}" eq '$X$cmd' && "$rls{'$X$DDF'}" eq '$X$PackedData'){
#	$fedfile = $file.".dry.fed";
	$comfile = $file.".dry.fed.com";
	$target = $rls{'$X$Target'};
	$target =~ s/^\$`//;
        $fedfile = $rls{'$X$FederationFile'};
	$fedfile =~ s/^\$`//;
        if(length($rls{'$X$B_FederationFile'}) > 0){
		$bfedfile = $rls{'$X$B_FederationFile'};
		$bfedfile =~ s/^\$`//;
	}else {
		$bfedfile = "";
	}        
	if(length($rls{'$X$A_FederationFile'}) > 0){
		$afedfile = $rls{'$X$A_FederationFile'};
		$afedfile =~ s/^\$`//;
	}        
	if(length($rls{'$X$A_FederationFile'}) > 0){
		$afedfile = $rls{'$X$A_FederationFile'};
		$afedfile =~ s/^\$`//;
	} else {
		$afedfile = "";
	}
	open(DATA,">",$comfile);
	print DATA "$bfedfile\n";
	print DATA "sh"," $fedfile\n";
	print DATA "$afedfile\n";
	close(DATA);
}

# application scripts
$head =~ s/[^(]+//;
$head =~ s/^\(//;
$head =~ s/\)$//;
@vals = split(/,/,$head);
foreach(@script){
	$line = $_;
	foreach(@vals){
		$pt = $_;
		$pt =~ s/\$/\\\$/g;
		$tgt = $rls{$_};
		$line =~ s/$pt/$tgt/g;
	}
	print "$line\n";
}
