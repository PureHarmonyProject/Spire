package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * PathString构造函数测试
 * 测试PathString的构造函数和基本属性
 */
@Test
func PathString构造函数测试() {
    // 测试非空路径字符串
    let path1 = PathString("/api/users")
    @Expect(path1.value, "/api/users")
    @Expect(path1.hasValue, true)
    
    // 测试空路径字符串
    let path2 = PathString("")
    @Expect(path2.value, "")
    @Expect(path2.hasValue, false)
    
    // 测试根路径
    let path3 = PathString("/")
    @Expect(path3.value, "/")
    @Expect(path3.hasValue, true)
    
    // 测试复杂路径
    let path4 = PathString("/api/v1/users/123/posts")
    @Expect(path4.value, "/api/v1/users/123/posts")
    @Expect(path4.hasValue, true)
}

/**
 * PathString相等性测试
 * 测试PathString的相等性比较
 */
@Test
func PathString相等性测试() {
    let path1 = PathString("/api/users")
    let path2 = PathString("/api/users")
    let path3 = PathString("/api/posts")
    let path4 = PathString("")
    
    // 测试相等性
    @Expect(path1 == path2, true)
    @Expect(path1 == path3, false)
    @Expect(path1 == path4, false)
    
    // 测试与字符串的相等性
    @Expect(path1 == "/api/users", true)
    @Expect(path1 == "/api/posts", false)
    @Expect(path1 == "", false)
    
    // 测试空路径的相等性
    @Expect(path4 == "", true)
    @Expect(path4 == "/api/users", false)
}

/**
 * PathString hasValue属性测试
 * 测试hasValue属性的各种情况
 */
@Test
func PathStringHasValue属性测试() {
    // 测试有值的情况
    @Expect(PathString("/").hasValue, true)
    @Expect(PathString("/api").hasValue, true)
    @Expect(PathString("/api/users").hasValue, true)
    @Expect(PathString("users").hasValue, true)
    @Expect(PathString("non-empty").hasValue, true)
    
    // 测试无值的情况
    @Expect(PathString("").hasValue, false)
    
    // 测试只有空格的情况
    @Expect(PathString("   ").hasValue, true)
    @Expect(PathString("  ").hasValue, true)
    @Expect(PathString(" ").hasValue, true)
}

/**
 * PathString toString方法测试
 * 测试toString方法的输出
 */
@Test
func PathStringToString方法测试() {
    let path1 = PathString("/api/users")
    let path2 = PathString("")
    let path3 = PathString("/")
    
    @Expect(path1.toString(), "/api/users")
    @Expect(path2.toString(), "")
    @Expect(path3.toString(), "/")
}

/**
 * PathString特殊字符测试
 * 测试包含特殊字符的路径字符串
 */
@Test
func PathString特殊字符测试() {
    let specialPaths = [
        "/api/users/123",
        "/static/css/style.css",
        "/static/js/app.js",
        "/images/photo.jpg",
        "/download/file.pdf",
        "/search?q=test",
        "/api/v1/endpoint",
        "/admin/dashboard",
        "/user/profile/edit"
    ]
    
    for (pathStr in specialPaths) {
        let path = PathString(pathStr)
        @Expect(path.value, pathStr)
        @Expect(path.hasValue, true)
        @Expect(path.toString(), pathStr)
    }
}

/**
 * PathString Unicode字符测试
 * 测试包含Unicode字符的路径字符串
 */
@Test
func PathStringUnicode字符测试() {
    let unicodePaths = [
        "/api/用户/123",
        "/中文路径",
        "/api/日本語/ユーザー",
        "/한글/경로",
        "/русский/путь",
        "/العربية/مسار",
        "/user/éèêë",
        "/api/üöä"
    ]
    
    for (pathStr in unicodePaths) {
        let path = PathString(pathStr)
        @Expect(path.value, pathStr)
        @Expect(path.hasValue, true)
        @Expect(path.toString(), pathStr)
    }
}


/**
 * PathString测试数据验证测试
 * 使用TestHelper中的测试数据进行验证
 */
@Test
func PathString测试数据验证测试() {
    let testData = TestHelper.createPathStringData()
    
    for (pathStr in testData) {
        let path = PathString(pathStr)
        
        if (pathStr.isEmpty()) {
            @Expect(path.hasValue, false)
        } else {
            @Expect(path.hasValue, true)
        }
        
        @Expect(path.value, pathStr)
        @Expect(path.toString(), pathStr)
        @Expect(path == pathStr, true)
    }
}

/**
 * PathString路径标准化测试
 * 测试路径字符串的标准化处理
 */
@Test
func PathString路径标准化测试() {
    // 注意：PathString本身不进行路径标准化，只是存储原始值
    let paths = [
        "/api//users",
        "/api/users/",
        "/./api/users",
        "/api/../users",
        "api/users",
        "/api/users/./posts"
    ]
    
    for (pathStr in paths) {
        let path = PathString(pathStr)
        @Expect(path.value, pathStr)  // 应该保持原始值
        @Expect(path.hasValue, true)
    }
}


/**
 * PathString内存测试
 * 测试PathString的内存使用情况
 */
@Test
func PathString内存测试() {
    // 创建多个PathString实例
    let paths = ArrayList<PathString>()
    let testStrings = TestHelper.createPathStringData()
    
    for (str in testStrings) {
        paths.add(PathString(str))
    }
    
    // 验证所有路径都正确创建
    @Expect(paths.size, testStrings.size)
    
    // 验证每个路径的值
    for (i in 0..paths.size) {
        @Expect(paths[i].value, testStrings[i])
        @Expect(paths[i].toString(), testStrings[i])
    }
}

/**
 * PathString链式比较测试
 * 测试多个PathString之间的链式比较
 */
@Test
func PathString链式比较测试() {
    let path1 = PathString("/api/users")
    let path2 = PathString("/api/users")
    let path3 = PathString("/api/posts")
    let path4 = PathString("/admin/users")
    
    // 测试链式相等性
    @Expect(path1 == path2, true)
    @Expect(path1 == path3, false)
    @Expect(path1 == path4, false)
    @Expect(path3 == path4, false)
    
    // 测试与字符串的链式比较
    @Expect(path1 == "/api/users", true)
    @Expect(path3 == "/api/posts", true)
    @Expect(path4 == "/admin/users", true)
    @Expect(path1 == "/api/posts", false)
}