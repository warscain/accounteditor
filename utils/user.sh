#!/bin/sh

################ 

echo -n "Login or Create a uesr??L/C(L):"
read LOC

case $LOC in
    [Cc])
### add user
        echo -n "Input new user name(only letters and numbers):"
        read USERNAME
        export USERNAME

        if [ ! $USERNAME ]; then
        echo USERNAME is null
        exit
        fi

        if [[ $USERNAME =~ ^[0-9a-zA-Z]+$ ]];then
            if [ -f $DATAPATH/$USERNAME$YEAR.db ]; then
                echo "The user exist."
                exit 1
            else
            cp $DATAPATH/$YEAR.db $DATAPATH/$USERNAME$YEAR.db
            sh ./utils/core.sh
            fi
        fi
        ;;
    [Ll])
        echo -n "Login as:"
        read USERNAME
        if [ ! -z $USERNAME ] && [ -f $DATAPATH/$USERNAME$YEAR.db ]; then
            export USERNAME
            sh ./utils/core.sh
        else
            echo "No such user."
        fi
        ;;
    "")
        echo -n "Login as:"
        read USERNAME
        if [ ! -z $USERNAME ] && [ -f $DATAPATH/$USERNAME$YEAR.db ]; then
            export USERNAME
            sh ./utils/core.sh
        else
            echo "no such user."
        fi
        ;;
    *)
          echo Wrong input, exit.
          exit 1;;
esac


#openssl passwd -table -1 -salt 'sMsmOX1X' -stdin < /usr/share/dict/words |grep xULJszZPxUndwp0nA8szK0
