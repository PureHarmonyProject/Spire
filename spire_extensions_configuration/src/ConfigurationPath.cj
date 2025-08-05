package spire_extensions_configuration

public class ConfigurationPath {
    private init() {
    }

    public static let delimiter = ":"

    public static func combine(segments: Array<String>) {
        String.join(segments, delimiter: delimiter)
    }

    public static func getSectionKey(path: String) {
        if (path.isEmpty()) {
            return path
        }

        if (let Some(lastDelimiterIndex) <- path.lastIndexOf(delimiter)) {
            return path[lastDelimiterIndex + 1..]
        } else {
            return path
        }
    }

    public static func getParentPath(path: String) {
        if (let Some(lastDelimiterIndex) <- path.lastIndexOf(delimiter)) {
            return path[0..lastDelimiterIndex]
        } else {
            return path
        }
    }
}
