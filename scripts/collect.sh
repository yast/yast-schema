#!/bin/sh
# Anas Nashif <nashif@suse.de>
# collect RNC files and create RNG out of them
#

: ${PREFIX:=/usr}
SCHEMA_DIR="$PREFIX/share/YaST2/schema/autoyast/rnc"
DESKTOP_DIR="$PREFIX/share/autoinstall/modules"
DESKTOP_DIR2="$PREFIX/share/applications/YaST2"

#unused
tmp_dir=`mktemp -d /tmp/schema.XXXXXXXXXX`

RNC_OUTPUT="src/rnc"
RNG_OUTPUT="src/rng"

mkdir -p $RNC_OUTPUT $RNG_OUTPUT

rm -f $RNC_OUTPUT/includes.rnc
cp src/common.rnc $RNC_OUTPUT


# initialize
# (so that we can start connecting with '&')
install=notAllowed
configure=notAllowed

# check all desktop files

for desktop in `find $DESKTOP_DIR $DESKTOP_DIR2 -name '*.desktop'`; do
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
        
        echo "include '${resource}.rnc'" >> $RNC_OUTPUT/includes.rnc

        if [ -z "$X_SuSE_YaST_AutoInstOptional" -o "$X_SuSE_YaST_AutoInstOptional" = "true" ]; then
	    optional="?"
	else
	    optional=""
	fi

	# '&' must be escaped because of sed
	if [ "$X_SuSE_YaST_AutoInstPath" = "install" ]; then
	    install="$install \& $resource$optional"
	else
	    configure="$configure \& $resource$optional"
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
