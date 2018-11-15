# mygps

A simple project showing GPS and map integration in Flutter.

To use this, you'll need to have an map API key from Google and/or Apple, 
and add it to your project:

## Android 
Get an API key at https://cloud.google.com/maps-platform/.

Specify your API key in the application manifest 
`android/app/src/main/AndroidManifest.xml`:


```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>

```

## iOS
Supply your API key in the application delegate `ios/Runner/AppDelegate.m`:
```
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```
## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
# flutter-gps
