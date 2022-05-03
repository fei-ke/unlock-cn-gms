if [ -e /system/etc/permissions/services.cn.google.xml ]; then
    origin=/system/etc/permissions/services.cn.google.xml
elif [ -e /vendor/etc/permissions/services.cn.google.xml ]; then
    origin=/vendor/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/services.cn.google.xml ]; then
    origin=/product/etc/permissions/services.cn.google.xml
elif [ -e /product/etc/permissions/cn.google.services.xml ]; then
    origin=/product/etc/permissions/cn.google.services.xml
else
    exit 0
fi

if [[ $origin == *system* ]]; then
    target=$MODPATH$origin
else
    target=$MODPATH/system$origin
fi

mkdir -p $(dirname $target)
cp -f $origin $target
sed -i '/cn.google.services/d' $target
sed -i '/services_updater/d' $target

REPLACE="
/system/product/app/GoogleLocationHistory/
"
