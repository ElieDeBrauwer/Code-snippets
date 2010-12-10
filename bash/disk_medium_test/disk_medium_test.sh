#!/bin/bash 

# This is a small shell script which can be used for testing the quality 
# of disks (USB sticks or SATA DOM modules). This script will create four 
# files, a small file filled with zeros, a large file filled with zeros
# a small file filled with random data, a large file filled with random 
# data. (Large files should match the size of the medium to test). An MD5
# checksum of these input files will be created.
# In a next phase there will be 48 writes of the zero and random small 
# files, followed by 2 writes of the zero and random large files (thus 
# 100 writes per cycle). After each cycle the MD5 checksums will be 
# checked, to verify that everything was written and read back. For testing
# usb-sticks the number of cycles should be adapted to the datasheet.
# 
# Caution: this requires root privileges and will destroy the contents
# of the medium under test.
#
# Author: Elie De Brauwer <elie @ de-brauwer.be>
# License: Simplified BSD


LARGE_CNT="750"           # This should be the medium size
SMALL_CNT="1"             # This is the size for a small file 
NUM_CYCLE="100"           # This number of loops
STICKDEV="/dev/sdb"       # Device to test.

MD5SUMFILE="sum.md5"
ZERO_SMALL='zero_small.dmp'
ZERO_LARGE='zero_large.dmp'
RAND_SMALL='rand_small.dmp'
RAND_LARGE='rand_large.dmp'

function die {
    echo "Failure: " $@
    rm -f ${ZERO_SMALL} 2>/dev/null
    rm -f ${ZERO_SMALL} 2>/dev/null
    rm -f ${RAND_LARGE} 2>/dev/null
    rm -f ${RAND_LARGE} 2>/dev/null
    rm -f ${MD5SUMFILE} 2>/dev/null
    exit 1
}


echo "Creating ${SMALL_CNT} mbyte zero data"
dd if=/dev/zero of=${ZERO_SMALL} bs=1M count=${SMALL_CNT}                         || die "Failed to create small zero data file"
echo "Creating ${SMALL_CNT} mbyte random data"
dd if=/dev/urandom of=${RAND_SMALL} bs=1M count=${SMALL_CNT}                      || die "Failed to create small random data file"

echo "Creating ${LARGE_CNT} mbyte zero data"
dd if=/dev/zero of=${ZERO_LARGE} bs=1M count=${LARGE_CNT}                         || die "Failed to create large zero data file"
echo "Creating ${LARGE_CNT} byte random data"
dd if=/dev/urandom of=${RAND_LARGE} bs=1M count=${LARGE_CNT}                      || die "Failed to create large random data file"

md5sum -b ${ZERO_SMALL} ${RAND_SMALL} ${ZERO_LARGE} ${RAND_LARGE} > ${MD5SUMFILE} || die "Failed to create initial checksum file"

for j in `seq 1 $NUM_CYCLE`; do 
    echo "Starting major run $j"
    for i in {1..48}; do 
	echo "Starting major run $j minor run $i on " `date`
	# Fill stick with zero
	dd if=${ZERO_SMALL} of=${STICKDEV}   bs=1M count=${SMALL_CNT}             || die "Failed to write small zero to   stick"
        sync 
	# Read zero back  
	dd if=${STICKDEV}   of=${ZERO_SMALL} bs=1M count=${SMALL_CNT}             || die "Failed to read  small zero from stick"
        sync 

	# Fill stick with junk
	dd if=${RAND_SMALL} of=${STICKDEV}   bs=1M count=${SMALL_CNT}             || die "Failed to write small junk to   stick"
        sync 
	# Read junk back 
	dd if=${STICKDEV}   of=${RAND_SMALL} bs=1M count=${SMALL_CNT}             || die "Failed to read  small junk from stick"
        sync 
    done

    # Fill stick with zero
    dd if=${ZERO_LARGE} of=${STICKDEV}   bs=1M count=${LARGE_CNT}                 || die "Failed to write large zero to   stick"
    sync 
    # Read zero back  
    dd if=${STICKDEV}   of=${ZERO_LARGE} bs=1M count=${LARGE_CNT}                 || die "Failed to read  large zero from stick"
    sync 
    
    # Fill stick with junk
    dd if=${RAND_LARGE} of=${STICKDEV}   bs=1M count=${LARGE_CNT}                 || die "Failed to write large junk to   stick"
    sync 
    # Read junk back 
    dd if=${STICKDEV}   of=${RAND_LARGE} bs=1M count=${LARGE_CNT}                 || die "Failed to read  large junk from stick"
    sync 
    
    md5sum -c ${MD5SUMFILE}                                                       || die "MD5 checksum failure ! "
done 