#!/bin/sh
################### DB env check ########
dbenvcheck () {
    if [ ! -d $WORKPATH ] || [ ! -d $DATAPATH ]; then
        mkdir -p $DATAPATH
        echo "create work/data path"
    fi

    if [ ! -w $WORKPARH ] || [ ! -w $DATAPATH ]; then
        echo "You NOT ALLOW to edit $WORKPATH or $DATAPATH"
        exit 1
    fi
    echo "env is good"
}
dbenvcheck
################### DB check ############
dbcheck () {
    if [ ! -f $DATAPATH/$YEAR.db ]; then
        dbinit
    fi
}
############ DB Initialization #########
dbinit () {
    if [ `expr $YEAR % 4` -eq 0 ]; then
        leapyeardb
    else
        normyeardb
    fi    
}
########### leap year DB init ############
leapyeardb () {
    echo -e "DATEOFYEAR!!\tEAT_A\tEAT_B\tEAT_C\tTRAFFIC\tSHOP\tMEDICAL\tINCOME\tCOMMENTS" >> $DATAPATH/$YEAR.db
    for NUM in {0..365}; do
        echo -e `date +%Y%m%d-%a -d ""$YEAR"0101 +$NUM day"`"\t0\t0\t0\t0\t0\t0\t0\tComments:" >> $DATAPATH/$YEAR.db
    done
}
########## normal year db init ############
normyeardb () {
    echo -e "DATEOFYEAR!!\tEAT_A\tEAT_B\tEAT_C\tTRAFFIC\tSHOP\tMEDICAL\tINCOME\tCOMMENTS" >> $DATAPATH/$YEAR.db
    for NUM in {0..364}; do
        echo -e `date +%Y%m%d-%a -d ""$YEAR"0101 +$NUM day"`"\t0\t0\t0\t0\t0\t0\t0\tComments:" >> $DATAPATH/$YEAR.db
    done
}

dbcheck
