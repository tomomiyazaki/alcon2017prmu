#!/bin/sh
# Get dataset from CODH, http://codh.rois.ac.jp/char-shape/

# ----------------
# Make directories
# ----------------
dirWork=$PWD
dirZips=$dirWork"/zips"
dirCharShape=$dirWork"/char-shape"
dirWorkAnno=$dirWork"/annotations"

cd ..
dirData=$PWD"/dataset"
cd $dirWork
dirDataChars=$dirData"/characters"
dirDataImgs=$dirData"/images"
dirDataAnno=$dirData"/annotations"

if [ ! -d $dirData ]; then mkdir $dirData; fi
if [ ! -d $dirDataImgs ]; then mkdir $dirDataImgs; fi
if [ ! -d $dirZips ]; then mkdir $dirZips; fi
if [ ! -d $dirCharShape ]; then mkdir $dirCharShape; fi
if [ ! -d $dirWorkAnno ]; then mkdir $dirWorkAnno; fi
if [ ! -d $dirDataAnno ]; then mkdir $dirDataAnno; fi

# ---------------
# Compile Dataset
# ---------------
IFS='
'
num=0
while read -r line; do

    # Download
    aZip=$dirZips"/"$line".zip"
    if [ ! -f $aZip ]; then
	printf "Downloading %s ... " $aZip
	aUrl="http://codh.rois.ac.jp/char-shape/book/"$line"/"$line".zip"
	wget -q -P $dirZips $aUrl
	printf "done\n"
    else
	#printf "%s already exists.\n" $aZip
	:
    fi

    # Unzip
    if [ ! -d $dirCharShape"/"$line ]; then
	#printf "Unzip %s to %s ... " $aZip $dirCharShape
	unzip -q -d $dirCharShape $aZip
	#printf "done\n"
    fi

    # Copy Hiragana images
    printf "Copying images in %s ..." $line
    while read -r codeHira; do
	# Make output directory
	dirTar=$dirDataChars"/"$codeHira
	if [ ! -d  $dirTar ]; then
	    mkdir -p $dirTar
	fi
	# Copy
	dirSrc=$dirCharShape"/"$line"/characters/"$codeHira
	if [ -d $dirSrc ]; then
	    cd $dirSrc
	    for file in *.jpg; do
		if [ ! -f $dirTar"/"$file ]; then
		    #echo $dirSrc"/"$file $dirTar"/"$file
		    cp $dirSrc"/"$file $dirTar"/"$file
		fi
	    done
	    cd $dirWork
	fi
    done < $dirWorkAnno"/TargetUnicodes.txt"

    # Copy document images
    cd $dirCharShape"/"$line"/images"
    for file in *.jpg; do
	if [ ! -f $dirDataImgs"/"$file ]; then
	    #printf "cp %s %s\n" $file $dirDataImgs
	    cp $file $dirDataImgs
	fi
    done
    cd $dirWork
    printf " done\n"
    
    # Copy annotation files
    if [ ! -f $dirData"/dataset_coordinate.csv" ]; then
	fnCSV=$dirCharShape"/"$line"/"$line"_coordinate.csv"
	fnOut=$dirData"/coordinate"`printf %03d $num`".csv"
	if [ ! -f $fnOut -a -f $fnCSV -a $num -eq 0 ]; then
	    #printf "cp %s %s\n" $fnCSV $fnOut
	    cp $fnCSV $fnOut
	elif [ ! -f $fnOut -a -f $fnCSV -a $num -gt 0 ]; then
	    #printf "sed -e \'1d\' %s > %s\n" $fnCSV $fnOut
	    sed -e '1d' $fnCSV > $fnOut
	else
	    #printf "else @ CopyAnno"
	    :
	fi
    fi
    num=`expr $num + 1`
    
done < $dirWorkAnno"/TargetCharShape.txt"


# Merge and clean up annotation files
fnMerged="dataset_coordinate.csv"
printf "Creating %s ... " $fnMerged
if [ ! -f $dirData"/"$fnMerged ]; then
    cd $dirData
    cat coordinate???.csv > $fnMerged
    rm -f "coordinate"???".csv"
    cd $dirWork
fi
printf "done\n"

# Copy TargetUnicodes.txt to ../dataset
fn="TargetUnicodes.txt"
fn1=$dirDataAnno"/"$fn
fn2=$dirWorkAnno"/"$fn
if [ ! -f $fn1 -a -f $fn2 ]; then
    cp $fn2 $fn1
fi

# Copy TargetUnicodes_with_Hiragana.txt to ../dataset
fn="TargetUnicodes_with_Hiragana.txt"
fn1=$dirDataAnno"/"$fn
fn2=$dirWorkAnno"/"$fn
if [ ! -f $fn1 -a -f $fn2 ]; then
    cp $fn2 $fn1
fi

# Copy CSV files to ../dataset/annotations
printf "Copying target and groundtruth files ... " 
cd $dirWorkAnno
for file in *.csv; do
    fnS=$dirWorkAnno"/"$file
    fnT=$dirDataAnno"/"$file
    if [ ! -f $fnT -a -f $fnS ]; then
        cp $fnS $fnT
    fi
done
cd $dirWork
printf "done\n"

# Copy CSV files to ../dataset/annotations for train/ and test/
printf "Copying train/ and test/ ... "
dirWorkAnnoTrain=$dirWorkAnno"/train_lv1"
dirDataAnnoTrain=$dirDataAnno"/train_lv1"
if [ ! -d $dirDataAnnoTrain ]; then mkdir $dirDataAnnoTrain; fi
cd $dirWorkAnnoTrain
for file in *.csv; do
    fnS=$dirWorkAnnoTrain"/"$file
    fnT=$dirDataAnnoTrain"/"$file
    if [ ! -f $fnT -a -f $fnS ]; then
        cp $fnS $fnT
    fi
done
cd $dirWork

dirWorkAnnoTest=$dirWorkAnno"/test_lv1"
dirDataAnnoTest=$dirDataAnno"/test_lv1"
if [ ! -d $dirDataAnnoTest ]; then mkdir $dirDataAnnoTest; fi
cd $dirWorkAnnoTest
for file in *.csv; do
    fnS=$dirWorkAnnoTest"/"$file
    fnT=$dirDataAnnoTest"/"$file
    if [ ! -f $fnT -a -f $fnS ]; then
        cp $fnS $fnT
    fi
done
cd $dirWork

printf "done\n"


# Copy README.md to ../dataset
printf "Copying README.md ... "
    fnS=$dirWork"/README.md"
    fnT=$dirData"/README.md"
    if [ ! -f $fnT -a -f $fnS ]; then
        cp $fnS $fnT
    fi
printf "done\n"
