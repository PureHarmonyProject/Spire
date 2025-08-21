# Spire Extensions Caching 单元测试指南

## 📋 概述

本文档详细说明了 `spire_extensions_caching` 项目的单元测试组织结构、测试策略和最佳实践。项目采用分层测试架构，确保分布式缓存功能的可靠性和稳定性。

## 🏗️ 测试架构

### 包结构
```
src/unittests/
├── basic_functionality/          # 基础功能测试
├── expiration_policies/          # 过期策略测试
├── auto_cleanup/                # 自动清理测试
├── boundary_cases/              # 边界情况测试
├── configuration/               # 配置选项测试
├── performance/                 # 性能测试
├── error_handling/             # 错误处理测试
├── integration/                 # 集成测试
├── concurrency/                # 并发测试
└── stress_testing/             # 压力测试
```

### 命名规范
- **文件夹**: 使用小写字母加下划线 (snake_case)
- **测试文件**: 使用驼峰命名法 (PascalCase)
- **测试方法**: 使用中文描述性名称
- **包名**: `spire_extensions_caching.unittests.{category}`

## 📁 测试分类详解

### 1. 基础功能测试 (`basic_functionality/`)

**文件**: `BasicCacheOperations.cj`  
**包名**: `spire_extensions_caching.unittests.basic_functionality`

#### 测试范围
- ✅ 缓存基础设置和获取功能
- ✅ 获取不存在的键处理
- ✅ 缓存项删除功能
- ✅ 缓存项刷新功能

#### 测试方法
```cj
/**
 * 测试缓存的基础设置和获取功能
 * 验证：字符串和字节数组的存储和检索功能正常工作
 * 测试内容：setString/getString 和 set/get 方法的基本功能
 */
@Test
func 测试基础设置和获取()
```

### 2. 过期策略测试 (`expiration_policies/`)

**文件**: `ExpirationPolicies.cj`  
**包名**: `spire_extensions_caching.unittests.expiration_policies`

#### 测试范围
- ✅ 滑动过期时间策略
- ✅ 绝对过期时间策略
- ✅ 相对过期时间策略
- ✅ 多重过期条件组合

#### 测试场景
- **滑动过期**: 验证访问时重置计时器
- **绝对过期**: 验证固定时间点过期
- **相对过期**: 验证从设置时间开始计算
- **多重条件**: 验证任一条件满足即过期

### 3. 自动清理测试 (`auto_cleanup/`)

**文件**: `AutoCleanup.cj`  
**包名**: `spire_extensions_caching.unittests.auto_cleanup`

#### 测试范围
- ✅ 过期项自动清理机制
- ✅ 后台清理线程性能

#### 测试特点
- 验证后台清理线程的正确性
- 测试按时间顺序的清理逻辑
- 确保内存泄漏防护

### 4. 边界情况测试 (`boundary_cases/`)

**文件**: `BoundaryCases.cj`  
**包名**: `spire_extensions_caching.unittests.boundary_cases`

#### 测试范围
- ✅ 空值处理能力
- ✅ 特殊字符处理
- ✅ 频繁访问性能

#### 边界场景
- 空字符串和空字节数组
- 中文、emoji、特殊符号
- 连续100次访问同一键

### 5. 配置选项测试 (`configuration/`)

**文件**: `Configuration.cj`  
**包名**: `spire_extensions_caching.unittests.configuration`

#### 测试范围
- ✅ DistributedCacheOptions 配置
- ✅ DistributedCacheEntryOptions 配置

#### 配置验证
- 自定义过期扫描频率
- 默认配置值验证
- 各种过期策略配置

### 6. 性能测试 (`performance/`)

**文件**: `Performance.cj`  
**包名**: `spire_extensions_caching.unittests.performance`

#### 测试范围
- ✅ 内存使用监控
- ✅ 缓存项数量统计

#### 性能指标
- 缓存项添加/删除统计
- 内存使用效率
- 操作响应时间

### 7. 错误处理测试 (`error_handling/`)

**文件**: `ErrorHandling.cj`  
**包名**: `spire_extensions_caching.unittests.error_handling`

#### 测试范围
- ✅ 无效键处理
- ✅ 重复键覆盖

#### 错误场景
- 空键的处理
- 键值覆盖的正确性
- 异常情况的容错性

### 8. 集成测试 (`integration/`)

**文件**: `Integration.cj`  
**包名**: `spire_extensions_caching.unittests.integration`

#### 测试范围
- ✅ 完整缓存生命周期

#### 集成场景
- 设置 → 验证 → 刷新 → 过期 → 清理
- 端到端的功能验证
- 组件间协作测试

### 9. 并发测试 (`concurrency/`)

**文件**: `Concurrency.cj`  
**包名**: `spire_extensions_caching.unittests.concurrency`

#### 测试范围
- ✅ 并发设置和获取
- ✅ 线程安全验证

#### 并发场景
- 多线程并发设置
- 多线程并发获取
- 数据一致性验证

### 10. 压力测试 (`stress_testing/`)

**文件**: `StressTesting.cj`  
**包名**: `spire_extensions_caching.unittests.stress_testing`

#### 测试范围
- ✅ 大量数据存储性能
- ✅ 过期清理性能

#### 压力场景
- 1000个键值对存储
- 100个短期过期项批量清理
- 极限条件下的性能表现

## 🧪 测试执行

### 运行单个测试
```bash
# 运行基础功能测试
cj test src/unittests/basic_functionality/BasicCacheOperations.cj

# 运行过期策略测试
cj test src/unittests/expiration_policies/ExpirationPolicies.cj
```

### 运行所有测试
```bash
# 运行所有单元测试
cj test src/unittests/
```

### 测试覆盖率
```bash
# 生成测试覆盖率报告
cj test --coverage src/unittests/
```

## 📊 测试统计

### 测试用例分布
| 测试类别 | 测试用例数 | 覆盖率 |
|---------|-----------|--------|
| 基础功能 | 4 | 100% |
| 过期策略 | 4 | 100% |
| 自动清理 | 1 | 100% |
| 边界情况 | 3 | 100% |
| 配置选项 | 2 | 100% |
| 性能测试 | 1 | 100% |
| 错误处理 | 2 | 100% |
| 集成测试 | 1 | 100% |
| 并发测试 | 1 | 100% |
| 压力测试 | 2 | 100% |
| **总计** | **21** | **100%** |

### 功能覆盖
- ✅ IDistributedCache 接口所有方法
- ✅ MemoryDistributedCache 实现所有功能
- ✅ 所有过期策略组合
- ✅ 自动清理机制
- ✅ 并发安全保证
- ✅ 错误处理机制

## 🔧 测试最佳实践

### 1. 测试命名规范
```cj
/**
 * 测试[功能名称]
 * 验证：[具体验证点]
 * 测试内容：[详细测试内容]
 */
@Test
func 测试[功能名称]() {
    // 测试实现
}
```

### 2. 测试数据管理
- 使用独立的测试数据
- 避免测试间的数据依赖
- 清理测试产生的副作用

### 3. 异步测试处理
```cj
// 等待异步操作完成
sleep(Duration.second * 2)

// 验证异步结果
@Expect(result.isSome(), true)
```

### 4. 边界条件测试
- 空值处理
- 极限值测试
- 异常情况处理

## 🚀 持续集成

### CI/CD 配置
```yaml
# .github/workflows/test.yml
name: Unit Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Tests
        run: cj test src/unittests/
      - name: Generate Coverage
        run: cj test --coverage src/unittests/
```

### 测试质量门禁
- 测试通过率: 100%
- 代码覆盖率: > 90%
- 测试执行时间: < 60秒

## 📈 测试维护

### 添加新测试
1. 确定测试类别
2. 创建测试文件（如果不存在）
3. 添加测试方法
4. 更新文档

### 修改现有测试
1. 保持向后兼容
2. 更新相关文档
3. 验证测试覆盖率

### 测试重构
1. 提取公共测试逻辑
2. 优化测试性能
3. 简化测试代码

## 🐛 常见问题

### Q: 如何处理测试中的时间依赖？
A: 使用 `sleep()` 函数等待异步操作，并设置合理的超时时间。

### Q: 如何测试并发场景？
A: 使用 `spawn` 创建并发任务，并验证最终状态的一致性。

### Q: 如何验证缓存过期？
A: 设置短期过期时间，等待过期后验证项已被清理。

### Q: 如何处理测试数据隔离？
A: 每个测试使用独立的缓存实例，避免测试间的数据污染。

## 📚 相关文档

- [项目README](../README.md)
- [API文档](../docs/API.md)
- [性能基准](../docs/Benchmarks.md)
- [部署指南](../docs/Deployment.md)

---

**最后更新**: 2024年7月16日  
**版本**: 1.0.0  
**维护者**: Soulsoft团队 