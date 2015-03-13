#######
# 
# Assumes the user is in the reads folder and that the reads are uncompressed fastq 
#
# requires usearch 7 or 8
# overlaps the paired-end reads
# filters the overlapped reads by expected number of errors
# data written to overlap_filtered.fastq
#
#######

# change this with each install
BIN="/Users/ggloor/git/miseq_bin/"

# maximum number of expected errors
ee=1

# make four temporary folders
mkdir split1
mkdir split2
mkdir overlap_split
mkdir overlap_filtered

# split the reads into 1 million read chunks for 32 bit usearch
#split -l 4000000 $1 split1/

#split -l 4000000 $2 split2/

for f in $( ls split1/ ); do
	echo "$f"
	# overlap the reads
	usearch8.0-2.1517_i86osx32 -fastq_mergepairs split1/$f -reverse split2/$f  -fastqout overlap_split/$f.fastq 
	
	# filter by maximum expected error
	usearch8.0-2.1517_i86osx32 -fastq_filter overlap_split/$f.fastq -fastq_maxee $ee -fastqout overlap_filtered/$f.fastq
	
	# merge the files into the final
	cat overlap_filtered/$f.fastq >> overlap_filter.fastq
done

# clean up
rm -R split1
rm -R split2
rm -R overlap_split
rm -R overlap_filtered
