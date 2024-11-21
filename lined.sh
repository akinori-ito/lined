#!/bin/sh
TMPFILE="__tmp__.txt"
TMPFILE2="__tmp2__.txt"
file="$1"
if [ "$file" = "" ]; then
  file="edited.txt"
fi
if [ ! -f $file ]; then
  touch $file
  lnum=0
else
  lnum=1
fi
while [ true ]; do
  echo -n "[$lnum]CMD(h for help): "
  read cmd
  case $cmd in
    P) 
       nl $file ;;
    p)
       b=`expr $lnum - 5`
       if [ $b -le 0 ]; then
          b=1
       fi
       nl $file | tail -n +$b | head 
       ;;
    [0-9]*)
       lnum=$cmd
       b=`expr $lnum - 5`
       if [ $b -le 0 ]; then
          b=1
       fi
       nl $file | tail -n +$b | head 
       ;;
    s)
       nl $file | tail -n +$lnum | head -1
       echo "Input new line"
       read ln
       cp $file $TMPFILE
       if [ $lnum = 1 ]; then
          (echo $ln; tail -n +2 $file) > $TMPFILE2
       else
          lnum1=`expr $lnum - 1`
          lnum2=`expr $lnum + 1`
          (head -n $lnum1 $file; echo $ln; tail -n +$lnum2 $file) > $TMPFILE2
       fi
       mv $TMPFILE2 $file
       ;;
    i)
       echo "Input new line"
       read ln
       cp $file $TMPFILE
       if [ $lnum = 1 ]; then
          (echo $ln; tail -n +2 $file) > $TMPFILE2
       else
          lnum2=`expr $lnum + 1`
          (head -n $lnum $file; echo $ln; tail -n +$lnum2 $file) > $TMPFILE2
       fi
       mv $TMPFILE2 $file
       ;;
    d)
       cp $file $TMPFILE
       if [ $lnum = 1 ]; then
          (tail -n +2 $file) > $TMPFILE2
       else
          lnum1=`expr $lnum - 1`
          lnum2=`expr $lnum + 1`
          (head -n $lnum1 $file; tail -n +$lnum2 $file) > $TMPFILE2
       fi
       mv $TMPFILE2 $file
       ;;
    a)
       cp $file $TMPFILE
       echo "Input new lines (end with .)"
       if [ $lnum = 0 ]; then
	  cp /dev/null $TMPFILE2
       else
          head -n $lnum $file > $TMPFILE2
       fi
       while [ true ]; do
	 read ln
	 if [ "$ln" = "." ]; then
	   break
	 fi
	 echo $ln >> $TMPFILE2
       done
       tail -n +$lnum2 $file >> $TMPFILE2
       mv $TMPFILE2 $file
       ;;
    u)
       if [ -f $TMPFILE ]; then
	  mv $TMPFILE $file
       else
	  echo "Not undoable"
       fi
       ;;
    h)
       echo "p: print file"
       echo "P: print entire file"
       echo "s: substitute line"
       echo "i: insert line after the current line"
       echo "a: insert multiple lines after the current line (end with ".")"
       echo "u: undo"
       echo "h: help"
       echo "number: goto line"
       echo "q: quit"
        ;; 
    q) 
       break;;
  esac
done
