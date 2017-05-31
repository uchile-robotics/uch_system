#!/bin/bash

# https://github.com/megastep/makeself
# TODO: links simbolicos relativos en bender!

# pre checks
# ===========================================
# check UChile ROS Workspace exists
if [ -z "${UCHILE_SYSTEM}" ]; then
    echo "UChile ROS Framework is not available."
fi


# configs
# ===========================================
makeself_parentdir="${UCHILE_DEPS_WS}"/common/system
makeself_dir="${makeself_parentdir}"/makeself

targetdir="${UCHILE_WS}"
targetfile="${HOME}"/uchile.run
targetlabel="UChile ROS Framework .run file. Created: $(date +"%Y/%m/%d %H:%M:%S")"


# checks
# ===========================================

# file already exists
if [ -e "${targetfile}" ]; then
    printf  " - A .run file already exists: %s\n" "${targetfile}"
    read -p "   Do you want to overwrite it? [Y/n]" -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "    - deleting .run file.\n"
        rm "${targetfile}"
    else
        printf "    - Bye!.\n"
        exit 1
    fi
fi

# makeself repository
mkdir -p "${makeself_parentdir}"
if [ ! -d "${makeself_dir}" ]; then
    printf " - cloning makeself repository: %s\n" "${makeself_dir}"
    git clone https://github.com/megastep/makeself "${makeself_dir}"
else
    printf " - [OK] makeself tool already exists: %s\n" "${makeself_dir}"
fi


# RUN
# ===========================================
cd "$HOME"

# makeself.sh [args] archive_dir file_name label startup_script [script_args]
#sh "${makeself_dir}/makeself.sh" --notemp "${targetdir}" "${targetfile}" "${targetlabel}" echo "Migrated"
#touch "${targetfile}"