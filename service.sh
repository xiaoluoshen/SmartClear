#!/system/bin/sh
# AutoPurge Pro - Android 16 Optimized Service Script

# 等待系统启动完成
while [ "$(getprop 'sys.boot_completed')" != '1' ]; do sleep 1; done
while [ "$(getprop 'init.svc.bootanim')" != 'stopped' ]; do sleep 1; done

# 确保 /sdcard 已挂载并可写 (Android 16 存储适配)
SDCARD_READY=0
for i in $(seq 1 30); do
    if [ -d "/sdcard/Android" ]; then
        touch /sdcard/.smartclear_test && rm /sdcard/.smartclear_test
        if [ $? -eq 0 ]; then
            SDCARD_READY=1
            break
        fi
    fi
    sleep 2
done

if [ $SDCARD_READY -eq 0 ]; then
    exit 1
fi

# 模块路径检测
Module_Path="/data/adb/modules"
if [ -f "/data/adb/ksu" ] || [ -d "/data/adb/ksu" ]; then
    # KernelSU 适配
    if [ -d "/data/adb/ksu/modules" ]; then
        Module_Path="/data/adb/ksu/modules"
    fi
fi

Rubbish_Path="$Module_Path/Clear_Rubbish"
Config_Base="/data/media/0/Android/Clear/清理垃圾"

# 权限修复
find "$Rubbish_Path" -type d -exec chmod 755 {} + >/dev/null 2>&1
find "$Rubbish_Path" -type f -exec chmod 755 {} + >/dev/null 2>&1
[ -d "$Config_Base" ] && find "$Config_Base" -type f -name "*.conf" -exec chmod 644 {} + >/dev/null 2>&1

# 定时任务设置
Timer_Settings() {
    local target_path="$Rubbish_Path/cron.d"
    mkdir -p "$target_path"
    touch "$target_path/root"
    chmod 600 "$target_path/root"
}

SetTiming() {
    config_file="$Config_Base/自定义定时设置/定时设置.conf"
    if [ -f "$config_file" ]; then
        # 提取配置并生成 crontab 格式
        Set_Time1=$(grep 'Set_Time1=' "$config_file" | cut -d'=' -f2 | tr -d '\r')
        Set_minute1=$(grep 'Set_minute1=' "$config_file" | cut -d'=' -f2 | tr -d '\r')
        Set_weekday1=$(grep 'Set_weekday1=' "$config_file" | cut -d'=' -f2 | tr -d '\r')
        
        Set_Time2=$(grep 'Set_Time2=' "$config_file" | cut -d'=' -f2 | tr -d '\r')
        Set_minute2=$(grep 'Set_minute2=' "$config_file" | cut -d'=' -f2 | tr -d '\r')
        Set_weekday2=$(grep 'Set_weekday2=' "$config_file" | cut -d'=' -f2 | tr -d '\r')

        # 默认值处理
        [ -z "$Set_Time1" ] && Set_Time1="0"
        [ -z "$Set_minute1" ] && Set_minute1="0"
        [ -z "$Set_weekday1" ] && Set_weekday1="*"
        [ "$Set_minute1" = "00" ] && Set_minute1="0"
        
        [ -z "$Set_Time2" ] && Set_Time2="6"
        [ -z "$Set_minute2" ] && Set_minute2="0"
        [ -z "$Set_weekday2" ] && Set_weekday2="*"
        [ "$Set_minute2" = "00" ] && Set_minute2="0"

        echo "$Set_minute1 $Set_Time1 * * $Set_weekday1 /system/bin/sh $Rubbish_Path/Service_Main" > "$Rubbish_Path/cron.d/root"
        echo "$Set_minute2 $Set_Time2 * * $Set_weekday2 /system/bin/sh $Rubbish_Path/Service_Main" >> "$Rubbish_Path/cron.d/root"
    fi
}

Timer_Settings
SetTiming

# 启动 crond
if [ -f "/data/adb/ksu/bin/busybox" ]; then
    /data/adb/ksu/bin/busybox crond -c "$Rubbish_Path/cron.d/"
elif [ -f "/data/adb/magisk/busybox" ]; then
    /data/adb/magisk/busybox crond -c "$Rubbish_Path/cron.d/"
else
    busybox crond -c "$Rubbish_Path/cron.d/" >/dev/null 2>&1
fi

# 启动主服务
/system/bin/sh "$Rubbish_Path/Service_Main" &
/system/bin/sh "$Rubbish_Path/Service_Smart" &
/system/bin/sh "$Rubbish_Path/Service_Log" &

exit 0
