import Orion
import EeveeSpotifyC
import UIKit

func exitApplication() {
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
        exit(EXIT_SUCCESS)
    }
}

struct BasePremiumPatchingGroup: HookGroup { }

struct IOS14PremiumPatchingGroup: HookGroup { }
struct NonIOS14PremiumPatchingGroup: HookGroup { }
struct IOS14And15PremiumPatchingGroup: HookGroup { }
struct LatestPremiumPatchingGroup: HookGroup { }

func activatePremiumPatchingGroup() {
    BasePremiumPatchingGroup().activate()
    
    if EeveeSpotify.hookTarget == .lastAvailableiOS14 {
        IOS14PremiumPatchingGroup().activate()
    }
    else {
        NonIOS14PremiumPatchingGroup().activate()
        
        if EeveeSpotify.hookTarget == .lastAvailableiOS15 {
            IOS14And15PremiumPatchingGroup().activate()
        }
        else {
            LatestPremiumPatchingGroup().activate()
        }
    }
}

struct EeveeSpotify: Tweak {
    static let version = "6.2.3"
    
    static var hookTarget: VersionHookTarget {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        NSLog("[EeveeSpotify] Detected Spotify version: \(version)")
        
        switch version {
        case "9.0.48":
            return .lastAvailableiOS15
        case "8.9.8":
            return .lastAvailableiOS14
        case "9.1.0", "9.1.6":
            // Explicitly handle 9.1.x versions
            return .latest
        default:
            return .latest
        }
    }
    
    init() {
        NSLog("[EeveeSpotify] Swift tweak initialization starting...")
        NSLog("[EeveeSpotify] Hook target: \(EeveeSpotify.hookTarget)")
        
        do {
            if UserDefaults.experimentsOptions.showInstagramDestination {
                NSLog("[EeveeSpotify] Activating Instagram destination hooks")
                InstgramDestinationGroup().activate()
            }
            
            if UserDefaults.darkPopUps {
                NSLog("[EeveeSpotify] Activating dark popups hooks")
                DarkPopUps().activate()
            }
            
            if UserDefaults.patchType.isPatching {
                NSLog("[EeveeSpotify] Activating premium patching hooks")
                activatePremiumPatchingGroup()
            }
            
            if UserDefaults.lyricsSource.isReplacingLyrics {
                NSLog("[EeveeSpotify] Activating lyrics hooks")
                BaseLyricsGroup().activate()
                
                if EeveeSpotify.hookTarget == .latest {
                    ModernLyricsGroup().activate()
                }
                else {
                    LegacyLyricsGroup().activate()
                }
            }
            
            NSLog("[EeveeSpotify] Swift tweak initialization completed successfully")
        } catch {
            NSLog("[EeveeSpotify] ERROR during initialization: \(error)")
        }
    }
}
