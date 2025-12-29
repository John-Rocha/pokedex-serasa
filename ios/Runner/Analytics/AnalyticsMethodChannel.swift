import Flutter
import FirebaseAnalytics

class AnalyticsMethodChannel: NSObject, FlutterPlugin {
    private static let channelName = "com.serasa.pokedex/analytics"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )
        let instance = AnalyticsMethodChannel()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "logEvent":
            handleLogEvent(call, result: result)
        case "logScreenView":
            handleLogScreenView(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleLogEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let eventName = args["eventName"] as? String,
              let parameters = args["parameters"] as? [String: Any] else {
            result(FlutterError(
                code: "INVALID_ARGUMENT",
                message: "Missing parameters",
                details: nil
            ))
            return
        }

        Analytics.logEvent(eventName, parameters: parameters)
        result(nil)
    }

    private func handleLogScreenView(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let screenName = args["screenName"] as? String,
              let screenClass = args["screenClass"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGUMENT",
                message: "Missing parameters",
                details: nil
            ))
            return
        }

        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: screenName,
                AnalyticsParameterScreenClass: screenClass
            ]
        )
        result(nil)
    }
}