package spire_net_http.unittests

import std.time.*
import stdx.encoding.url.*
import spire_net_http.*

public interface IHttpClientFactory {
	func create(name: String): HttpClient
}

class TestHelper {
	// 统一的测试服务器配置
	public static let TEST_SERVER_HOST = "127.0.0.1"
	public static let TEST_SERVER_PORT = 5069
	public static let TEST_SERVER_BASE_URL = "http://${TEST_SERVER_HOST}:${TEST_SERVER_PORT}"
	
	// 创建预配置的HttpClient
	public static func createClient(): HttpClient {
		let client = HttpClient()
		client.baseAddress = Some(URL.parse(TEST_SERVER_BASE_URL))
		return client
	}
	
	// 创建带自定义超时的HttpClient
	public static func createClientWithTimeout(timeout: Duration): HttpClient {
		let handler = HttpClientHandler()
		handler.timeout = timeout
		let client = HttpClient(handler)
		client.baseAddress = Some(URL.parse(TEST_SERVER_BASE_URL))
		return client
	}
	
	// 创建带自定义头部的HttpClient
	public static func createClientWithHeaders(headers: Array<(String, String)>): HttpClient {
		let client = createClient()
		for ((name, value) in headers) {
			client.defaultRequestHeaders.add(name, value)
		}
		return client
	}
}

/**
 * 测试用的HttpClientFactory实现
 */
class IntegrationTestFactory <: IHttpClientFactory {
	public func create(name: String): HttpClient {
		match (name) {
			case "json-api" =>
				{ =>
					let client = HttpClient()
					client.baseAddress = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
					client.defaultRequestHeaders.add("Accept", "application/json")
					client.defaultRequestHeaders.add("Content-Type", "application/json")
					client
				}()
			case "upload-service" =>
				{ =>
					let handler = HttpClientHandler()
					handler.timeout = Duration.minute * 10
					let client = HttpClient(handler)
					client.baseAddress = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
					client.defaultRequestHeaders.add("Accept", "application/json")
					client
				}()
			case _ =>
				HttpClient()
		}
	}
}