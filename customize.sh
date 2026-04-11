#!/system/bin/sh

FILES="\
/system/etc/permissions/services.cn.google.xml
/system/etc/permissions/com.oppo.features.cn_google.xml
/vendor/etc/permissions/services.cn.google.xml
/product/etc/permissions/services.cn.google.xml
/product/etc/permissions/cn.google.services.xml
/product/etc/sysconfig/cn_feature.xml
/odm/etc/permissions/com.gnss.bds_preference.xml
/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
/my_product/etc/permissions/oplus_google_cn_gms_features.xml
/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml"

found=false
need_bind_mount=false

for origin in $FILES; do
    [ ! -e "$origin" ] && continue
    found=true

	case "$origin" in
		*my_bigball*)
			target=$MODPATH/oplus_google_cn_gms_features.xml
			echo "mount -o ro,bind \${0%/*}/oplus_google_cn_gms_features.xml /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml" >> $MODPATH/post-fs-data.sh
			need_bind_mount=true
			;;
		*my_product*)
			target=$MODPATH/oplus_google_cn_gms_features.xml
			echo "mount -o ro,bind \${0%/*}/oplus_google_cn_gms_features.xml /my_product/etc/permissions/oplus_google_cn_gms_features.xml" >> $MODPATH/post-fs-data.sh
			need_bind_mount=true
			;;
		*my_heytap*)
			target=$MODPATH/my_heytap_cn_gms_features.xml
			echo "mount -o ro,bind \${0%/*}/my_heytap_cn_gms_features.xml /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml" >> $MODPATH/post-fs-data.sh
			need_bind_mount=true
			if [ -e /my_heytap/etc/permissions/my_heytap_cn_features.xml ]; then
				echo "mount -o ro,bind \${0%/*}/my_heytap_cn_features.xml /my_heytap/etc/permissions/my_heytap_cn_features.xml" >> $MODPATH/post-fs-data.sh
				heytap_cn_features_orgin=/my_heytap/etc/permissions/my_heytap_cn_features.xml
				heytap_cn_features_target=$MODPATH/my_heytap_cn_features.xml
			fi
			;;
		/odm/*)
			target=$MODPATH/$(basename $origin)
			echo "mount -o ro,bind \${0%/*}/$(basename $origin) $origin" >> $MODPATH/post-fs-data.sh
			need_bind_mount=true
			;;
		*system*)
			target=$MODPATH$origin
			;;
		*)
			target=$MODPATH/system$origin
			;;
	esac

    mkdir -p $(dirname $target)
    cp -f $origin $target
    sed -i '/cn.google.services/d' $target
    sed -i '/services_updater/d' $target
    ui_print "modify $origin"
done

if $need_bind_mount; then
    sed -i '1i#!/system/bin/sh' $MODPATH/post-fs-data.sh
fi

if [ -e "$heytap_cn_features_orgin" ]; then
    mkdir -p $(dirname $heytap_cn_features_target)
    cp -f $heytap_cn_features_orgin $heytap_cn_features_target
    sed -i '/cn.google.services/d' $heytap_cn_features_target
    sed -i '/services_updater/d' $heytap_cn_features_target
    ui_print "modify $heytap_cn_features_orgin"
fi

$found || abort "No suitable permission file found!"
