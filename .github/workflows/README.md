# GitHub Actions Workflows

本项目包含三个自动化工作流：

## 📦 Build Workflow (`build.yml`)

**触发条件：**
- 推送到 `main`、`master` 或 `dev` 分支
- 创建 Pull Request
- 手动触发

**功能：**
- 自动安装依赖
- 构建扩展
- 打包成 ZIP 文件
- 上传构建产物（保留 30 天）

**使用方法：**
```bash
# 推送代码即可自动触发
git push origin main

# 或手动触发（在 GitHub Actions 页面）
```

---

## 🚀 Release Workflow (`release.yml`)

**触发条件：**
- 推送 tag（如 `v4.2.3`）
- 手动触发

**功能：**
- 构建扩展
- 创建 GitHub Release
- 自动上传 ZIP 包
- 生成安装说明

**使用方法：**

### 方式一：通过 Git Tag
```bash
# 更新版本号
cd gemini-nexus
npm version patch  # 或 minor, major

# 推送 tag
git push origin v4.2.4
```

### 方式二：手动触发
1. 访问 GitHub Actions 页面
2. 选择 "Release Extension" workflow
3. 点击 "Run workflow"
4. 输入版本号（如 `v4.2.4`）

---

## ✅ Lint Workflow (`lint.yml`)

**触发条件：**
- 推送到主分支
- 创建 Pull Request

**功能：**
- TypeScript 类型检查
- manifest.json 格式验证

---

## 📝 注意事项

1. **首次使用前**：确保 `gemini-nexus/package-lock.json` 已提交
2. **Release 权限**：需要仓库的 `contents: write` 权限（默认已配置）
3. **构建产物**：可在 Actions 页面下载构建的 ZIP 文件
4. **版本号**：确保 `package.json` 和 `manifest.json` 中的版本号一致

---

## 🔧 自定义配置

### 修改构建分支
编辑 `build.yml` 的 `on.push.branches`：
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]
```

### 修改打包内容
编辑 `build.yml` 的 `zip` 命令，添加或排除文件：
```bash
zip -r ../artifacts/gemini-nexus.zip \
  dist/ \
  background/ \
  your-new-folder/ \
  -x "*.map" "*.log"
```

### 修改产物保留时间
编辑 `build.yml` 的 `retention-days`：
```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v4
  with:
    retention-days: 90  # 改为 90 天
```
