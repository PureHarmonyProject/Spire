package spire_web_routing.matching

/*
跳转表构建
 */
class JumpTableBuilder {
    public static func build(defaultDestination: Int64, exitDestination: Int64, entries: ?Array<(String, Int64)>): JumpTable {
        if (let Some(entries) <- entries) {
            if (entries.size == 1) {
                return SingleEntryJumpTable(defaultDestination, exitDestination, entries[0])
            }
            return DictionaryJumpTable(defaultDestination, exitDestination,  entries)
        }

        return DefaultJumpTable(defaultDestination, exitDestination)
    }
}