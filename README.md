# SuperShapes

<img src="./Images/SuperShapes.png" width="100%">

## About

A fun little experiment showing how to use SwiftUI, Satin, Forge and Youi to make a 3D App for macOS

## Building

Install Bundler using:

```
[sudo] gem install bundler
```

Config Bundler and Install

```
bundle config set path vendor/bundle
bundle install
```

Install the CocoaPod dependencies using Bundler:

```
bundle exec pod install
```

Finally, make sure to open the xcode WORKSPACE (and NOT the xcode project):

```
open SuperShapes.xcworkspace/
```
