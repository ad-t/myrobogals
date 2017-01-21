PYTHON_VERSION="python2.7"
PIP_VERSION="pip2.7"
VENV_BIN_DIR="./venv/bin"
VIRTUALENV_INSTALLATION="/usr/bin/virtualenv"
REQUIREMENTS="./requirements.txt"
VENV_NAME="venv"
EXIT_FAILURE=1
EXIT_SUCCESS=0
# String constants
err="ERROR:"

main() {
    if $(which virtualenv > /dev/null 2>&1)
    then
        printf "Creating virtualenv folder at: ./$VENV_NAME ... "
        set_up_and_activate_venv
    else
        echo "$err Please install 'virtualenv'"
    fi
}

set_up_and_activate_venv() {
    if $(virtualenv "$VENV_NAME" > /dev/null)
    then
        echo "Done"
        $(virtualenv "$VENV_NAME" --python=$PYTHON_VERSION > /dev/null)
        if $(source ./$VENV_NAME/bin/activate > /dev/null)
        then
            printf "Install requirements ($REQUIREMENTS) ..."
            if $($VENV_BIN_DIR/$PIP_VERSION install --upgrade -r $REQUIREMENTS > /dev/null)
            then
                echo "Done"
            else
                echo "$err Unable to install required packages"
            fi
        else
            echo "$err virtualenv was unable to activate"
        fi
    else
        echo "$err Invalid virtualenv name: $VENV_NAME"
    fi
}

main
