# <center>parabeac_core

![Parabeac Logo](https://github.com/Parabeac/Parabeac-Core/blob/stable/repo_assets/parabeac_core_image.png?raw=true)


parabeac_core converts design files into isolated & responsive Flutter code for continuous design & development.

[![Discord Chat](https://img.shields.io/discord/308323056592486420.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/qUrghes) [![https://twitter.com/parabeac?lang=en](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&style=plastic)](https://twitter.com/parabeac?lang=en) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://github.com/Parabeac/parabeac_core/blob/stable/CODE_OF_CONDUCT.md) <a href="https://dev.to/parabeac"><img src="https://d2fltix0v2e0sb.cloudfront.net/dev-badge.svg" alt="bravemaster619's DEV Profile" height="22" width="22"></a> [![Codesee Parabeac](https://raw.githubusercontent.com/Parabeac/parabeac_core/stable/codesee_badge.svg)](https://app.codesee.io/maps/public/4577db50-b604-11ec-a5a7-d7b90fb0bfe8)

<h3>
  <a href="https://docs.parabeac.com/docs/hello-world">Hello World</a>
  <span> · </span>
  <a href="https://docs.parabeac.com/docs/creating-a-production-app/fundamental-laws-of-parabeac">Fundamental Laws of Parabeac</a>
  <span> · </span>
  <a href="https://discord.gg/qUrghes">Discord Community/Support</a>
  <span> · </span>
  <a href="https://dev.to/parabeac">Dev.to</a>
  <span> · </span>
  <a href="https://www.youtube.com/channel/UCgfDd4tQYZ5a_A5qxknmh8w">Youtube</a>
  <span> · </span>
  <a href="https://parabeac.notion.site/Parabeac-Reference-519a159f65cd4087b2672eea1807b721">Reference Docs</a>

</h3>

# Why are we here?
The handoff between designers & developers is one of the most costly and frustrating bottlenecks in app development. As design iteration becomes more critical in the execution of app development, this problem is increasingly important to solve. parabeac_core solves this by interpreting designs from tools like Figma and generating isolated & responsive Flutter code. By creating isolated UI, design changes & updates are supported forever.
# Table of Contents
  * [Dependencies](#dependencies)
  * [Running parabeac_core](#running-parabeac_core)
    * [Figma](#figma)
    * [Sketch](#sketch)
  * [Running the generated code](#running-the-generated-code)
    * [Running a Figma Frame/Screen](#running-a-figma-framescreen)
    * [Running a Figma Component](#running-a-figma-component)
    * [Running a Component Package with Widgetbook](#running-a-component-package)
  * [Other](#other)
    * [Global Theming](#global-theming)
      * [TextStyles](#textstyles)
      * [Colors](#colors)
      * [Internal Use](#internal-use)
      * [External Use With Another Flutter Package](#external-use-with-another-flutter-package)
      
    * [All parabeac_core configurations](#all-parabeac_core-configurations)
    * [Metrics](#metrics)   

# Get Started
  
  You can run the code generation by creating a free account with [Parabeac Nest](https://app.parabeac.com) or by following the instructions below.

### Dependencies

- [Dart](https://dart.dev/get-dart)
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Figma File](https://figma.com) - [Sample](https://www.figma.com/file/Ysnjcij14HaE98ucq1iwW1/Parabeac-Counter-App-Demo?node-id=0%3A1)

## Running parabeac_core

### Figma

In your terminal, change your directory to the root parabeac_core directory and run:

```bash
 $ pub get
 $ dart parabeac.dart -f <Figma File ID> -k <Figma API Key> -o <Absolute Path To Output Directory>
```

#### Figma File ID (Required): -f

1. Visit https://figma.com and log in.
2. Select your Design File
3. The file ID is contained in the URL of your design file immediately after figma.com/file/`<fileID>`/.

   _Example: The file ID for `https://www.figma.com/file/Ysnjcij14HaE98ucq1iwW1/Parabeac-Counter-App-Demo` is `Ysnjcij14HaE98ucq1iwW1`_

#### Figma API Key (Required): -k

1. Visit https://figma.com and log in.
2. Navigate to your user profile and select `Settings`
3. Scroll Down to the "Create a new Personal Access Token"
4. Create a new Personal Access Token and copy your new API key. (It should look something like this: `64522-a0e5509a-d5ce-47a8-880b-c295f9cb27ed`)
  
  Having trouble? View this video instead: https://youtu.be/uUv-IZX4KYg

#### Name (Optional): -n

Sets the name of the exported project. For instance, if you want to name your project "cool_project", set the `-n` flag to `cool_project`. _Note: parabeac_core can only use [valid Flutter project names](https://dart.dev/tools/pub/pubspec#name)._

#### Absolute Path (Optional): -o

Specifies the absolute path of the exported Flutter Project to be created. For instance, to export your Flutter project in the Documents folder, set your `-o` flag to `/Users/ParabeacUser/Documents/` Not setting this will export the project in the parabeac_core directory.

### Sketch

Due to the lack of requested support for Sketch and the major updates to this project, we temporarily stopped support for Sketch.

# Running the generated code

We recommend following our [Hello World guide](https://docs.parabeac.com/docs/hello-world) but if you feel experienced enough with Flutter, feel free to jump right in here:

### Running a Figma Frame/Screen
![Figma Frame Example](https://github.com/Parabeac/parabeac_core/blob/stable/repo_assets/figma_frame_example.png?raw=true)
#### Steps

1. Open your generated project (Will be at the absolute path you set or in the parabeac_core directory)
2. If your frame was designed to be a screen, you can quickly test it by editing the MaterialApp widget in main.dart like the following:

```class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      /// MyAppScreen() is a generated widget from the sample figma file.
      home: MyAppScreen(),
      ),
    );
  }
}
```

3. Save `main.dart` and execute `flutter run`

### Running a Figma Component
![Figma Component Example](https://raw.githubusercontent.com/Parabeac/parabeac_core/stable/repo_assets/figma_component_example.png)

1. Navigate to a widget/screen where you can add in your component as a child.
2. Reference the component by providing a LayoutBuilder widget like the following:

```
Container(
  child: LayoutBuilder(builder: (context, constraints) {
    return FooCompoent(
      constraints,
    );
  })
)
```

1. Save the class and execute `flutter run` in your terminal & navigate your app to the expected location where the component should show up.
  
  
### Running a component package
The best way to run and test a component package is to use tools like Storybook.js. We have an autogen for [Widgetbook](https://github.com/widgetbook/widgetbook). If you head over to `parabeac_core/lib/configurations/configurations.json` you can assign the property "componentIsolation" to "widgetbook" like the following.
  
<img width="533" alt="Configurations for Widgetbook" src="https://user-images.githubusercontent.com/13757212/156039026-bb3e22f7-5d55-4f68-ba1a-d420177594cb.png">

  _Be sure to use Figma Components_  
  
  To run the widgetbook, instead of running the normal `flutter run`, you want to run `flutter run lib/main_widgetbook.g.dart`.
  
# What's Next?
Be sure to complete our [Hello World Guide](https://docs.parabeac.com/docs/hello-world) or read the [docs](https://docs.parabeac.com/) so you know how to handle the code generated.
  
## Enabling the design team to create pull requests
If you find the viability in the code generation to support continuous design changes, create a free account on [Parabeac Nest](https://app.parabeac.com) where you can create an integration between Figma & the project Github repo.
## Stay up to date
Follow or subscribe to our [Twitter](https://twitter.com/parabeac), [Youtube](https://www.youtube.com/channel/UCgfDd4tQYZ5a_A5qxknmh8w), [Dev.to](https://dev.to/parabeac) &/or [Newsletter](https://share.hsforms.com/1uu1ZTrhPSwK69T2md__lCw5i54a) to stay up to date on product releases. And if you want to influence the direction of this project, create an [issue](https://github.com/Parabeac/parabeac_core/issues/new/choose) or join our [Discord](https://discord.gg/qUrghes), we'd love to hear your feedback.
# Other
## Global Theming
* parabeac_core has support for global theming for **TextStyles** and **Colors**. If detected, parabeac_core will export two files containing the styles ready for internal and external use.

### TextStyles
* If parabeac_core detects global TextStyles in the design file, it will export a file under `lib/theme/<your_package_name>_text_styles.g.dart`. This file will contain all global TextStyles of the design file in the following format:

```dart
class <YourPackageName>TextStyles {
  /// Parabeac Style Description
  static const TextStyle parabeacTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 6.0,
    fontFamily: 'Inter',
    decoration: TextDecoration.none,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle newStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    fontFamily: 'Inter',
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
  );
}
```
### Colors
* If parabeac_core detects global Colors in the design file, it will export a file under `lib/theme/<your_package_name>_colors.g.dart`. This file will contain all global TextStyles of the design in the following format:
```dart
class <YourPackageName>Colors {
  /// Parabeac Red Description
  static const Color parabeacRed = Color(0xffff0d0d);

  static const Color parabeacBlue = Color(0xff28e5ff);

  static const Color parabeacGreen = Color(0xff49ff0a);
}
```

<!-- TODO: Add Global theming documentation when it is ready. -->

### Internal Use

Styling classes can be used easily within the parabeac-generated package by simply importing the file as follows: 

```dart
/// Text Styles import
import 'package:<your_package_name>/theme/<your_package_name>_text_styles.g.dart';
/// Colors import
import 'package:<your_package_name>/theme/<your_package_name>_colors.g.dart';
```
and using them like so:
```dart
/// To use a TextStyle
<YourPackageName>TextStyles.parabeacTextStyles;

/// To use a Color
<YourPackageName>Colors.parabeacRed;

```

### External Use With Another Flutter Package
In order to use global styling with another Flutter package, you must add the parabeac-generate package to your own Flutter package as follows:
```yaml
dependencies:
  <your_package_name>:
    path: path/to/<your_package_name>
```
For more options on how to import this package, see the following [Dart package dependency docs](https://dart.dev/tools/pub/dependencies).

## All parabeac_core Configurations
* `"componentIsolation"` - _Valid Values Below_
  * `"none"`
  * `"widgetbook"` -- Generates a Widgetbook File 
  * `"dashbook"` -- Generates a Dashbook File
  
_To run dashbook or widgetbook, run `flutter run lib/main_widgetbook.g.dart` or `flutter run lib/main_dashbook.g.dart`_
  
* `"breakpoints"` -- _(Beta)_ Describes where the breakpoints should be in the ResponsiveLayoutBuilder whenever there are multiple screens with the same name.
  * An Array of Key Values: (`"name of breakpoint" : "breakpoint value (int)"`)
  
## Metrics
parabeac_core keeps track of a few data points to help us understand usage. Although we do not collect any personal information, you can turn off metrics at any time by creating the environment variable `PB_METRICS = "false"`.
