#!/bin/sh
# Anas Nashif <nashif@suse.de>
# Martin Vidner <mvidner@suse.cz>
# collect RNC files, create a schema in cwd
#
set -o errexit

: ${PREFIX:=/usr}
SCHEMA_DIR="$PREFIX/share/YaST2/schema/autoyast/rnc"
DESKTOP_DIR="$PREFIX/share/autoinstall/modules"
DESKTOP_DIR2="$PREFIX/share/applications/YaST2"

: ${SRC:=src}
: ${RNC_OUTPUT:=.}
COMMON=$SCHEMA_DIR/common.rnc
TEMPLATE=$SRC/profile.rnc.templ

rm -f $RNC_OUTPUT/includes.rnc
cp $COMMON $RNC_OUTPUT


# initialize
install=""
configure=""

# check all desktop files

for desktop in `find $DESKTOP_DIR $DESKTOP_DIR2 -name '*.desktop' | LC_ALL=C sort`; do
    unset X_SuSE_YaST_AutoInstSchema
    unset X_SuSE_YaST_AutoInstResource
    unset X_SuSE_YaST_AutoInstPath
    unset X_SuSE_YaST_AutoInstOptional

    eval $(grep "^X-SuSE-YaST-AutoInst" $desktop | sed -e 's/X-SuSE-YaST-/X_SuSE_YaST_/' )

    if [ -z "$X_SuSE_YaST_AutoInstResource" ]; then
        resource=`basename $desktop .desktop`
    else
        resource=$X_SuSE_YaST_AutoInstResource
    fi

    # HACK: avoid creating a separate desktop file
    # for user_defaults (#215249#c7)
    if [ "$resource" = "users" ]; then
	resource="user_defaults? & groups? & login_settings? & users"
    fi

    if [ ! -z "${X_SuSE_YaST_AutoInstSchema}" ]; then

        cp  $SCHEMA_DIR/${X_SuSE_YaST_AutoInstSchema} $RNC_OUTPUT
        
        echo "include '${X_SuSE_YaST_AutoInstSchema}'" >> $RNC_OUTPUT/includes.rnc

        if [ -z "$X_SuSE_YaST_AutoInstOptional" -o "$X_SuSE_YaST_AutoInstOptional" = "true" ]; then
	    optional="?"
	else
	    optional=""
	fi

	if [ "$X_SuSE_YaST_AutoInstPath" = "install" ]; then
	    install="$install & $resource$optional"
	else
	    configure="$configure & $resource$optional"
        fi
    fi

done

# remove the initial connector
install="${install# & }"
configure="${configure# & }"

echo >&2 "install:   $install"
echo >&2 "configure: $configure"

# escape the connector for sed: & -> \&
install="${install//&/\\&}"
configure="${configure//&/\\&}"

# add those components we have found
sed -e "s/CONFIGURE_RESOURCE/${configure}/" \
    -e "s/INSTALL_RESOURCE/${install}/" \
    $TEMPLATE > $RNC_OUTPUT/profile.rnc
