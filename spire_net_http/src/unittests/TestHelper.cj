package spire_net_http.unittests

import std.time.*
import stdx.encoding.url.*
import spire_net_http.*

public class TestHelper {
	// 统一的测试服务器配置
	public static let TEST_SERVER_HOST = "127.0.0.1"
	public static let TEST_SERVER_PORT = 5069
	public static let TEST_SERVER_BASE_URL = "http://${TEST_SERVER_HOST}:${TEST_SERVER_PORT}"
	
	// 创建预配置的HttpClient
	public static func createClient(): HttpClient {
		return HttpClient({ opts =>
			opts.address = Some(URL.parse(TEST_SERVER_BASE_URL))
			opts.timeout = Duration.second * 5
		})
	}
	
	// 创建带自定义超时的HttpClient
	public static func createClientWithTimeout(timeout: Duration): HttpClient {
		return HttpClient({ opts =>
			opts.address = Some(URL.parse(TEST_SERVER_BASE_URL))
			opts.timeout = timeout
		})
	}
	
	// 创建带自定义头部的HttpClient
	public static func createClientWithHeaders(headers: Array<(String, String)>): HttpClient {
		return HttpClient({ opts =>
			opts.address = Some(URL.parse(TEST_SERVER_BASE_URL))
			opts.timeout = Duration.second * 5
			for ((name, value) in headers) {
				opts.headers.add(name, value)
			}
		})
	}
}

/**
 * 测试用的HttpClientFactory实现
 */
public class IntegrationTestFactory <: IHttpClientFactory {
	public func create(name: String): HttpClient {
		match (name) {
			case "json-api" =>
				HttpClient({ opts =>
					opts.address = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
					opts.headers.add("Accept", "application/json")
					opts.headers.add("Content-Type", "application/json")
				})
			case "upload-service" =>
				HttpClient({ opts =>
					opts.address = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
					opts.timeout = Duration.minute * 10
					opts.headers.add("Accept", "application/json")
				})
			case _ =>
				HttpClient()
		}
	}
}