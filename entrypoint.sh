#!/bin/bash
set -e


if [[ -d ${USER_CONFIG_DIR} ]]; then

    ls ${USER_CONFIG_DIR} | while read config
    do
        echo "check ${config} file"

        if [[ -f ${BIND_DIR}/${config} ]]; then
            echo ">>>> remove ${config} file in bind path"
            rm ${BIND_DIR}/${config}
        fi

        if [ ${USE_BIND_CONFIG_SYMLINK} = "yes" ]; then
            ln -s ${USER_CONFIG_DIR}/${config} ${BIND_DIR}/${config}
            chown root:${BIND_GROUP} ${BIND_DIR}/${config}
        else
            echo ">>>> add ${config} file form ext config"
            install -g ${BIND_GROUP} -o ${BIND_USER} ${USER_CONFIG_DIR}/${config} ${BIND_DIR}
        fi
        
        echo ">>>> mod change 755"
        chmod 0755 ${BIND_DIR}/${config}

    done
fi


# default behaviour is to launch named
if [[ -z ${1} ]]; then

    echo "Starting named..."
    exec /usr/sbin/named -g -c /etc/bind/named.conf -u bind
else
    echo "Starting named...else"
    exec "$@"
fi
