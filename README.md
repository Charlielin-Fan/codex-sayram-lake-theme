# 赛里木湖 · 天山清晨

一套面向 Windows Codex Desktop 的新疆风光主题。它不是“只换一张背景图”，而是把赛里木湖与天山清晨的湖蓝、深 teal、雾白和暖金，统一应用到工作区、侧栏、聊天内容、输入框、活动记录、项目/来源面板、菜单、代码块、链接和状态提示中。

![赛里木湖 · 天山清晨](assets/sayram-lake-tianshan.png)

当前发布版本：`1.1.6`

## 亮点

- **完整界面语言**：背景、导航、聊天卡片、输入区、活动行、项目面板、插件/技能选择器和设置区域使用同一套视觉规则。
- **新疆风光但不牺牲阅读**：保留原图的湖面、草地和天山，不在整张背景上覆盖厚重雾层；文字区域使用局部静态表面和高对比度文字。
- **重要信息有层次**：文件与可点击链接使用湖蓝下划线，代码/提交哈希使用蓝色标记，新增/删除数字保持绿色/红色区分。
- **旧聊天也统一**：主题选择器覆盖已有聊天、正在生成的 Thinking/Working 状态、日期、活动记录和后续新消息，避免只有新聊天正常显示。
- **轻量运行时注入**：主题 CSS 不使用 `backdrop-filter`、CSS `filter` 或动画，不修改 Codex 安装目录和 `app.asar`。
- **可恢复**：主题通过本地回环 CDP 注入；仓库附带一键启动、应用和恢复脚本。

## 快速开始（Windows）

### 1. 准备环境

需要：

- Windows 10/11；
- Codex Desktop；
- Node.js `22.4+`，安装后在 PowerShell 中确认：

```powershell
node --version
npx --version
```

第一次运行启动脚本时，`npx` 会下载固定版本的公开 CodeDrobe Core（`@codedrobe/core@0.6.0`），之后由本机缓存复用。

本仓库不复制运行时源码；主题运行时由 [CodeDrobe Core](https://github.com/CodeDrobe/core) 提供。

### 2. 下载主题

可以在 GitHub 页面选择 **Code → Download ZIP**，解压后进入主题文件夹；也可以使用：

```powershell
git clone https://github.com/Charlielin-Fan/codex-sayram-lake-theme.git
cd codex-sayram-lake-theme
```

### 3. 启动并应用主题

如果 Codex 已经通过普通快捷方式打开，请先关闭它。然后双击仓库根目录的：

```text
Start-Codex-Sayram.cmd
```

这个启动器会：

1. 通过 `127.0.0.1:9335` 启动带主题端点的 Codex；
2. 应用 `.codedrobe-theme` 主题包；
3. 在应用前后检查 `~/.codex/config.toml` 的 SHA-256；
4. 如果配置发生意外变化，立即停止并报错。

日常使用时，想要这套主题，就从 `Start-Codex-Sayram.cmd` 打开 Codex。它不会传递 `--restart-existing`，也不会强制接管已经用普通方式打开的 Codex。

### 4. 只给当前运行中的 Codex 应用主题

如果 Codex 已经是通过带 CDP 的启动方式运行，可以双击：

```text
Apply-Codex-Sayram.cmd
```

或者在 PowerShell 中运行：

```powershell
.\scripts\apply-codex-sayram.ps1
```

### 5. 恢复原生外观

双击：

```text
Restore-Codex-Sayram.cmd
```

或运行：

```powershell
.\scripts\restore-codex-sayram.ps1
```

恢复脚本只移除本次运行时注入的主题样式。

## 手动命令

不使用脚本时，可以使用固定版本的 CodeDrobe Core：

```powershell
npx --yes --package=@codedrobe/core@0.6.0 codedrobe launch --app codex --port 9335 --json
npx --yes --package=@codedrobe/core@0.6.0 codedrobe apply --app codex --theme .\dist\codex-sayram-lake-theme.codedrobe-theme --port 9335 --no-launch --json
```

恢复：

```powershell
npx --yes --package=@codedrobe/core@0.6.0 codedrobe restore --app codex --port 9335 --json
```

## 文件结构

```text
.
├─ assets/
│  ├─ sayram-lake-tianshan.png          主背景图
│  ├─ sayram-lake-tianshan-icon.png     图标 PNG 预览
│  └─ sayram-lake-tianshan.ico          Windows 快捷方式图标
├─ dist/
│  └─ codex-sayram-lake-theme.codedrobe-theme  可移植主题包
├─ scripts/
│  ├─ start-codex-sayram.ps1            启动并应用
│  ├─ apply-codex-sayram.ps1            仅应用
│  └─ restore-codex-sayram.ps1          恢复原生外观
├─ Start-Codex-Sayram.cmd
├─ Apply-Codex-Sayram.cmd
├─ Restore-Codex-Sayram.cmd
├─ theme.json
└─ theme.css
```

## 安全边界与兼容性

- 主题清单没有声明 `baseTheme`，脚本不会主动请求写入 Codex 原生外观设置。
- 脚本只使用回环地址 `127.0.0.1`，不会修改 Codex 安装目录、`app.asar`、账号、聊天、任务或工作区文件。
- 启动器不使用 `--restart-existing`。如果 Codex 已经从原生快捷方式打开，请关闭后再从主题启动器打开。
- Codex Desktop 的内部 DOM 结构可能随版本变化；如果未来版本调整界面结构，主题可能需要更新选择器。
- 主题的可读性和性能会受系统缩放、窗口尺寸、Codex 版本和本机性能影响。

## 反馈与贡献

如果某个界面区域出现文字对比度、间距或定位问题，请附上：

1. Codex Desktop 版本；
2. Windows 缩放比例和窗口尺寸；
3. 发生问题的界面截图；
4. 是启动、应用、恢复还是打开侧边文件后出现。

请不要在 issue 中上传聊天内容、项目路径、令牌或私密文件。

## 许可证

主题 CSS、脚本、清单和文档按 [MIT License](LICENSE) 发布。配套图片和图标属于本主题发布内容，请在再分发时保留 `assets/` 和本 README。

---

# Sayram Lake · Tianshan Morning

A Xinjiang-inspired visual theme for Codex Desktop on Windows. It is more than a background swap: the Sayram Lake and Tianshan palette is carried through the workspace, sidebar, transcript, composer, activity rows, project/source panels, menus, code blocks, links, and status surfaces.

![Sayram Lake · Tianshan Morning](assets/sayram-lake-tianshan.png)

Current release: `1.1.6`

## Highlights

- **A complete visual system**: one coherent language for the landscape, navigation, chat cards, composer, activity rows, project panels, plugin/skill pickers, and settings surfaces.
- **Landscape without sacrificing readability**: the original lake, meadow, and mountain view stays visible; readability comes from local static surfaces and high-contrast text instead of a heavy full-screen haze.
- **Clear information hierarchy**: files and clickable links use lake-blue underlines, code and commit hashes use blue markers, and additions/deletions keep green/red semantics.
- **Consistent old and new chats**: existing transcript turns, Thinking/Working states, dates, activity rows, and newly streamed messages share the same treatment.
- **Lightweight renderer-only styling**: the stylesheet avoids `backdrop-filter`, CSS `filter`, and animation, and does not patch the Codex installation or `app.asar`.
- **Easy to reverse**: the included scripts apply the theme over loopback CDP and provide a matching restore command.

## Quick start (Windows)

### 1. Prerequisites

You need:

- Windows 10/11;
- Codex Desktop;
- Node.js `22.4+`.

Verify the installation in PowerShell:

```powershell
node --version
npx --version
```

On the first run, `npx` downloads the pinned public CodeDrobe Core package (`@codedrobe/core@0.6.0`); later runs reuse the local npm cache.

The runtime is intentionally not vendored in this repository; it is provided by [CodeDrobe Core](https://github.com/CodeDrobe/core).

### 2. Download the theme

Use **Code → Download ZIP** on GitHub, extract the folder, and open it. Or clone it with:

```powershell
git clone https://github.com/Charlielin-Fan/codex-sayram-lake-theme.git
cd codex-sayram-lake-theme
```

### 3. Launch Codex with the theme

If Codex is already open from the normal shortcut, close it first. Then double-click:

```text
Start-Codex-Sayram.cmd
```

The launcher will:

1. start Codex with a loopback endpoint at `127.0.0.1:9335`;
2. apply the portable `.codedrobe-theme` package;
3. compare the SHA-256 of `~/.codex/config.toml` before and after applying;
4. stop with an error if the configuration changes unexpectedly.

For daily use, open Codex through `Start-Codex-Sayram.cmd`. The launcher never passes `--restart-existing` and will not forcibly take over a normally opened Codex process.

### 4. Apply to an already running CDP-enabled Codex

Double-click:

```text
Apply-Codex-Sayram.cmd
```

Or run:

```powershell
.\scripts\apply-codex-sayram.ps1
```

### 5. Restore the native appearance

Double-click:

```text
Restore-Codex-Sayram.cmd
```

Or run:

```powershell
.\scripts\restore-codex-sayram.ps1
```

The restore script removes only the renderer theme injected by this project.

## Manual commands

```powershell
npx --yes --package=@codedrobe/core@0.6.0 codedrobe launch --app codex --port 9335 --json
npx --yes --package=@codedrobe/core@0.6.0 codedrobe apply --app codex --theme .\dist\codex-sayram-lake-theme.codedrobe-theme --port 9335 --no-launch --json
```

Restore:

```powershell
npx --yes --package=@codedrobe/core@0.6.0 codedrobe restore --app codex --port 9335 --json
```

## Compatibility and safety

- The theme manifest does not declare `baseTheme`, so the scripts do not request native Codex appearance settings.
- The scripts use loopback `127.0.0.1` and do not modify the Codex installation directory, `app.asar`, account, chats, tasks, or workspace files.
- The launcher does not use `--restart-existing`. Close a normally opened Codex before using the theme launcher.
- Codex Desktop can change its internal DOM structure over time. A future UI update may require selector maintenance.
- Readability and performance can vary with Windows scaling, window size, Codex version, and the local machine.

## Feedback and contributions

For a visual issue, include the Codex Desktop version, Windows scaling/window size, a screenshot, and the action that triggered it. Do not upload chat content, project paths, tokens, or private files to an issue.

## License

Theme CSS, scripts, manifest, and documentation are released under the [MIT License](LICENSE). The bundled landscape and icon assets are part of this theme release; keep the `assets/` directory and this README when redistributing.
