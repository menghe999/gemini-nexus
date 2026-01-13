#!/bin/bash

# 验证构建配置脚本

set -e

echo "🔍 验证构建配置..."

# 检查必要文件
echo "📁 检查必要文件..."
files=(
    "gemini-nexus/package.json"
    "gemini-nexus/manifest.json"
    "gemini-nexus/vite.config.ts"
    ".github/workflows/build.yml"
    ".github/workflows/release.yml"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file 不存在"
        exit 1
    fi
done

# 检查 package.json 版本
echo ""
echo "📦 检查版本号..."
cd gemini-nexus
PKG_VERSION=$(node -p "require('./package.json').version")
MANIFEST_VERSION=$(node -p "require('./manifest.json').version")

echo "  package.json: $PKG_VERSION"
echo "  manifest.json: $MANIFEST_VERSION"

if [ "$PKG_VERSION" = "$MANIFEST_VERSION" ]; then
    echo "  ✅ 版本号一致"
else
    echo "  ⚠️  版本号不一致"
fi

# 检查依赖
echo ""
echo "📚 检查依赖..."
if [ -f "package-lock.json" ]; then
    echo "  ✅ package-lock.json 存在"
else
    echo "  ⚠️  package-lock.json 不存在，建议运行 npm install"
fi

# 检查构建脚本
echo ""
echo "🔨 检查构建脚本..."
if grep -q '"build"' package.json; then
    echo "  ✅ build 脚本已配置"
else
    echo "  ❌ build 脚本未配置"
    exit 1
fi

cd ..

# 检查 .gitignore
echo ""
echo "🚫 检查 .gitignore..."
if [ -f ".gitignore" ]; then
    echo "  ✅ .gitignore 存在"
    if grep -q "node_modules" .gitignore; then
        echo "  ✅ 已忽略 node_modules"
    fi
    if grep -q "dist" .gitignore; then
        echo "  ✅ 已忽略 dist"
    fi
else
    echo "  ⚠️  .gitignore 不存在"
fi

echo ""
echo "✅ 验证完成！配置正确。"
echo ""
echo "📝 下一步："
echo "  1. 提交代码: git add . && git commit -m 'chore: 添加 CI/CD 配置'"
echo "  2. 推送代码: git push origin main"
echo "  3. 查看 Actions: https://github.com/YOUR_USERNAME/gemini-nexus/actions"
