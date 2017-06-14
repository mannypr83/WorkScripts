#!/usr/bin/perl  
################################################################################  
#  
# File:         EvilTwin.pl  
# Description:  This trigger checks for evil twins. And evil twin can occur when  
#               a user checks in an element which matches an element name on  
#               some other branch of the directory that is invisible in the  
#               current view.  
# Trigger Type: All element  
# Operation:    Preop lnname  
# Author:       Andrew@DeFaria.com  
# Created:      May 24, 2004  
# Language:     Perl  
# Modifications:  
#
#				(02\06\12 - Chad Medeiros)
#				- Use perl -e instead of cleartool ls when in dynamic views
#  
# (c) Copyright 2004, Andrew@DeFaria.com, all rights reserved  
#  
################################################################################  
use strict;  
# use warnings;  
 
# Ensure that the view-private file will get named back on rejection.  
BEGIN {  
  END {  
    rename "$ENV{CLEARCASE_PN}.mkelem", "$ENV{CLEARCASE_PN}"  
      if $? && ! -e "ENV{CLEARCASE_PN}" && -e "$ENV{CLEARCASE_PN}.mkelem";  
  } # END  
} # BEGIN  

# Get Clearcase Environment variables needed  
my $pname       = $ENV {CLEARCASE_PN}; 
my $view_kind	="$ENV{'CLEARCASE_VIEW_KIND'}";

# Delimeters and null are different on the different OSes  
my $dir_delim   = "\\";  
my $dir_delim_e = "\\\\";  
my $null        = "NUL";  
 
# Remove any "\.\" or "/./" that appear  
$pname =~ s/$dir_delim_e\.$dir_delim_e/$dir_delim_e/;  

# Get short element name  
my @parts = split /$dir_delim_e/, $pname;  
my $element_name = $parts [$#parts];  

# Get parent directory name  
my $parent = $pname;  
 
while (chop ($parent) !~ /$dir_delim_e/) {  
  ;  
} # while  

# Look for evil twins
my $status;  
my $possible_dupe;
 
# Get list of all branches for the parent directory. We will search  
# these for possible evil twins.  
my @parent_dir_branches = `cleartool lsvtree -all -s "$parent"`;  
 
foreach (@parent_dir_branches) {  
  chomp;  
  chop if /\r/;  
} # foreach  
 
my $evil_twin = 1;

if ("$view_kind" eq "dynamic")
{ 
  #####################
  # For Dynamic views #
  #####################
  foreach (@parent_dir_branches) {
	chomp;
	$possible_dupe = $_ . $dir_delim . $element_name;  
 
	if ( -e "$possible_dupe" )
	{
	  my $type = `cleartool desc -fmt %m \"$possible_dupe\" 2>&1`; 
	  chomp ($type);  
 
	  if ("$type" ne "branch") {  
        # If it's not a branch then we've found an evil twin - set $evil_twin  
        # to 0 indicating this and break out.  
        $evil_twin = 0;  
        last;
	  } # if
	} # if
  } # foreach
} # if
else
{
  ######################
  # For snapshot views #
  ######################
  foreach (@parent_dir_branches) {
	chomp;
	$possible_dupe = $_ . $dir_delim . $element_name;
	
	# View extended pathnames don't work from snapshot views. While  
	# using cleartool ls is slower it also has the benefit of respecting  
	# the case sensitivity of MVFS.  
	$status = (system "cleartool ls -s \"$possible_dupe\" > $null 2>&1") >> 8; 
      
	if ($status eq 0) {  
	  # We found something related to $element_name. Now check to see if  
	  # this something is a branch name  
	  my $type = `cleartool desc -fmt %m \"$possible_dupe\" 2>&1`;  
	  chomp ($type);  
 
	  if ("$type" ne "branch") {  
		# If it's not a branch then we've found an evil twin - set $status  
		# to 1 indicating this and break out.  
		$evil_twin = 0;  
		last;  
	  } # if
	} # if
  } # foreach 
} # else

# Exit 0 if the evil twin is not found
exit 0 if $evil_twin;  
 
# Possible duplicate element is found on invisible branch(es).  
my $prompt;  
$prompt  = "CRITICAL ERROR the element $element_name already exists for the directory $parent\\n";  
$prompt .= "in another branch as ($possible_dupe).\\n\\n";  
$prompt .= "You could either merge the parent directories or create a\\n";  
$prompt .= "Clearcase hardlink to that element instead.\\n\\n";  
$prompt .= "If you feel you really need to perform this action please ";  
$prompt .= "contact your ClearCase Administrators \/ CMADS Super Users\\n\\n";  
 
system ("clearprompt yes_no -mask abort -default abort -newline -prompt \"$prompt\"");  
 
exit 1;  
