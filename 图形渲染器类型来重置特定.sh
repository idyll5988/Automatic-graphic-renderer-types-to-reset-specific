#!/system/bin/sh
#获取当前的硬件UI渲染器类型，自动匹配，（OpenGL ES）和 （Vulkan）
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
case "$render" in
    "skiagl")
        resetprop debug.hwui.renderer skiagl
        resetprop vendor.debug.renderengine.backend skiaglthreaded
        resetprop debug.renderengine.backend skiaglthreaded
        resetprop debug.hwui.render_thread true
        resetprop debug.skia.threaded_mode true
        resetprop debug.hwui.render_thread_count 1
        resetprop debug.skia.num_render_threads 1
        resetprop debug.skia.render_thread_priority 1
        resetprop persist.sys.gpu.working_thread_priority 1	
        resetprop debug.gles.layers EGL_KHR_gl_texture_cubemap_image,EGL_KHR_gl_texture_3D_image,EGL_KHR_gl_renderbuffer_image
        echo "$date *重置skiagl渲染器的GLES层*" 
        ;;
    "skiavk")
        resetprop debug.hwui.renderer skiavk
        resetprop debug.renderengine.backend skiavkthreaded
        resetprop ro.hwui.use_vulkan 1
        resetprop ro.hwui.hardware.vulkan true
        resetprop ro.hwui.use_vulkan true
        resetprop ro.hwui.skia.show_vulkan_pipeline true
        resetprop persist.sys.disable_skia_path_ops false
        resetprop ro.config.hw_high_perf true
        resetprop debug.hwui.disable_scissor_opt true
        resetprop debug.vulkan.layers.enable 1
        resetprop debug.hwui.render_thread true	
        resetprop debug.vulkan.layers VK_KHR_shared_presentable_image,VK_KHR_16bit_storage,VK_KHR_android_surface
        echo "$date *重置skiavk渲染器的Vulkan层*" 
        ;;
    *)
        echo "$date *未知渲染器: $render*" 
        ;;
esac
