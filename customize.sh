if [ -e /system/etc/permissions/services.cn.google.xml ]; then
    origin=/system/etc/permissions/services.cn.google.xml
elif [ -e /system/etc/permissions/com.oppo.features.cn_google.xml ]; then
    origin=/system/etc/permissions/com.oppo.features.cn_google.xml
elif [ -e /vendor/etc/permissions/services.cn.google.xml ]; then
    origin=/vendor/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/services.cn.google.xml ]; then
    origin=/product/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/cn.google.services.xml ]; then
    origin=/product/etc/permissions/cn.google.services.xml
elif [ -e /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml ]; then
    origin=/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
else
    exit 0
fi

if [[ $origin == *system* ]]; then
    target=$MODPATH$origin
elif [[ $origin == *my_bigball* ]]; then
    target=$MODPATH/oplus_google_cn_gms_features.xml
    echo -e '#!/system/bin/sh\nmount -o ro,bind ${0%/*}/oplus_google_cn_gms_features.xml /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/post-fs-data.sh
    # echo 'sleep 60; umount /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml' > $MODPATH/service.sh
else
    target=$MODPATH/system$origin
fi

mkdir -p $(dirname $target)
cp -f $origin $target
sed -i '/cn.google.services/d' $target
sed -i '/services_updater/d' $target
