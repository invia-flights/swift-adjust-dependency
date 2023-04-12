import Adjust
import AdjustDependency
import Dependencies
import Foundation

extension AdjustClient: DependencyKey {
	public static var liveValue: AdjustClient = .init(
		setEnabled: { enabled in
			Adjust.setEnabled(enabled)
		},
		isEnabled: {
			Adjust.isEnabled()
		},
		appDidLaunch: { configuration in
			let config = ADJConfig(
				appToken: configuration.token,
				environment: configuration.environment.adjustEnvironment
			)
			config?.logLevel = configuration.logLevel.adjustLogLevel
			Adjust.appDidLaunch(config)
		},
		appWillOpen: { url in
			Adjust.appWillOpen(url)
		},
		setDeviceToken: { token in
			Adjust.setDeviceToken(token)
		},
		trackEvent: { event in
			guard let adjustEvent = ADJEvent(eventToken: event.token) else {
				return
			}
			if let revenue = event.revenue {
				adjustEvent.setRevenue(revenue.amount, currency: revenue.currency)
			}
			Adjust.trackEvent(adjustEvent)
		}
	)
}

extension Environment {
	var adjustEnvironment: String {
		switch self {
		case .sandbox:
			return "ADJEnvironmentSandbox"
		case .production:
			return "ADJEnvironmentProduction"
		}
	}
}

extension LogLevel {
	var adjustLogLevel: ADJLogLevel {
		switch self {
		case .verbose:
			return ADJLogLevelVerbose
		case .debug:
			return ADJLogLevelDebug
		case .info:
			return ADJLogLevelInfo
		case .warn:
			return ADJLogLevelWarn
		case .error:
			return ADJLogLevelError
		case .assert:
			return ADJLogLevelAssert
		case .suppress:
			return ADJLogLevelSuppress
		}
	}
}
