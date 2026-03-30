# Unlock CN GMS
The GMS is restricted in China on some devices, because of configuration files that declare `cn.google.services` feature.
By this restriction, you can not enable `Google Location History` and the `Google Map Timeline` function can not use either.

This module removes the restriction by replacing these configuration files.

Supported file locations:
- `/system/etc/permissions/services.cn.google.xml`
- `/system/etc/permissions/com.oppo.features.cn_google.xml`
- `/vendor/etc/permissions/services.cn.google.xml`
- `/product/etc/permissions/services.cn.google.xml`
- `/product/etc/permissions/cn.google.services.xml`
- `/product/etc/sysconfig/cn_feature.xml`
- `/odm/etc/permissions/com.gnss.bds_preference.xml` (Xiaomi 8e5 等机型)
- `/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml`
- `/my_product/etc/permissions/oplus_google_cn_gms_features.xml`
- `/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml`

---
部分国行手机，或者本地化后的 ROM 中有内置 GMS ，但是某些功能无法使用，比如无法开启 `Google Location History` 服务，无法使用 `Google Map Timeline`，设备无法在 Web 版 Google play 中显示等等。

该模块通过查找并替换所有声明了 `cn.google.services` 的权限配置文件, 具体为删除如下配置行：

 ```xml
 <feature name="cn.google.services" />
 <feature name="com.google.android.feature.services_updater" />
 ``` 
 以此来实现去除国行 GMS 的限制。

 注意：部分设备上可能同时存在多个配置文件（如小米 8e5 同时在 `/odm` 和 `/product` 分区下各有一个），本模块会自动处理所有匹配的文件。对于独立挂载的分区（如 `/odm`、`/my_bigball` 等），通过 bind mount 方式替换。

 **注意**：为了开启 `Google Location History` 服务，你可能还需要配合其他模块   
 例如
 Magisk 模块: ~~[Riru - Location Report Enabler](https://github.com/RikkaApps/Riru-LocationReportEnabler)~~     
 或者 Xposed 模块 [LocationReportEnabler](https://github.com/GhostFlying/LocationReportEnabler)
