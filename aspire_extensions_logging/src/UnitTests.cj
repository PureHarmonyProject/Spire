package aspire_extensions_logging

import std.unittest.*
import std.unittest.testmacro.*

@Test
func name() {
    let logging = LoggingBuilder()
    logging.addConsole()
    let factory = logging.build()
    let logger = factory.createLogger("test1")
    logger.info("你好！")
}