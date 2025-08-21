# 测试执行指南

## 🚀 快速开始

### 运行所有测试
```bash
cj test src/unittests/
```

### 运行特定类别测试
```bash
# 基础功能测试
cj test src/unittests/basic_functionality/

# 过期策略测试
cj test src/unittests/expiration_policies/

# 性能测试
cj test src/unittests/performance/
```

### 运行单个测试文件
```bash
cj test src/unittests/basic_functionality/BasicCacheOperations.cj
```

## 📊 测试结果解读

### 测试通过标准
- ✅ 所有测试用例通过
- ✅ 无编译错误
- ✅ 无运行时异常

### 性能指标
- **测试执行时间**: < 60秒
- **内存使用**: 合理范围内
- **并发性能**: 无数据竞争

## 🔍 测试调试

### 查看详细输出
```bash
cj test --verbose src/unittests/
```

### 调试特定测试
```bash
# 在测试代码中添加调试输出
println("调试信息: " + result)
```

### 测试覆盖率报告
```bash
cj test --coverage src/unittests/
```

## 📋 测试检查清单

### 基础功能测试
- [ ] 字符串设置和获取
- [ ] 字节数组设置和获取
- [ ] 获取不存在的键
- [ ] 删除功能
- [ ] 刷新功能

### 过期策略测试
- [ ] 滑动过期时间
- [ ] 绝对过期时间
- [ ] 相对过期时间
- [ ] 多重过期条件

### 自动清理测试
- [ ] 过期项自动清理
- [ ] 后台清理线程

### 边界情况测试
- [ ] 空值处理
- [ ] 特殊字符处理
- [ ] 频繁访问

### 配置选项测试
- [ ] DistributedCacheOptions
- [ ] DistributedCacheEntryOptions

### 性能测试
- [ ] 内存使用监控
- [ ] 缓存项统计

### 错误处理测试
- [ ] 无效键处理
- [ ] 重复键覆盖

### 集成测试
- [ ] 完整生命周期

### 并发测试
- [ ] 并发设置获取
- [ ] 线程安全

### 压力测试
- [ ] 大量数据存储
- [ ] 过期清理性能

## 🐛 常见问题解决

### 测试超时
```bash
# 增加超时时间
cj test --timeout 120 src/unittests/
```

### 内存不足
```bash
# 调整内存设置
cj test --memory 2G src/unittests/
```

### 并发测试失败
- 检查线程安全实现
- 验证数据一致性
- 增加等待时间

### 过期测试不稳定
- 增加等待时间
- 检查系统时钟
- 验证清理机制

## 📈 持续监控

### 测试趋势
- 测试通过率保持100%
- 执行时间稳定
- 覆盖率不下降

### 性能基准
- 基础操作 < 1ms
- 并发操作 < 10ms
- 大量数据 < 100ms

## 🔧 维护建议

### 定期检查
- 每周运行完整测试套件
- 监控测试执行时间
- 检查覆盖率变化

### 更新测试
- 新功能添加对应测试
- 修复bug时更新测试
- 重构时保持测试覆盖

---

**维护者**: Soulsoft团队  
**最后更新**: 2024年7月16日 