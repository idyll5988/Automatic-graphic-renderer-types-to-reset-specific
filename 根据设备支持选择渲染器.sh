#!/system/bin/sh
if command -v resetprop > /dev/null 2>&1; then
    resetprop=$(command -v resetprop)
else
    if [ -f /data/adb/ksu/bin/resetprop ]; then
        resetprop="/data/adb/ksu/bin/resetprop"
    elif [ -f /data/adb/ap/bin/resetprop ]; then
        resetprop="/data/adb/ap/bin/resetprop"
    else
        resetprop="setprop"
    fi
fi

vvk="grep vulkanVersion"
getvk="grep vulkan"

echo "当前渲染 : $(getprop debug.hwui.renderer)"
if [ "$(dumpsys gpu | $vvk)" ] || [ "$(getprop | $getvk)" ]; then
    echo "启用 Vulkan 渲染器..."
    resetprop -n debug.hwui.renderer skiavk
    resetprop -n debug.hwui.use_vulkan 1
    resetprop -n debug.renderengine.backend skiavkthreaded
    resetprop -n debug.force-opengl null
    resetprop -n debug.force-skiagl null
else
    echo "启用 OpenGL 渲染器..."
    resetprop -n debug.hwui.renderer skiagl
    resetprop -n debug.renderengine.backend skiaglthreaded
    resetprop -n debug.force-skiagl 1
    resetprop -n debug.hwui.use_vulkan null
fi
echo "当前渲染 : $(getprop debug.hwui.renderer)"

