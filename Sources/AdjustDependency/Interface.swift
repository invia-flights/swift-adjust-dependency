import Dependencies
import Foundation

public struct AppSecret {
	let secretID: UInt
	let info1: UInt
	let info2: UInt
	let info3: UInt
	let info4: UInt
}

public enum Environment {
	case sandbox
	case production
}

public struct Configuration {
	public let token: String
	public let environment: Environment
	public let allowSuppressLogLevel: Bool
	public let appSecret: AppSecret
	public let logLevel: LogLevel
}

public struct Revenue {
	public let amount: Double
	public let currency: String
}

public struct Event {
	public let token: String
	public let revenue: Revenue?
}

public struct AdjustClient {
	public init(
		setEnabled: @escaping (Bool) -> Void,
		isEnabled: @escaping () -> Bool,
		appDidLaunch: @escaping (Configuration) -> Void,
		setDeviceToken: @escaping (Data) -> Void,
		trackEvent: @escaping (Event) -> Void
	) {
		self.setEnabled = setEnabled
		self.isEnabled = isEnabled
		self.appDidLaunch = appDidLaunch
		self.setDeviceToken = setDeviceToken
		self.trackEvent = trackEvent
	}

	public var setEnabled: (Bool) -> Void
	public var isEnabled: () -> Bool
	public var appDidLaunch: (Configuration) -> Void
	public var setDeviceToken: (Data) -> Void
	public var trackEvent: (Event) -> Void
}

public enum LogLevel {
	case verbose
	case debug
	case info
	case warn
	case error
	case assert
	case suppress
}

extension AdjustClient: TestDependencyKey {
	public static var testValue: AdjustClient = .init(
		setEnabled: unimplemented("setEnabled"),
		isEnabled: unimplemented("isEnabled"),
		appDidLaunch: unimplemented("appDidLaunch"),
		setDeviceToken: unimplemented("setDeviceToken"),
		trackEvent: unimplemented("trackEvent")
	)
}

public extension DependencyValues {
	var adjustClient: AdjustClient {
		get { self[AdjustClient.self] }
		set { self[AdjustClient.self] = newValue }
	}
}
