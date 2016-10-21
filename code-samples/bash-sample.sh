#!/bin/bash
# renames.sh
# basic file renamer

criteria=$1
re_match=$2
replace=$3

for i in $( ls *$criteria* );
do
   src=$i
   tgt=$(echo $i | sed -e "s/$re_match/$replace/")
   mv $src $tgt
done


#!/bin/sh
 # renna: rename multiple files according to several rules
 # written by felix hudson Jan - 2000

 #first check for the various 'modes' that this program has
 #if the first ($1) condition matches then we execute that portion of the
 #program and then exit

 # check for the prefix condition
 if [ $1 = p ]; then

 #we now get rid of the mode ($1) variable and prefix ($2)
   prefix=$2 ; shift ; shift

 # a quick check to see if any files were given
 # if none then its better not to do anything than rename some non-existent
 # files!!

   if [$1 = ]; then
      echo "no files given"
      exit 0
   fi

 # this for loop iterates through all of the files that we gave the program
 # it does one rename per file given
   for file in $*
     do
     mv ${file} $prefix$file
   done

 #we now exit the program
   exit 0
 fi

 # check for a suffix rename
 # the rest of this part is virtually identical to the previous section
 # please see those notes
 if [ $1 = s ]; then
   suffix=$2 ; shift ; shift

    if [$1 = ]; then
     echo "no files given"
    exit 0
    fi

  for file in $*
   do
    mv ${file} $file$suffix
  done

  exit 0
 fi

 # check for the replacement rename
 if [ $1 = r ]; then

   shift

 # i included this bit as to not damage any files if the user does not specify
 # anything to be done
 # just a safety measure

   if [ $# -lt 3 ] ; then
     echo "usage: renna r [expression] [replacement] files... "
     exit 0
   fi

 # remove other information
   OLD=$1 ; NEW=$2 ; shift ; shift

 # this for loop iterates through all of the files that we give the program
 # it does one rename per file given using the program 'sed'
 # this is a sinple command line program that parses standard input and
 # replaces a set expression with a give string
 # here we pass it the file name ( as standard input) and replace the nessesary
 # text

   for file in $*
   do
     new=`echo ${file} | sed s/${OLD}/${NEW}/g`
     mv ${file} $new
   done
 exit 0
 fi

 # if we have reached here then nothing proper was passed to the program
 # so we tell the user how to use it
 echo "usage;"
 echo " renna p [prefix] files.."
 echo " renna s [suffix] files.."
 echo " renna r [expression] [replacement] files.."
 exit 0

 # done!
