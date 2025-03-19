import AdjustDependency
import AdjustSdk
import Dependencies
import Foundation

extension AdjustClient: DependencyKey {
	public static var liveValue: AdjustClient = .init(
		setEnabled: { enabled in
			enabled ? Adjust.enable() : Adjust.disable()
		},
		appDidLaunch: { configuration in
			let config = ADJConfig(
				appToken: configuration.token,
				environment: configuration.environment.adjustEnvironment
			)
			config?.logLevel = configuration.logLevel.adjustLogLevel
			Adjust.initSdk(config)
		},
		appWillOpen: { url in
			guard let deeplink = ADJDeeplink(deeplink: url) else { return }
			Adjust.processDeeplink(deeplink)
		},
		setDeviceToken: { token in
			Adjust.setPushToken(token)
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
			return ADJEnvironmentSandbox
		case .production:
			return ADJEnvironmentProduction
		}
	}
}

extension LogLevel {
	var adjustLogLevel: ADJLogLevel {
		switch self {
		case .verbose:
			return ADJLogLevel.verbose
		case .debug:
			return ADJLogLevel.debug
		case .info:
			return ADJLogLevel.info
		case .warn:
			return ADJLogLevel.warn
		case .error:
			return ADJLogLevel.error
		case .assert:
			return ADJLogLevel.assert
		case .suppress:
			return ADJLogLevel.suppress
		}
	}
}
