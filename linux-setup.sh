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
        configure_db "$1"
        echo 
        echo "Configuration complete"
        echo "Please run \`. ./venv/bin/activate\` and \`python manage.py runserver\` to launch the server"
        echo "Run \`deactivate\` to close virtualenv"
    else
        printf "\n$err Please install 'virtualenv'"
    fi
}

configure_db () {
    SETTINGS_FILE="$1"
    if [ -e $SETTINGS_FILE ]
    then
        source ./$VENV_NAME/bin/activate > /dev/null
        echo "Migrating database changes ... "
        python manage.py migrate
        echo "done"
        echo """
from myrobogals.rgmain.models import Timezone
Timezone.objects.all().delete()
quit()
        """ > temp$$.py
        printf "Removing conflicts ... "
        python manage.py shell < temp$$.py > /dev/null
        rm temp$$.py
        echo "done"
        printf "Loading sample data ... "
        python manage.py loaddata sampledata > /dev/null
        echo "done"
    else
        printf "\n$err Settings file does not exist.\n"
        echo "Please create one or use the sample provided in the 'myrobogals' directory"
    fi
}

set_up_and_activate_venv() {
    if $(virtualenv "$VENV_NAME" > /dev/null)
    then
        echo "done"
        printf "Setting python version to: $PYTHON_VERSION ... "
        $(virtualenv "$VENV_NAME" --python=$PYTHON_VERSION > /dev/null)
        echo "done"
        if $(source ./$VENV_NAME/bin/activate > /dev/null)
        then
            printf "Install requirements ($REQUIREMENTS) ... "
            if $($VENV_BIN_DIR/$PIP_VERSION install --upgrade -r $REQUIREMENTS > /dev/null)
            then
                echo "done"
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

# SCRIPT
if [ "$#" -ne "1" ]
then
    echo "Usage: ./linux-setup.sh <settings_file>"
    exit $EXIT_FAILURE
else
    main "$1"
fi
