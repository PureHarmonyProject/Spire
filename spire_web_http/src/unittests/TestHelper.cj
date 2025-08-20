package spire_web_http.unittests

import std.collection.*

/**
 * 测试辅助类
 * 提供测试过程中常用的辅助方法和测试数据
 */
class TestHelper {
    
    /**
     * 创建HTTP方法测试数据
     * @return 包含各种HTTP方法的数组
     */
    public static func createHttpMethodsData(): Array<String> {
        return [
            "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS", "TRACE", "CONNECT",
            "get", "post", "put", "delete", "patch", "head", "options", "trace", "connect",
            "Get", "Post", "Put", "Delete", "Patch", "Head", "Options", "Trace", "Connect"
        ]
    }
    
    /**
     * 创建路径字符串测试数据
     * @return 包含各种路径的数组
     */
    public static func createPathStringData(): Array<String> {
        return [
            "/api/users",
            "/api/users/123",
            "/api/products",
            "/home",
            "/login",
            "/register",
            "",
            "/",
            "/api/v1/endpoint",
            "/static/css/style.css",
            "/static/js/app.js"
        ]
    }
    
    /**
     * 创建查询字符串测试数据
     * @return 包含各种查询字符串的数组
     */
    public static func createQueryStringData(): Array<String> {
        return [
            "name=test&age=25",
            "id=123&action=delete",
            "search=keyword&page=1&limit=10",
            "filter=active&sort=name&order=asc",
            "",
            "?name=test",
            "single=value",
            "empty=&blank=",
            "encoded=value%20with%20spaces"
        ]
    }
    
    /**
     * 创建路由值测试数据
     * @return 包含路由值的HashMap
     */
    public static func createRouteValuesData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["id"] = "123"
        data["name"] = "testuser"
        data["action"] = "update"
        data["category"] = "products"
        data["page"] = "1"
        data["limit"] = "10"
        return data
    }
    
    /**
     * 创建HTTP状态码测试数据
     * @return 包含状态码和对应描述的HashMap
     */
    public static func createStatusCodesData(): HashMap<UInt16, String> {
        let data = HashMap<UInt16, String>()
        data[200] = "OK"
        data[201] = "Created"
        data[204] = "No Content"
        data[400] = "Bad Request"
        data[401] = "Unauthorized"
        data[403] = "Forbidden"
        data[404] = "Not Found"
        data[500] = "Internal Server Error"
        data[503] = "Service Unavailable"
        return data
    }
    
    /**
     * 创建特殊字符测试数据
     * @return 包含特殊字符的HashMap
     */
    public static func createSpecialCharData(): HashMap<String, String> {
        let data = HashMap<String, String>()
        data["key with spaces"] = "space_value"
        data["key-with-dashes"] = "dash_value"
        data["key_with_underscores"] = "underscore_value"
        data["key.with.dots"] = "dot_value"
        data["key@with@symbols"] = "symbol_value"
        data["key:with:colons"] = "colon_value"
        data["key/with/slashes"] = "slash_value"
        return data
    }
    
    /**
     * 生成随机字符串
     * @param length 字符串长度
     * @return 随机字符串
     */
    public static func generateRandomString(length: Int64): String {
        let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let charArray = ArrayList<String>()

        var count = 0
        
        for (i in 0..length) {
            let randomIndex = (i * 31) % chars.size
            charArray.add(chars[randomIndex])
            count++
        }
        
        let result = String.join(charArray |> collectArray, delimiter: "")
        return result
    }
}