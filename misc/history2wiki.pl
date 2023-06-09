#!/usr/bin/perl -Tw
#-
# Copyright (c) 2012-2021 Dag-Erling Smørgrav
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote
#    products derived from this software without specific prior written
#    permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

use strict;
use warnings;

my $CVEURL = "http://web.nvd.nist.gov/view/vuln/detail?vulnId=";

while (<>) {
    if (m/^OpenPAM ([A-Z][a-z]+)\t+(\d\d\d\d-\d\d-\d\d)\s*$/) {
	my ($relname, $reldate) = ($1, $2);
	my $changes;
	while (<>) {
	    last if m/^=+$/;
	    $changes .= $_;
	}
	$changes =~ s/\r//gs;
	$changes =~ s/^ - ([A-Z]+): / - **$1** /gm;
	$changes =~ s/([\w.-]+\(\d*\)|\S*[_{}<>#\\\/]\S*)/`$1`/gs;
	$changes =~ s/([.,])`/`$1/gs;
	$changes =~ s/([^'`*])\b([A-Z_]{4,}(?:\s+[A-Z_]{4,})*)\b([^'`*])/$1`$2`$3/gs;
	$changes =~ s/`(PAM|XSSO|\/)`/$1/gs; # false positives above
	$changes =~ s/(CVE-\d{4}-\d+)/[$1]($CVEURL$1)/gs;
	$changes =~ s/([.!?])\n +(\w)/$1  $2/gs;
	$changes =~ s/(\S)\n +([^ -])/$1 $2/gs;
	$changes =~ s/\n/\r\n/gs;
	open(my $fh, ">", "Releases-$relname.md")
	    or die("Releases-$relname.md: $!\n");
	print($fh "# OpenPAM $relname\r\n",
	      "\r\n",
	      "OpenPAM $relname was released on $reldate.\r\n",
	      $changes,
	      "\r\n",
	      "Download from [here](/downloads) or [Sourceforge](http://sourceforge.net/projects/openpam/files/openpam/$relname/)\r\n");
	close($fh);
	print("| $reldate | [$relname](Releases-$relname) |\r\n");
    }
}

1;
