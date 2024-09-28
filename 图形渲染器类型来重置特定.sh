#!/system/bin/sh
date="$( date "+%Y年%m月%d日%H时%M分%S秒")"
render=$(getprop debug.hwui.renderer)
if ! command -v resetprop > /dev/null 2>&1; then
    if [ -f /data/adb/ksu/bin/resetprop ]; then
        alias resetprop=/data/adb/ksu/bin/resetprop
    elif [ -f /data/adb/ap/bin/resetprop ]; then
        alias resetprop=/data/adb/ap/bin/resetprop
    else
        alias resetprop=setprop
    fi
    export resetprop
fi
echo "$date *当前渲染引擎$render*" 
case "$render" in
    "skiagl")
        resetprop debug.gles.layers EGL_KHR_gl_texture_cubemap_image,EGL_KHR_gl_texture_3D_image,EGL_KHR_gl_renderbuffer_image
        echo "$date *重置skiagl渲染器的GLES层*" 
        ;;
    "skiavk")
        resetprop debug.vulkan.layers VK_KHR_shared_presentable_image,VK_KHR_16bit_storage,VK_KHR_android_surface
        echo "$date *重置skiavk渲染器的Vulkan层*" 
        ;;
    *)
        echo "$date *未知渲染器: $render*" 
        ;;
esac
