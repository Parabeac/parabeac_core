# <center>parabeac_core

![Parabeac Logo](./repo_assets/parabeac_core_image.png)

parabeac_core converts design files into isolated & responsive Flutter code for continuous design & development.

[![Discord Chat](https://img.shields.io/discord/308323056592486420.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://bit.ly/3JajaPd)[![https://twitter.com/parabeac?lang=en](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&style=plastic)](http://bit.ly/3l8FiBD) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](http://bit.ly/3FdNozR) <a href="https://dev.to/parabeac"><img src="https://d2fltix0v2e0sb.cloudfront.net/dev-badge.svg" alt="bravemaster619's DEV Profile" height="22" width="22"></a> [![Codesee Parabeac](https://raw.githubusercontent.com/Parabeac/parabeac_core/stable/codesee_badge.svg)](https://app.codesee.io/maps/public/4577db50-b604-11ec-a5a7-d7b90fb0bfe8)

<h3>
  <a href="http://bit.ly/3yvGsKL">Hello World</a>
  <span> · </span>
  <a href="http://bit.ly/3T7NS0b">Fundamental Laws of Parabeac</a>
  <span> · </span>
  <a href="http://bit.ly/3JajaPd">Discord Community/Support</a>
  <span> · </span>
  <a href="http://bit.ly/3Jen2in">Dev.to</a>
  <span> · </span>
  <a href="http://bit.ly/3YHX24F">Youtube</a>

</h3>

# Why are we here?

The handoff between designers & developers is one of the most costly and frustrating bottlenecks in app development. As design iteration becomes more critical in the execution of app development, this problem is increasingly important to solve. parabeac_core solves this by interpreting designs from tools like Figma and generating isolated & responsive Flutter code. By creating isolated UI, design changes & updates are supported forever.

# Table of Contents

- [Dependencies](#dependencies)
- [Running parabeac_core](#running-parabeac_core)
  - [Required Configurations](#required-configurations)
  - [Optional Configurations](#optional-configurations)
  - [Configuations.json file](#configurations.json)
- [Running the generated code](#running-the-generated-code)
  - [Running a Figma Frame/Screen](#running-a-figma-framescreen)
  - [Running a Component Package with Widgetbook](#running-a-component-package)
  - [Utilizing a Figma Component](#utilizing-a-figma-component)
  - [Utilizing Themes](#utilizing-themes)
      - [Internal Use in a Parabeac Project](#internal-use-in-an-parabeac-project)
      - [External Use with Another Flutter Package](#external-use-with-another-flutter-package)
      - [TextStyles](#textstyles)
      - [Colors](#colors)
      - [Light/Dark Themes](#light--dark-color-themes)
- [Metrics](#metrics)
- [What's Next?](#whats-next)
    - [Integrate with Github]()
    - [Stay Up to Date]()
    - [Influence this Project]()
# Get Started

You can run the code generation by creating a free account with [Parabeac Cloud](http://bit.ly/3yyUxXO) or by following the instructions below.

### Dependencies

- [Dart](https://dart.dev/get-dart)
- [Flutter](http://bit.ly/3mNPss1)
- [Figma File](http://bit.ly/3yz3UXo) - you can test a [Sample Figma File](http://bit.ly/3J9G6OQ)

## Running parabeac_core

## Basic Run Command

In your terminal, change your directory to the root parabeac_core directory and run:

```bash
 $ pub get
 $ dart parabeac.dart -f <Figma File ID> -k <Figma API Key> -o <Absolute Path To Output Directory>
```
## Required Configurations

#### Figma File ID (Required): -f

1. Visit [Figma](http://bit.ly/3yz3UXo) and log in.
2. Select your Design File
3. The file ID is contained in the URL of your design file immediately after figma.com/file/`<fileID>`/.

   _Example: The file ID for `https://www.figma.com/file/Ysnjcij14HaE98ucq1iwW1/Parabeac-Counter-App-Demo` is `Ysnjcij14HaE98ucq1iwW1`_

#### Figma API Key (Required): -k

1. Visit [Figma](http://bit.ly/3yz3UXo) and log in.
2. Navigate to your user profile and select `Settings`
3. Scroll Down to the "Create a new Personal Access Token"
4. Create a new Personal Access Token and copy your new API key. (It should look something like this: `64522-a0e5509a-d5ce-47a8-880b-c295f9cb27ed`)

Having trouble? View [this video](http://bit.ly/3YFDdLm) instead.

## Optional Configurations

#### Name (Optional): -n

Sets the name of the exported project. For instance, if you want to name your project "cool*project", set the `-n` flag to `cool_project`. \_Note: parabeac_core can only use [valid Flutter project names](https://dart.dev/tools/pub/pubspec#name).*

#### Absolute Path (Optional): -o

Specifies the absolute path of the exported Flutter Project to be created. For instance, to export your Flutter project in the Documents folder, set your `-o` flag to `/Users/ParabeacUser/Documents/` Not setting this will export the project in the parabeac_core directory.

#### Project Type (Optional): --project-type

Specifies the project type. At the time of writing, there are three levels: **themes**, **components**, and **screens**.

- **themes** - will export global styles, such as text styles, global colors, and light/dark color schemes to a file in `lib/theme`.
- **components** - will export theming as well as individual reusable UI components to `lib/widgets`.
- **screens** [**default**] - will export all of the above and a full UI screen to `lib/views`.

The first two levels, theming and component, export packages that one can import to an existing Flutter project. The third level, screen, exports both of those levels as well as the main screen-- essentially, a full running app.

#### Design System (Optional): -d

Specifies the project design system to export. At the time of writing, there are two options: **material2** and **material3**. Take into account that Material 2 will be deprecated and removed eventually.

- **material2** - will export TextTheme using only the deprecated fields for it.
- **material3** - will export TextTheme using only the non-deprecated fields for it.


#### Component Isolation (optional):

- `"componentIsolation"` - _Valid Values Below_
  - `"none"`
  - `"widgetbook"` -- Generates a Widgetbook File
  - `"dashbook"` -- Generates a Dashbook File

_To run dashbook or widgetbook, run `flutter run lib/main_widgetbook.g.dart` or `flutter run lib/main_dashbook.g.dart`_


## Configurations.json

To avoid repetitively entering the same configuration flags in the command line, you can edit the configurations.json file. Just populate the corresponding fields with the information you would normally enter with the commands listed above.

The default configurations.json file is pictured below. The file can be found in `lib/configurations`

![image](https://user-images.githubusercontent.com/42812006/184252654-5fc55f48-502b-4eca-8bc5-029832a23d39.png)

For example, take the following CLI command:

```
dart parabeac.dart -f AaGNw26baKo91CT0I4B2lJ -k figd_60xGD-VXvoA-ABRdk7VPGq2Zrk_vYj2oSzUPqi6D -o /Users/ivanvigliante/Documents/parabeac/core/debug
```

This is the equivalent of the command above in the `configurations.json` file:

![image](https://user-images.githubusercontent.com/42812006/184252687-e4cd2e75-a116-4d33-a8a6-b40cac096f52.png)


# Running the generated code


## Running a Figma Frame/Screen
We recommend following our [Hello World guide](https://bit.ly/3yvGsKL) but if you feel experienced enough with Flutter, feel free to jump right in here:

![Figma Frame Example](https://github.com/Parabeac/parabeac_core/blob/stable/repo_assets/figma_frame_example.png?raw=true)

#### Steps

1. Open your generated project (Will be at the absolute path you set or in the parabeac_core directory)
2. If your frame was designed to be a screen, you can quickly test it by editing the MaterialApp widget in main.dart to be the following:

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


## Running a component package

The best way to run and test a component package is to use tools like Storybook.js. We have an autogen for [Widgetbook](https://github.com/widgetbook/widgetbook). If you head over to the configurations.json file (`parabeac_core/lib/configurations/configurations.json`) you can assign the property "componentIsolation" to "widgetbook". This will look like the following.

<img width="533" alt="Configurations for Widgetbook" src="https://user-images.githubusercontent.com/13757212/156039026-bb3e22f7-5d55-4f68-ba1a-d420177594cb.png">

_Be sure to use Figma Components_

*To run widgetbook, instead of running the normal `flutter run`, run `flutter run lib/main_widgetbook.g.dart`.*

## Utilizing a Figma Component
![Figma Component Example](https://raw.githubusercontent.com/Parabeac/parabeac_core/stable/repo_assets/figma_component_example.png)

To use a generated component on an exisitng screen:

1. Navigate to a widget/screen where you want to add in your component as a child.
2. Reference the component by providing a LayoutBuilder widget like the following:
3. Save the class and execute `flutter run` in your terminal & navigate your app to the expected location where the component should show up.
```
Container(
  child: LayoutBuilder(builder: (context, constraints) {
    return FooCompoent(
      constraints,
    );
  })
)
```


## Utilizing Themes

Parabeac_core has support for global theming in the form of:
 - [**TextStyles**](#textstyles)
 - [**Colors**](#colors)
 - [**Themes**](#light--dark-color-themes) 
  
If present, parabeac_core will export three files containing the detected styles ready for internal and external use.

For more information on how to convert global styles with parabeac_core read the [project type flag](#project-type-optional---project-type) section. For more information about TextStyles, ColorStyles, and Themes, see our [documentation on Themes](https://bit.ly/3ZFB6Ix).

### Internal Use

Styling classes can be used easily within the parabeac-generated package simply by:

1. importing the file as follows:

    ```dart
    /// Text Styles import
    import 'package:<your_package_name>/theme/<your_package_name>_text_styles.g.dart';
    /// Colors import
    import 'package:<your_package_name>/theme/<your_package_name>_colors.g.dart';
    /// Theme import
    import 'package:<your_package_name>/theme/<your_package_name>_theme.g.dart';
    ```

2. referencing them as follows:

    ```dart
    /// To use a TextStyle
    <YourPackageName>TextStyles.parabeacTextStyles;

    /// To use a Color
    <YourPackageName>Colors.parabeacRed;

    /// To use a ColorScheme
    <YourPackageName>Theme.themeDataDark;
    ```

### External Use With Another Flutter Package

In order to use global styling with another Flutter package, you must add the parabeac-generated package to your own Flutter package as follows:

```yaml
dependencies:
  <your_package_name>:
    path: path/to/<your_package_name>
```

For more options on how to import this package, see the following [Dart package dependency docs](https://dart.dev/tools/pub/dependencies).



### TextStyles

- If parabeac_core detects global TextStyles in the design file, it will export a file under `lib/theme/<your_package_name>_text_styles.g.dart`. 

<details><summary>This file will contain all global TextStyles of the design file in the following format:</summary>

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
</details>


### Colors

- If parabeac_core detects global Colors in the design file, it will export a file under `lib/theme/<your_package_name>_colors.g.dart`. 

<details><summary>This file will contain all global ColorStyles of the design in the following format:</summary>

```dart
class <YourPackageName>Colors {
  /// Parabeac Red Description
  static const Color parabeacRed = Color(0xffff0d0d);

  static const Color parabeacBlue = Color(0xff28e5ff);

  static const Color parabeacGreen = Color(0xff49ff0a);
}
```
</details>


### Light / Dark Color Themes

- If parabeac_core detects colors formatted in the Material Design 2 or Material Design 3 specifications, it will export a file under `lib/theme/<your_package_name>_theme.g.dart`. 

To learn more about Material Design, check oout our [documentation on Themes](https://bit.ly/3ZFB6Ix).

<details><summary>This file will contain Themes and ColorSchemes in the following format:</summary>

```dart
import 'package:flutter/material.dart';import 'package:themedemo/theme/themedemo_text_styles.g.dart';
import 'package:themedemo/theme/themedemo_colors.g.dart';

class ThemedemoTheme {

static const TextTheme textTheme = TextTheme(headline1: ThemedemoTextStyles.headline1,headline2: ThemedemoTextStyles.headline2,headline3: ThemedemoTextStyles.headline3,);

static const ColorScheme light = ColorScheme.light(onPrimary: ThemedemoColors.lightOnPrimary,primary: ThemedemoColors.lightPrimary,primaryContainer: ThemedemoColors.lightPrimaryContainer,secondary: ThemedemoColors.lightSecondary,);

static  ThemeData themeDataLight = ThemeData(textTheme: textTheme, colorScheme: light,);

static const ColorScheme dark = ColorScheme.dark(primary: ThemedemoColors.darkPrimary,onPrimary: ThemedemoColors.darkOnPrimary,primaryContainer: ThemedemoColors.darkPrimaryContainer,onPrimaryContainer: ThemedemoColors.darkOnPrimaryContainer,secondary: ThemedemoColors.darkSecondary,onSecondary: ThemedemoColors.darkOnSecondary,);

static  ThemeData themeDataDark = ThemeData(textTheme: textTheme, colorScheme: dark,);
}
}
```
</details>


# Metrics

parabeac_core keeps track of a few data points to help us understand usage. Although we do not collect any personal information, you can turn off metrics at any time by creating the environment variable `PB_METRICS = "false"`.


# What's Next?

If you want to see more project ideas or be connected to video examples, be sure to check out our [documentation](http://bit.ly/3YBsrWk) and [youtube channel](https://bit.ly/3YHX24F). If you'd like to talk with other users or our team, join our community on [Discord](https://bit.ly/3JajaPd).

## Integrate with GitHub!
### Enabling the design team to create pull requests
If you find viability in the code generation and want to support continuous design changes, create a free account on [Parabeac Cloud](http://bit.ly/3yyUxXO) where you can create an integration between Figma & the project Github repo.

## Stay up to Date
To stay up to date with our latest product releases, follow or subscribe to our 
- [Twitter](https://twitter.com/parabeac)
- [Youtube](https://bit.ly/3YHX24F)
- [Instagram](http://bit.ly/3Jz4kTS)
- [Dev.to](https://bit.ly/3Jen2in)
- [Newsletter](http://bit.ly/3Jz48E8)

## Influence this Project
If you want to influence the direction of this project, create an [issue](https://github.com/Parabeac/parabeac_core/issues/new/choose), fill out our [product survey](http://bit.ly/3w169Bm) or join our [Discord](https://discord.gg/qUrghes) to chat with the team and other users. We'd love to hear your feedback and ideas! ☆
