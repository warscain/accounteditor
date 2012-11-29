#!/bin/sh

#****************dialog begin******************#
moneymenu () {
LOGFILE1=$DATAPATH/${USERNAME}moneymenu.log

$DIALOG --clear --title "ACCOUNT BOOK" \
        --menu "Select what you want to do:" 10 60 3 \
        "check the account record"  "check the account record" \
        "create/edit account" "check the account record" \
        "payout and income count" "payout and income count" 2> $LOGFILE1

case $? in
    0)
        if [ "`cat $LOGFILE1`" = "check the account record" ]; then
            moneyshow
            > $LOGFILE1                            
        fi
        if [ "`cat $LOGFILE1`" = "create/edit account" ]; then
            moneydateselect
            > $LOGFILE1
        fi
        if [ "`cat $LOGFILE1`" = "payout and income count" ]; then
            moneyoutincount
            > $LOGFILE1
        fi
         ;;
    *)
         ;;
esac
}

moneyshow () {
$DIALOG --clear --title "$YEAR account record" --textbox "$DATAPATH/$USERNAME$YEAR.db" 22 90
case $? in
    *)
      moneymenu;;
esac
}

moneydateselect () {
LOGFILE2=$DATAPATH/${USERNAME}moneydateselect.log

$DIALOG --stdout --title "CALENDAR" --calendar "Please choose a date..." 0 0 $(date +%d) $(date +%m) $(date +%Y) |awk -F/ '{print $3$2$1}' > $LOGFILE2

case $? in
    0)
        if [ -z `cat $LOGFILE2` ]; then     
            moneymenu
        fi
        moneyedit
        ;;
    *)
        moneymenu
        ;;
esac
}

moneyedit () {
if [ -z `cat $LOGFILE2` ]; then     
    exit                           
fi

LOGFILE3=$DATAPATH/${USERNAME}moneyedit.log
EDITDATE=`cat $LOGFILE2`
$DIALOG --title "INPUT BOX" --clear \
        --inputbox "`grep -e $EDITDATE -e DATEOFYEAR $DATAPATH/$USERNAME$YEAR.db`
PLS incert like 6 24 15 1.6 42.2 300 xxxxxxx" 16 90 2> $LOGFILE3

case $? in
    0)
        EDITLINENUM=`grep -n $EDITDATE $DATAPATH/$USERNAME$YEAR.db|awk -F: '{print $1}'`
        FULLDATE=`grep $EDITDATE $DATAPATH/$USERNAME$YEAR.db|awk '{print $1}'`
        EDITLINEDATA=`cat $LOGFILE3`
            if [[ $EDITLINEDATA =~ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ [0-9]+(\.[0-9]+)?\ .* ]]; then
                sed -i "${EDITLINENUM}s/^.*/$FULLDATE $EDITLINEDATA/" $DATAPATH/$USERNAME$YEAR.db
                for i in {1..8}; do
                    sed -i "${EDITLINENUM}s/\ /\t/1" $DATAPATH/$USERNAME$YEAR.db
                done
            else
                exit
            fi
        moneydateselect
    ;;
    *)
        moneydateselect
    ;;
esac
}

moneyoutincount () {
grep -v DATE $DATAPATH/$USERNAME$YEAR.db|awk 'BEGIN{print "DATEOFYEAR!!\tDAYOUT\tALLOUT\tDAYIN\tALLIN"}{sumout=sumout+$2+$3+$4+$5+$6+$7}{sumin=sumin+$8}{print $1"\t"$2+$3+$4+$5+$6+$7"\t"sumout"\t"$8"\t"sumin}' > $DATAPATH/$USERNAME$YEAR.outin
$DIALOG --clear --title "$YEAR account record" --textbox "$DATAPATH/$USERNAME$YEAR.outin" 22 90
case $? in
    *)
        moneymenu;;
esac
}

moneymenu 
