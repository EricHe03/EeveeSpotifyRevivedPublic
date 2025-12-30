#import <Orion/Orion.h>
#import <Foundation/Foundation.h>

__attribute__((constructor)) static void init() {
    @try {
        NSLog(@"[EeveeSpotify] Initializing tweak...");
        
        // Initialize Orion - do not remove this line.
        orion_init();
        
        NSLog(@"[EeveeSpotify] Tweak initialized successfully");
        // Custom initialization code goes here.
    }
    @catch (NSException *exception) {
        NSLog(@"[EeveeSpotify] ERROR: Failed to initialize tweak: %@", exception);
        NSLog(@"[EeveeSpotify] Reason: %@", [exception reason]);
    }
}
