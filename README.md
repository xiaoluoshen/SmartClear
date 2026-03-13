
# AutoPurge Pro 🗑️

![Magisk/KernelSU Module](https://img.shields.io/badge/Magisk%2FKernelSU-Compatible-brightgreen)
![Android 8.0 - 16](https://img.shields.io/badge/Android-8.0%2B-blue)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-yellow)](LICENSE)

智能垃圾清理自动化工具，为 Android 设备提供深度清理和资源管理能力。

---

## ✨ 核心功能

| 功能                | 描述                                                                 |
|---------------------|----------------------------------------------------------------------|
| **定时清理**         | 默认每日凌晨 00:00 自动执行，支持自定义多时间段                      |
| **MT管理器专项清理** | 检测到 MT 管理器前台运行时，自动清理 `/sdcard/` 残留文件             |
| **日志管理**         | 自动清理 `Clear.log` 日志文件，可配置大小阈值（支持 `KB/MB` 单位）   |
| **双名单机制**       | 黑名单强制清理路径 / 白名单保护路径                                 |
| **资源监控**         | 实时统计累计清理数据，并展示在 Magisk/KernelSU 模块描述中            |

---

## 🚀 快速部署

### 环境要求
- **Magisk v24+** 或 **KernelSU**
- Android 8.0 - 16 (API Level 26 - 36)
- 确保 `/sdcard` 分区可读写

### 安装流程
1. 下载最新版模块包：[AutoPurge.zip](https://github.com/S123123sd/SmartClear/releases/tag/AutoPurge)
2. 通过 Magisk/KernelSU 刷入模块
3. 重启设备
4. 自动生成配置文件目录：
   ```bash
   /sdcard/Android/Clear/清理垃圾/
   ├── 名单配置/          # 路径规则配置
   │   ├── 黑名单.conf    # 强制清理路径
   │   ├── 白名单.conf    # 保护路径
   │   └── MT.conf       # MT管理器专用规则
   ├── 自定义定时设置/    # 高级定时配置
   │   └── 定时设置.conf 
   └── 配置.conf          # 功能总开关
   ```

---

## ⚙️ 配置指南

### 基础配置 (`配置.conf`)
```conf
// 功能总开关（true=启用，false=关闭）
timed_cleaning = true
mt_cleaning = true
log_cleaning = true

// 日志清理阈值（示例：64KB/2MB）
log_purge_size = 2M
```

### 自定义定时规则 (`定时设置.conf`)
```conf
# 时间格式说明：
# - 小时: 0-23（无需补零）
# - 分钟: 0-59（支持 0 或 00 格式）
# - 星期: 1-7（1=周一）或 *（每天）

# 时间段1
Set_Time1=23
Set_minute1=30
Set_weekday1=*

# 时间段2
Set_Time2=6
Set_minute2=0
Set_weekday2=1,3,5
```

### 路径规则示例 (`黑名单.conf`)
```conf
# 使用 glob 语法匹配路径
/data/app/*/cache
/sdcard/Android/data/*/logs
/sdcard/Download/*.tmp
```

---

## 📊 数据监控

### 统计面板
模块描述中实时显示清理数据：
```text
description=🌟已累计清理: 1587个【文件】 | 243个【文件夹】
            🌟上一次清理时间:2023-08-20 00:00:01
```

### 日志追踪
完整操作记录保存在：
```bash
/sdcard/Android/Clear/清理垃圾/Clear.log
```
日志示例：
```log
2023-08-20 00:00:01 "删除文件" "/sdcard/Android/data/com.app/cache.tmp"
2023-08-20 00:00:02 "删除目录" "/sdcard/Download/temp_folder"
```

---

## ⚠️ 重要提示

1. **配置生效**  
   修改定时设置后需执行：
   ```bash
   su -c /sdcard/Android/Clear/清理垃圾/自定义定时设置/Timing_Settings.sh
   ```

2. **优先级规则**  
   白名单路径 > 黑名单路径

3. **通配符安全**  
   避免使用过于宽泛的匹配（如 `/*`），可能导致系统文件误删

4. **卸载模块以及残留文件**  
   终端执行命令：
   ```bash
   su -c "/data/adb/modules/Clear_Rubbish/uninstall.sh"
   ```
5. **紧急停止**  
   终止所有清理进程：
   ```bash
   pkill -f "TimingClear|SmartClear|LogClear"
   
---

## 🔄 更新与支持

### 纸飞机频道
[Telegram 群组](https://t.me/FleshyGrape)

---

**License**: GPL-3.0  
**开发者**: Fleshy Grape  
**构建版本**: 1.0.12.0 (2025-02-27)
```