package spire_web_routing.matching

import std.reflect.*
import std.collection.*

/*
路径跳转表
*/
abstract class JumpTable {
    public func getDestination(path: String): Int64
   
    protected open func debuggerToString(): String {
        ClassTypeInfo.of(this).qualifiedName
    }
}

/*
默认跳转表
 */
class DefaultJumpTable <: JumpTable {
    private let _exitDestination: Int64
    private let _defaultDestination: Int64

    init(defaultDestination: Int64, exitDestination: Int64) {
        _exitDestination = exitDestination
        _defaultDestination = defaultDestination
    }

    public func getDestination(path: String): Int64 {
        if (path.size == 0) {
            return _exitDestination
        } else {
            _defaultDestination
        }
    }

    protected func debuggerToString(): String {
        return '{"default": ${_defaultDestination}, "exit": ${_exitDestination}}'
    }
}

/*
字典跳转表
 */
class DictionaryJumpTable <: JumpTable {
    private let _exitDestination: Int64
    private let _defaultDestination: Int64
    private let _entries: HashMap<String, Int64>

    init(defaultDestination: Int64, exitDestination: Int64,  entries: Collection<(String, Int64)>) {
        _exitDestination = exitDestination
        _defaultDestination = defaultDestination
        _entries = HashMap<String, Int64>(entries)
    }

    public func getDestination(path: String): Int64 {
        if (path.size == 0) {
            return _exitDestination
        }

        if (let Some(destination) <- _entries.get(path)) {
            return destination
        }

        return _defaultDestination
    }
    
    protected func debuggerToString(): String {
        let entries = ArrayList<String>()
        for ((path, index) in _entries) {
            entries.add('{"${path}": ${index}}')
        }
        let entriesJson = String.join(entries |> collectArray, delimiter: ', ')
        return '{"default": ${_defaultDestination}, "exit": ${_exitDestination}, "entries": ${entriesJson}}'
    }
}

/*
单项跳转表
*/
class SingleEntryJumpTable <: JumpTable {
    private let _exitDestination: Int64
    private let _defaultDestination: Int64
    private let _entry: (String, Int64)

    init(defaultDestination: Int64, exitDestination: Int64,  entry: (String, Int64)) {
        _exitDestination = exitDestination
        _defaultDestination = defaultDestination
        _entry = entry
    }

    public func getDestination(path: String): Int64 {
        if (path.size == 0) {
            return _exitDestination
        }

        if (_entry[0] == path) {
            return _entry[1] 
        }

        return _defaultDestination
    }
    
    protected func debuggerToString(): String {
        return '{"default": ${_defaultDestination}, "exit": ${_exitDestination}, "entries": "${_entry[0]}": ${_entry[1]}}'
    }
}