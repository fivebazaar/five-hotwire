# Five Hotwire Script

Modern and optimized vehicle hotwiring script. Developed with ox_lib cache system and multi-UI support.

## 🚀 Features

- **22 Different Vehicle Classes** - Custom difficulty and duration settings for each vehicle type
- **Multi UI System** - ox_lib and ps-ui support
- **Alarm System** - Vehicle class-based alarm trigger chance
- **9 Dispatch Systems** - Integration with different dispatch systems
- **Multi-Language Support** - Turkish and English language support
- **ox_lib Cache** - Cache system for performance optimization
- **Animation System** - Realistic hotwiring animations

## 📋 Requirements

- **qb-core** - QBCore Framework
- **qb-vehiclekeys** - Vehicle key system
- **ox_lib** - Modern UI and cache system
- **ox_inventory** - Inventory system

### Optional
- **ps-ui** - Alternative UI system

## 🔧 Installation

1. Copy the script to the `resources` folder
2. Add `ensure five-hotwire` to your `server.cfg`
3. Add locale setting to your `server.cfg`: `setr ox:locale en` (en or tr)
4. Install required dependencies
5. Restart the server

## ⚙️ Configuration

### Basic Settings
```lua
Config.Debug = true -- Debug mode
Config.UISystem = 'ox_lib' -- UI system (ox_lib or ps-ui)
Config.DispatchTriggerOn = 'success' -- Dispatch trigger (success, fail, both)
Config.Updater = true -- Version checker
```

### Vehicle Classes
Customizable for each vehicle class:
- **Duration** - Process time (ms)
- **Difficulty** - Difficulty level array
- **AlarmChance** - Alarm trigger chance (0.0-1.0)

### Dispatch Systems
Supported dispatch systems:
- ps-dispatch
- bub-mdt
- cd_dispatch
- core_dispatch
- qs-dispatch
- origen_police
- tk_dispatch
- rcore_dispatch
- lj_dispatch

## 🎮 Usage

1. Get into a vehicle without keys
2. Press **[E]** to start hotwiring
3. Successfully complete the skill check
4. Vehicle becomes temporarily operational

## 🌍 Language Support

The script supports the following languages:
- **Turkish (tr)** - Default
- **English (en)**

To add a new language, add a new JSON file to the `locales/` folder.

**Important:** Add `setr ox:locale en` (or `tr`) to your `server.cfg` for proper locale handling.

## 📊 Performance

- Optimized using ox_lib cache system
- Event-based system instead of thread loops
- Minimal resource usage
- Smooth animations

## 🎥 Preview & Support

### 📹 Demo Video
[![Five Hotwire Demo](https://img.shields.io/badge/YouTube-Demo%20Video-red?style=for-the-badge&logo=youtube)](https://youtu.be/eJ4FqzroEus)

### 💬 Community & Support
[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da?style=for-the-badge&logo=discord)](https://discord.gg/Dc6EVAUxu6)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Issues-green?style=for-the-badge&logo=github)](https://github.com/fivebazaar/five-hotwire/issues)

## 🐛 Troubleshooting

**TextUI not showing:** Make sure ox_lib is properly loaded and cache events are working  
**Skill check not working:** Check UI system configuration and ps-ui export availability  
**Dispatch not working:** Verify Config.Dispatch setting and dispatch system installation  
**Language not changing:** Add `setr ox:locale en` to server.cfg and restart

## 📄 License

This project is licensed under the MIT License.

---

**Note:** This script is developed for QBCore framework and may not be compatible with other frameworks.
