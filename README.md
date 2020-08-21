# [<img src="assets/logo.jpeg"  width="80" height="80">](https://www.bitrise.io/add-ons/trace-mobile-monitoring)  Trace SDK
[![Bitrise status](https://app.bitrise.io/app/fa31931683b0dd17.svg?token=MpCmFyjh7KE7W785Tb3Keg)](https://app.bitrise.io/app/fa31931683b0dd17#/builds)[![Cocoapods](https://img.shields.io/cocoapods/v/BitriseTrace)](https://cocoapods.org/pods/BitriseTrace)![Cocoapods platforms](https://img.shields.io/cocoapods/p/BitriseTrace)[![Cocoapods](https://img.shields.io/cocoapods/l/BitriseTrace)](https://github.com/bitrise-io/trace-cocoa-sdk/blob/main/LICENSE)![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen)![Swift version](https://img.shields.io/badge/Swift-5.2.4-red)[![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fbitrise)](https://twitter.com/bitrise)[![Join Slack group](https://img.shields.io/badge/Chat-Slack-blue?link=https://chat.bitrise.io/)](https://chat.bitrise.io/)[![BCH compliance](https://bettercodehub.com/edge/badge/bitrise-io/trace-cocoa-sdk?branch=main)](https://bettercodehub.com/results/bitrise-io/trace-cocoa-sdk)

Catch bugs before they reach production — get detailed crash reports and monitor how your app is performing across the entire install base. When issues are detected we show you exactly what happened during the user session to locate, reproduce, and fix the problem as quickly as possible.
Use Trace to:
- *Detect the problem*: Know about issues before your users report them.
- *Assess the impact*: Focus on resolving the issues which are most impactful to your users.
- *Trace the cause*: Spend less time trying to reproduce issues.

[* Trace website](https://trace.bitrise.io)  [* What's Trace?](https://www.bitrise.io/add-ons/trace-mobile-monitoring)  [* Getting started guide](https://trace.bitrise.io/o/getting-started)  [* Trace configuration settings](https://trace.bitrise.io/settings)

## Requirements

- iOS 10.0+ 
- [Xcode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) 11.5+
- Swift 5.2.4

## Installation

`Trace` SDK doesn't contain any external dependencies but does depend on a few system frameworks such as:      
* `SystemConfiguration.framework`
* `libc++.tbd`
* `libz.tbd`

Each framework can be easier found in Xcode's framework list. These are currently the supported integration options:

### Bitrise Workflow

### Install from Bitrise workflow step site

Use *[Add trace SDK](https://www.bitrise.io/integrations/steps/add-trace-sdk)* step to add the SDK to your project automatically. All the downloads, linking SDK and supporting system framework and libraries are done for you. The step *must* come before the Xcode Archive & Export step.

### Install directly from the source code

Add the following step inside your `bitrise.yml` file if the step project is in your repo folder

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

Now that the SDK is set up in your workspace, add the collector token (`bitrise_configuration.plist`) found in the [setting page](https://trace.bitrise.io/settings) or [getting started](https://trace.bitrise.io/o/getting-started) page. Make sure this file is added to your application target.

### [Carthage](https://github.com/Carthage/Carthage)

Add this to your `Cartfile`

```ruby
github "bitrise-io/trace-cocoa-sdk"
```

```bash
$ carthage update
```
Once you have included the library in your Xcode project:
* Select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for `Other Linker Flags` or `OTHER_LDFLAGS` and enter `-force_load '$(BUILT_PRODUCTS_DIR)/libTrace.a'`
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

* Download `libTrace.a` static library assert from [Github release page](https://github.com/bitrise-io/trace-cocoa-sdk/releases). Please select the first file under asset's called `libTrace.a`.
* Drop the library at the root of your Xcode project. i.e same directory as your `xcproject/xcworkspace` project.

<img src="assets/library_path_example.png" width=70%>

* Next in Xcode, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* Now, In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for `Other Linker Flags` or `OTHER_LDFLAGS` and enter `-force_load libTrace.a`

<img src="assets/other_linker_flags_example.png" width=90%>

`Note: The code snippet assumes the library is in the same directory as your `xcproject/xcworkspace` project.` If you use a different location add the new path.

* Click on the + button under the "Frameworks, Libraries and Embedded Content" section.
* Add `libz.tbd` and `libc++.tbd`.
* And that's it!

#### Embedded Xcode project

* Open up Terminal, `cd` into your top-level project directory where Xcode project is stored.
* Add `Trace` as a git submodule by running the following command:

`$ git submodule add https://github.com/bitrise-io/trace-cocoa-sdk.git`

* Open the new `trace-cocoa-sdk` folder, and drag the `Trace.xcodeproj` (blue project file`.xcodeproj`) into the Project Navigator of your application's Xcode project. They should appear nested underneath your application's blue project icon. 

<img src="assets/embedded_xcode_project_example.png" width=30%>

* Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
* In the tab bar at the top of that window, open the "General" panel.
* Click on the + button under the "Frameworks, Libraries and Embedded Content" section.
* Add `libTrace.a` library from the search list.
* Add `libz.tbd` and `libc++.tbd` as well.
* Now, In the tab bar at the top of that window, open the "Build Settings" panel.
* Search for `Other Linker Flags` or `OTHER_LDFLAGS` and enter `-force_load '$(BUILT_PRODUCTS_DIR)/libTrace.a'`

<img src="assets/other_linker_flags_via_submodule_example.png" width=70%>

Note: don't worry about other attributes on the list.

* And that's it!

# [Storage](https://monitoring-sdk.firebaseapp.com/)

SDk binaries is hosted on Firebase, download the latest version [here](https://monitoring-sdk.firebaseapp.com/latest/libTrace.a) or download a specific version by adding the version details inside the [url](https://monitoring-sdk.firebaseapp.com/latest/libTrace.a) i.e https://monitoring-sdk.firebaseapp.com/{MAJOR.MINOR.PITCH}/libTrace.a

By default navigating to the root of the SDK site will always redirect to latest version.

# Common problems

#### C++ system library is not linked

<img src="assets/c++_not_linked_error_example.png" width=90%>

* Click on the + button under the "Frameworks, Libraries and Embedded Content" section.
* Add `libz.tbd` and `libc++.tbd`.
* And that's it!

#### Can't find Trace library

<img src="assets/library_not_found_example.png" width=90%>

This error is caused by Xcode not being able to locate Trace library. By default, our installation guide uses the easiest approach. To resolve this error go to `Other Linker Flags` or `OTHER_LDFLAGS` in your application target and enter `-force_load CORRECT_PATH_TO_libTrace.a'`

#### Can't find collector token

<img src="assets/add_bitrise_configuration_example.png" width=90%>

Make sure `bitrise_configuration.plist` is included in your project and the target membership is set to the correct one.

#### Can't find collector token

`[Bitrise:Trace/internalError] Bitrise configuration file is missing from Bundle.main`
`[Bitrise:Trace/internalError] Application failed to read the configuration file, all data will be cached until it's resolved`

Add the collector token (`bitrise_configuration.plist`) found in the [setting page](https://trace.bitrise.io/settings) or [getting started](https://trace.bitrise.io/o/getting-started) page. Make sure this file is added to your application target.

# Miscellaneous

### Special thanks to
Karl Stenerud [KSCrash](https://github.com/kstenerud/KSCrash/) crash reporting dependency, last commit: `d8845bd622f4cf469ba65e9be42de116e1548478`, branch: master, date: (18th August)

# License
Trace is released under the MIT license. See [LICENSE](https://github.com/bitrise-io/trace-cocoa-sdk/blob/main/LICENSE) for details.
