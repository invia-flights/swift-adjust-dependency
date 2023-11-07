import Dependencies
import Foundation

public enum Environment {
	case sandbox
	case production
}

public struct Configuration {
	public init(
		token: String,
		environment: Environment,
		allowSuppressLogLevel: Bool,
		logLevel: LogLevel
	) {
		self.token = token
		self.environment = environment
		self.allowSuppressLogLevel = allowSuppressLogLevel
		self.logLevel = logLevel
	}

	public let token: String
	public let environment: Environment
	public let allowSuppressLogLevel: Bool
	public let logLevel: LogLevel
}

public struct Revenue {
	public init(amount: Double, currency: String) {
		self.amount = amount
		self.currency = currency
	}
	
	public init(amount: Decimal, currency: String) {
		self.amount = Double(truncating: amount as NSNumber)
		self.currency = currency
	}
	
	public let amount: Double
	public let currency: String
}

public struct Event {
	public init(_ token: String, revenue: Revenue? = nil) {
		self.token = token
		self.revenue = revenue
	}
	
	public let token: String
	public let revenue: Revenue?
}

public struct AdjustClient {
	public init(
		setEnabled: @escaping (Bool) -> Void,
		isEnabled: @escaping () -> Bool,
		appDidLaunch: @escaping (Configuration) -> Void,
		appWillOpen: @escaping (URL) -> Void,
		setDeviceToken: @escaping (Data) -> Void,
		trackEvent: @escaping (Event) -> Void
	) {
		self.setEnabled = setEnabled
		self.isEnabled = isEnabled
		self.appDidLaunch = appDidLaunch
		self.setDeviceToken = setDeviceToken
		self.trackEvent = trackEvent
		self.appWillOpen = appWillOpen
	}

	public var setEnabled: (Bool) -> Void
	public var isEnabled: () -> Bool
	public var appDidLaunch: (Configuration) -> Void
	public var appWillOpen: (URL) -> Void
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
		appWillOpen: unimplemented("appWillOpen"),
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
