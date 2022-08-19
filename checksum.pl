#!/usr/bin/env perl
################################################################################
# CHECKSUM.PL -- Checksum and Update ROM Source File
#
# This script performs a 16-bit checksum of a ROM file, and updates the source
# with the correct 8-bit checksum value. This of course depends on the value
# being defined in the source in a recognized manner:
#
#    SUMVAL	=	$12
#
# ...where SUMVAL begins the line, is followed by a tab, an equal sign, another
# tab, and finally the hex value, with a $ sigil in front.
#
# Usage:
#
#   checksum.pl romimage.bin source.asm
#
# (c) 2022 Glitch Works, LLC
# http://www.glitchwrks.com
#
# Released under the GNU GPL v3, see LICENSE in project root.
################################################################################
use bigint;
use File::Slurp;
use strict;
use warnings;

my $rom_file = $ARGV[0];
my $source_file = $ARGV[1];
my $rom_image = read_file($rom_file);

# Perform a 16-bit checksumming of the ROM image
my $checksum = sprintf('%04x', unpack("%16W*", $rom_image));
print "ROM checksum: 0x" . $checksum . "\n";

# If the low byte of the checksum is not 0x00, recalculate it
if (substr($checksum, 2) ne "00") {
	rename($source_file, $source_file . '.bak');
	open(IN, '<' . $source_file . '.bak') or die $!;
	open(OUT, '>' . $source_file) or die $!;

	while(<IN>) {
		if ( /^SUMVAL\s+=\s?\$(\S+).*$/ ) {
			my $hex_checksum = hex $checksum;
			my $oldval = hex $1;
			my $difference = $hex_checksum - $oldval;

			my $calcit = hex substr($difference->as_hex, 4);
			my $newval = 0x100 - $calcit;
			print OUT "SUMVAL\t=\t\$" . uc substr($newval->as_hex, 2) . "\n";
		} else {
			print OUT $_
		}
	}
	close(IN);
	close(OUT);

	print "SUMVAL updated in source, rebuild ROM image.\n";
	exit -1;
}
