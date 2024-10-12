#!/system/bin/sh
if ! command -v reresetprop > /dev/null 2>&1; then
    if [ -f /data/adb/ksu/bin/reresetprop ]; then
        alias reresetprop=/data/adb/ksu/bin/reresetprop
    elif [ -f /data/adb/ap/bin/reresetprop ]; then
        alias reresetprop=/data/adb/ap/bin/reresetprop
    else
        alias reresetprop=setprop
    fi
    export reresetprop
fi
(echo "\n  按下音量按钮\n   音量 + : SkiaGL\n   音量 - : SkiaVK\n";
while true;do 
input="$(timeout 0.1 getevent -l|grep -Eo 'VOLUMEUP|VOLUMEDOWN'|head -n1)";
if [ "$input" = "VOLUMEUP" ];then 
echo "   已选定 : SkiaGL\n";
resetprop -n debug.hwui.renderer skiagl
resetprop -n debug.renderengine.backend skiaglthreaded
resetprop -n debug.force-skiagl 1
resetprop -n debug.hwui.use_vulkan null
break;
elif [ "$input" = "VOLUMEDOWN" ];then 
echo "   已选定 : SkiaVK\n";
resetprop -n debug.hwui.renderer skiavk
resetprop -n debug.hwui.use_vulkan 1
resetprop -n debug.renderengine.backend skiavkthreaded
resetprop -n debug.force-opengl null
resetprop -n debug.force-skiagl null
break;
fi;
done;
resetprop -n debug.hwui.skia_tracing_enabled false;
resetprop -n debug.hwui.skia_use_perfetto_track_events false;
resetprop -n debug.skia.num_render_threads 1;
resetprop -n debug.skia.render_thread_priority 1;
resetprop -n debug.skia.threaded_mode true;
resetprop -n persist.sys.disable_skia_path_ops false;
resetprop -n renderthread.skia.reduceopstasksplitting true)2>/dev/null