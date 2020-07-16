# <img src="assets/logo.jpeg"  width="90" height="90">  Trace SDK
![Bitrise status](https://app.bitrise.io/app/fa31931683b0dd17.svg?token=MpCmFyjh7KE7W785Tb3Keg)![Cocoapods](https://img.shields.io/cocoapods/v/BitriseTrace)![Cocoapods platforms](https://img.shields.io/cocoapods/p/BitriseTrace)![Cocoapods](https://img.shields.io/cocoapods/l/BitriseTrace)![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen)![Swift version](https://img.shields.io/badge/Swift-5.2.4-red)![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fbitrise)![Join Slack group](https://img.shields.io/badge/Chat-Slack-blue?link=https://chat.bitrise.io/)[![BCH compliance](https://bettercodehub.com/edge/badge/bitrise-io/trace-cocoa-sdk?branch=main)](https://bettercodehub.com/)

Catch bugs before they reach production — get detailed crash reports and monitor how your app is performing across the entire install base. When issues are detected we show you exactly what happened during the user session to locate, reproduce, and fix the problem as quickly as possible.
Use Trace to:
- Detect the problem: Know about issues before your users report them.
- Assess the impact: Focus on resolving the issues which are most impactful to your users.
- Trace the cause: Spend less time trying to reproduce issues.

## Requirements

iOS 10.0+ 
Xcode 11.5+
Swift 5.2


## Installation

`Trace` SDK doesn't contain any external dependencies but does depend on a few system frameworks such as:      
* `SystemConfiguration.framework`
* `libc++.tbd`
* `libz.tbd`

Each framework can be easier found in Xcode framework list. These are currently the supported options:

### Bitrise Workflow

### Install from Bitrise workflow step site

Use [Add trace SDK](https://www.bitrise.io/integrations/steps/add-trace-sdk) step to add the SDK to your project automatically. All the downloads, linking SDK and supporting system framework and librares are down for you. 

### Install directly from source

Add the follow step inside your `bitrise.yml` file if the step project is in your repo folder

```yml
- path::./step/:
    title: Add Trace SDK to Xcode project
    inputs:
    - lib_version: "latest"
```

If your using GIT use the following:
```yml
- git::https://github.com/bitrise-steplib/bitrise-step-add-trace-sdk.git@master:
    title: Add Trace SDK to Xcode project
    inputs:
    - lib_version: "latest"
```

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
Optional: Setup pod
```bash
$ pod init
```

Add Trace SDK to the `Podfile`
```ruby
# Podfile

target 'YOUR_TARGET_NAME' do
    pod 'BitriseTrace'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

Now that the SDK is setup in your project, add the collector token found in the [setting page](https://trace.bitrise.io/settings).

Todo: Steps to create a plist


### [Carthage](https://github.com/Carthage/Carthage)

Add this to your `Cartfile`

```ruby
# Private access 
github "bitrise-io/trace-cocoa-sdk"
```

```bash
$ carthage update
```
Once you have included the library in your Xcode project:
* Select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for "Other Linker Flags" or "OTHER_LDFLAGS" and enter `-force_load '$(BUILT_PRODUCTS_DIR)/libTrace.a'`
* And that's it!


#### Carthage as a Static Library

Carthage defaults to building `Trace` as a Dynamic Library. 

If you wish to build `Trace` as a Static Library using Carthage you may use the script below to manually modify the framework type before building with Carthage:

```bash
carthage update `Trace` --platform iOS --no-build
sed -i -e 's/MACH_O_TYPE = mh_dylib/MACH_O_TYPE = staticlib/g' Carthage/Checkouts/Trace/Trace.xcodeproj/project.pbxproj
trace build Trace --platform iOS
```


### [Swift Package Manager](https://swift.org/package-manager)
Todo: (Q3 2020) Once Xcode 12 has been released


### [Manual](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/WorkingonRelatedProjects.html#//apple_ref/doc/uid/TP40010215-CH33-SW1)

If you prefer not to use any of the aforementioned dependency managers, you can integrate `Trace` into your project manually.

#### Embedded static library at build time

* Download static library (`libTrace.a`) assert from [Github release page](https://github.com/bitrise-io/trace-cocoa-sdk/releases)
* Drop the library at the root of your Xcode project. i.e same directory as your `xcproject/xcworkspace`.
* Next in Xcode, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* Now, In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for "Other Linker Flags" or "OTHER_LDFLAGS" and enter `-force_load libTrace.a`
* Click on the + button under the "Frameworks, Libraries and Embedded Content" section.
* Add `libz.tbd` and `libc++.tbd`.
* And that's it!


#### Embedded Xcode project

* Open up Terminal, `cd` into your top-level project directory where Xcode project is stored.
* Add `Trace` as a git submodule by running the following command:

`$ git submodule add https://github.com/bitrise-io/trace-cocoa-sdk.git`

* Open the new `Trace` folder, and drag the `Trace.xcodeproj` into the Project Navigator of your application's Xcode project. They should appear nested underneath your application's blue project icon. 
* Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* In the tab bar at the top of that window, open the "General" panel.
* Click on the + button under the "Frameworks, Libraries and Embedded Content" section.
* Add `libTrace.a` library.
* Add `libz.tbd` and `libc++.tbd` as well.
* Now, In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for "Other Linker Flags" or "OTHER_LDFLAGS" and enter `-force_load '$(BUILT_PRODUCTS_DIR)/libTrace.a'`
* And that's it!

# [Storage](https://monitoring-sdk.firebaseapp.com/)

SDk binaries is hosted on Firebase, download the latest version [here](https://monitoring-sdk.firebaseapp.com/latest/libTrace.a) or download a specific version by adding the version details inside the [url](https://monitoring-sdk.firebaseapp.com/latest/libTrace.a) i.e https://monitoring-sdk.firebaseapp.com/{MAJOR.MINOR.PITCH}/libTrace.a

By default navigating to root of the SDK site will always redirect to latest version.

# Miscellaneous

### Special thanks to
Karl Stenerud [KSCrash](https://github.com/kstenerud/KSCrash/) crash reporting dependency, last commit: `58094b309e443f16273a75d87a3065a9fafd2540`

# License
Trace is released under the MIT license. See LICENSE for details.
