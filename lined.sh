#!/bin/sh
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
       cp $file tmp.txt
       if [ $lnum = 1 ]; then
          (echo $ln; tail -n +2 $file) > tmp2.txt
       else
          lnum1=`expr $lnum - 1`
          lnum2=`expr $lnum + 1`
          (head -n $lnum1 $file; echo $ln; tail -n +$lnum2 $file) > tmp2.txt
       fi
       mv tmp2.txt $file
       ;;
    i)
     echo "Input new line"
       read ln
       cp $file tmp.txt
       if [ $lnum = 1 ]; then
          (echo $ln; tail -n +2 $file) > tmp2.txt
       else
          lnum2=`expr $lnum + 1`
          (head -n $lnum $file; echo $ln; tail -n +$lnum2 $file) > tmp2.txt
       fi
       mv tmp2.txt $file
       ;;
    d)
       cp $file tmp.txt
       if [ $lnum = 1 ]; then
          (tail -n +2 $file) > tmp2.txt
       else
          lnum1=`expr $lnum - 1`
          lnum2=`expr $lnum + 1`
          (head -n $lnum1 $file; tail -n +$lnum2 $file) > tmp2.txt
       fi
       mv tmp2.txt $file
       ;;
    h)
       echo "p: print file"
       echo "P: print entire file"
       echo "s: substitute line"
       echo "i: insert line"
       echo "h: help"
       echo "number: goto line"
       echo "q: quit"
        ;; 
    q) 
       break;;
  esac
done
