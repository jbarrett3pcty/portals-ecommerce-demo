import UIKit
import IonicPortals
import CapacitorCamera

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Register Portals
        PortalsRegistrationManager.shared.register(key: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiNjVmMTU1MS1mMDAyLTQ5MTEtOGQxOC1mZmM5OTg0NWEwZTYifQ.dL_uqjTN9gFn3A_9g1eV6EaJ-5Uhj5b26Z21b8-DODmr6jsVdjnWH1-sWzjMmKSbIQDqptPpTmXj_YlkgoogQhKJwP8R0ITFzKz61sMo_ViFhcuQ0Y0XisTEO-UIWj8WV7eP3QcZx-DjVrshAuBmF7oIlGLZTKy2ovRFOHCxcVgKWByixbSdLEuuV4nEYrn8lS1Uy1tD3YecUBDMNOuH0IueNE7F6PrxxIPFHEBI04U6gSj0e2lGu0vCGwn-RPiab1evLzDqVzrC3MHcgLdli4iHQG98bS7JsKFlN8_1l0BIsCQf4SWy44XoMfRlkf6OqsLWr6xQH_hT0UxCXe3SrQ")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension Portal {
    static let featured = Self(
        name: "featured",
        startDir: "portals/featured"
    )

    private static let commonPlugins: [Plugin] = [
        .type(ShopAPIPlugin.self),
        .instance(
            WebVitalsPlugin { portalName, duration in
                print("Portal \(portalName) - First Contentful Paint: \(duration)ms")
            }
        )
    ]

    static let checkout = Self(
        name: "checkout",
        startDir: "portals/shopwebapp",
        initialContext: ["startingRoute": "/checkout"],
        plugins: commonPlugins
    )
    
    static let help = Self(
        name: "help",
        startDir: "portals/shopwebapp",
        initialContext: ["startingRoute": "/help"],
        plugins: commonPlugins
    )
    
    static let user = Self(
        name: "user",
        startDir: "portals/shopwebapp",
        initialContext: ["startingRoute": "/user"],
        plugins: commonPlugins
    )
    .adding(CameraPlugin.self)
}

