#!/bin/sh
# Anas Nashif <nashif@suse.de>
# Martin Vidner <mvidner@suse.cz>
# collect RNC files, create a schema in cwd
#

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

    package_name=`/bin/rpm -qf $desktop --qf %{NAME}`

    X_SuSE_YaST_AutoInstSchema=`grep "^X-SuSE-YaST-AutoInstSchema" $desktop`
    X_SuSE_YaST_AutoInstSchema=${X_SuSE_YaST_AutoInstSchema##*=}
    X_SuSE_YaST_AutoInstResource=`grep "^X-SuSE-YaST-AutoInstResource=" $desktop` # do not take AutoInstResourceAliases
    X_SuSE_YaST_AutoInstResource=${X_SuSE_YaST_AutoInstResource##*=}
    X_SuSE_YaST_AutoInstPath=`grep "^X-SuSE-YaST-AutoInstPath" $desktop`
    X_SuSE_YaST_AutoInstPath=${X_SuSE_YaST_AutoInstPath##*=}
    X_SuSE_YaST_AutoInstOptional=`grep "^X-SuSE-YaST-AutoInstOptional" $desktop`
    X_SuSE_YaST_AutoInstOptional=${X_SuSE_YaST_AutoInstOptional##*=}

    if [ -z "$X_SuSE_YaST_AutoInstResource" ]; then
	resource=`basename $desktop .desktop`
        resource="FLAG__X_SuSE_YaST_AutoInstResource__not_set__in_$resource"
    else
        resource=$X_SuSE_YaST_AutoInstResource
    fi

    # HACK: avoid creating a separate desktop file
    # for user_defaults (#215249#c7)
    if [ "$resource" = "users" ]; then
	resource="user_defaults? & groups? & login_settings? & users"
    fi

    # same hack as for users. pxe.rnc is part of autoyast but has no client
    if [ "$resource" = "general" ]; then
        resource="general? & pxe"
        cp  $SCHEMA_DIR/pxe.rnc $RNC_OUTPUT
        echo "include 'pxe.rnc' # autoyast2" >> $RNC_OUTPUT/includes.rnc
    fi

    if [ ! -z "${X_SuSE_YaST_AutoInstSchema}" ]; then

        cp  $SCHEMA_DIR/${X_SuSE_YaST_AutoInstSchema} $RNC_OUTPUT
        
        echo "include '${X_SuSE_YaST_AutoInstSchema}' # $package_name" >> $RNC_OUTPUT/includes.rnc

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
