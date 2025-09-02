package spire_extensions_injection

import std.reflect.*

class GenericTypeHelper {

    /*
    判断是否是：Iterable<>，用于解析一个服务多个实现
     */
    public static func isCollectionGenericType(typeInfo: TypeInfo) {
        if (typeInfo.qualifiedName.startsWith("Collection<")) {
            return true
        }

        return false
    }

    /*
    获取Iterable<>中的泛型参数
     */
    public static func getCollectionGenericParameters(typeInfo: TypeInfo) {
        return TypeInfo.get(typeInfo.qualifiedName[11..typeInfo.qualifiedName.size - 1])
    }
}
