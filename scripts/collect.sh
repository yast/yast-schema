#!/bin/sh
# Anas Nashif <nashif@suse.de>
# collect RNC files and create RNG out of them
#

SCHEMA_DIR="/usr/share/YaST2/schema/autoyast/rnc"
DESKTOP_DIR="/usr/share/autoinstall/modules"
DESKTOP_DIR2="/usr/share/applications/YaST2/"


tmp_dir=`mktemp -d /tmp/schema.XXXXXXXXXX`

RNC_OUTPUT="src/rnc"
RNG_OUTPUT="src/rng"

mkdir -p $RNC_OUTPUT $RNG_OUTPUT

rm -f $RNC_OUTPUT/includes.rnc
cp src/common.rnc $RNC_OUTPUT


# check all desktop files

for desktop in `find $DESKTOP_DIR $DESKTOP_DIR2 -name *.desktop`; do
    unset X_SuSE_YaST_AutoInstSchema
    unset X_SuSE_YaST_AutoInstResource
    unset X_SuSE_YaST_AutoInstPath
    unset X_SuSE_YaST_AutoInstOptional

    eval $(grep "^X-SuSE-YaST" $desktop | sed -e 's/-/_/g' )

    if [ -z "$X_SuSE_YaST_AutoInstResource" ]; then
        resource=`basename $desktop .desktop`
    else
        resource=$X_SuSE_YaST_AutoInstResource
    fi


    if [ ! -z "${X_SuSE_YaST_AutoInstSchema}" ]; then

        cp  $SCHEMA_DIR/${X_SuSE_YaST_AutoInstSchema} $RNC_OUTPUT
        
        echo "include \"${resource}.rnc\"" >> $RNC_OUTPUT/includes.rnc

        if [ -z "$X_SuSE_YaST_AutoInstOptional" -o "$X_SuSE_YaST_AutoInstOptional" = "false" ]; then
            if [ "$X_SuSE_YaST_AutoInstPath" = "install" ]; then
                if [ -z "$install" ]; then 
                    install="$resource? "
                else
                    install="$install \& $resource? "
                fi
            else
                if [ -z "$configure" ]; then 
                    configure="$resource? "
                else
                    configure="$configure \& $resource? "
                fi
            fi
        else
            if [ "$X_SuSE_YaST_AutoInstPath" = "install" ]; then
                if [ -z "$install" ]; then 
                    install="$resource "
                else
                    install="$install \& $resource "
                fi
            else
                if [ -z "$configure" ]; then 
                    configure="$resource "
                else
                    configure="$configure \& $resource "
                fi
            fi
        fi
    fi

done


# add those components we have found
sed -e "s/CONFIGURE_RESOURCE/${configure}/" \
    -e "s/INSTALL_RESOURCE/${install}/" \
    src/profile.rnc.templ > $RNC_OUTPUT/profile.rnc

# Now convert from RNC to RNG
trang -I rnc -O rng $RNC_OUTPUT/profile.rnc $RNG_OUTPUT/profile.rng

# clean up
rm -rf $tmp_dir
