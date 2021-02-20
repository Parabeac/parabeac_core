# <center>Parabeac-Core

![Parabeac Logo](https://kindling-sketch.s3.amazonaws.com/1*_cqBeo8Gw2eAxdJOZ7TmmA.png)

Parabeac-Core is an open-source repository that converts design files into Flutter code.

<a href="https://www.producthunt.com/posts/parabeac?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-parabeac" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=238516&theme=light" alt="Parabeac - Open-source design to Flutter converter | Product Hunt Embed" style="width: 250px; height: 54px;" width="250px" height="54px" /></a>

![google.com](https://img.shields.io/badge/license-MIT-blue.svg) [![Discord Chat](https://img.shields.io/discord/308323056592486420.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/qUrghes) [![https://twitter.com/parabeac?lang=en](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&style=plastic)](https://twitter.com/parabeac?lang=en) [![Parabeac](https://circleci.com/gh/Parabeac/Parabeac-Core.svg?style=shield&circle-token=387c418592b3a47f3bb58caed7ff7d92afb8dd2e)](https://app.circleci.com/pipelines/github/Parabeac) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://github.com/Parabeac/Parabeac-Core/blob/master/CODE_OF_CONDUCT.md)

<h3>
  <a href="https://docs.parabeac.com/parabeac-designers/getting-started">Designer Protocol</a>
    <span> · </span>
  <a href="https://docs.parabeac.com/parabeac-developers/getting-started">Understanding the code export</a>
 <span> · </span>
  <a href="https://github.com/Parabeac/Parabeac-Core/wiki/Getting-Started-Contributor-Guide">Contribute</a>
 <span> · </span>
  <a href="https://discord.gg/qUrghes">Community</a>
  <span> · </span>
  <a href="https://dev.to/parabeac">Dev.to</a>
    <span> · </span>
  <a href="https://github.com/Parabeac/Parabeac-Core/wiki/Setting-up-a-debug-environment">Debugging</a>
</h3>

# Table of Contents
1. [What is Parabeac-Core](#what-is-parabeac-core)
2. [Get Started](#get-started)
    
    1. [Cloning the Repo](#cloning-the-repo)
    2. [Running the conversion](#running-the-conversion)
    3. [Metrics](#metrics)
    4. [Using State Management Configuration](#using-state-management-configuration)
3. [Running the exported Code](#running-the-exported-code)
4. [How to create & run Parabeac eggs](#how-to-create-&-run-parabeac-eggs)
5. [How it works](#how-it-works)
6. [How to contribute](#how-to-contribute)

# What is Parabeac-Core?
Parabeac-Core is an open-source repository that converts design files into Flutter code. The biggest challenge in code conversion is achieving quality code, but in a tool like this, there’s so much variability in what quality code should look like. So Parabeac-Core is built in a way not to promise quality code, but to be driven by the community so that you can configure & tweak to you or your teams liking. See our [Manifesto](https://github.com/Parabeac/Parabeac-Core/blob/stable/MANIFESTO.md). We welcome contributors to improve Parabeac-Core, create [Parabeac Eggs](https://github.com/Parabeac/parabeac-egg-template), & to join our [Discord](https://discord.com/invite/qUrghes) community!

# Get Started

If you have any trouble with getting Parabeac-Core running, check out this video! [![Parabeac-Core Getting Started](https://img.youtube.com/vi/e4CJgPMNCyo/0.jpg)](https://www.youtube.com/watch?v=e4CJgPMNCyo&feature=youtu.be)

Development on Windows is possible, too. However, [this requires some setup](WINDOWS_SETUP.md).

Parabeac-Core now supports both [Figma](https://www.figma.com/) and [Sketch](https://www.sketch.com)! We have plans to expand in the future as Parabeac-Core is built to support more platforms by design. 

### Dependencies

 - [Dart](https://dart.dev/get-dart)
 - [Flutter](https://flutter.dev/docs/get-started/install)
 - [node.js](https://nodejs.org/en/download/)
 - MacOS + Xcode or Android Studio

Need a file to test with? Feel free to download one of our sample design files below (Make sure to duplicate the Design to your account if you're using Figma):
* [Sketch](https://drive.google.com/file/d/10ZdTTUCFLrGJ-1oVmapWoH5HCe87Sz4e/view?usp=sharing)
* [Figma](https://www.figma.com/file/cmaAGe2hwCp7A5pmEQ2C80/parabeac_demo_fig) 

## Cloning the Repo
Because parabeac-core contains the Sketch-Asset-Converter submodule, it is easier to clone the repo using the following command:
```
git clone --recurse-submodules https://github.com/Parabeac/Parabeac-Core.git
```

If you have already cloned the repo without the submodule, simply run the following command which will add Sketch-Asset-Converter:
```
git submodule update --init
```

**_In order to pull new changes from the repository, run the following command to also update the submodule:_**

```
git pull --recurse-submodules
```

For more information about git submodules, click [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

## Running the conversion

We currently support both Sketch and Figma. See below for running the conversion for both Sketch and Figma.

### Sketch
Follow these steps in order to run Parabeac Core on your local environment:
1. Clone PBCore repo in order to get the code on your machine
2. If you have any plugins make sure to put the plugins in the plugin folder
3. In your terminal change directory to the root PBCore directory and run:

``` bash
 $ pub get
 $ dart parabeac.dart -p <Absolute Path To Design File> -n <ProjectName> 
```
### Figma
1. Clone PBCore repo in order to get the code on your machine
2. If you have any plugins make sure to put the plugins in the plugin folder
3. In your terminal change directory to the root PBCore directory and run:

``` bash
 $ pub get
 $ dart parabeac.dart -f <Figma File ID> -k <Figma API Key> -o <Absolute Path To Output Directory> 
```
If you're wondering about where to find your Figma File ID or Figma API Key Please Read Below:
#### Figma File ID and API Key
Since Figma operates from a cloud native approach we use the Figma File ID and a Figma User API Key in order to pull down your figma designs and run the conversion. Your Figma File ID is a unique ID used to identify your specific Figma File amoungst all other Figma Design Files. Your Figma API Key is a custom key assigned to your figma account that you generate in order to give Parabeac Core the ability to pull down your Figma File.
**In order to find your Figma File ID do the following:**
1. Go to your Figma Homepage at www.Figma.com
2. Select your Design File
3. Within your design File's URL is your Figma File ID. Simply take the value after Figma.com/file/<FigmaFileID>. So in the URL ```https://www.figma.com/file/zXXWPWb5wJXd0ImGUjEU1X/parabeac_demo_alt?node-id=0%3A156``` the Figma File ID is ```zXXWPWb5wJXd0ImGUjEU1X```

**In order to create a Figma API Token do the following:**
1. Go to your Figma Homepage at www.Figma.com
2. Navigate to your user Profile
3. Scroll Down to the "Create a new Personal Access Token"
4. Create a new Personal Access Token with the name Parabeac, you should then be prompted with your new API Key. Make sure to copy this as you wont be able to access it again after you click confirm. (It should look something like this: ```64522-a0e5509a-d5ce-47a8-880b-c295f9cb27ed```

## Metrics
Parabeac-core keeps track of how many times it is run. Although we do not collect any personal information, you can turn off metrics at any time by creating the environment variable `PB_METRICS = "false"`.

## Using State Management Configuration
![State Management](https://kindling-sketch.s3.amazonaws.com/PB_to_Flutter_with_State_management.png)

Parabeac-Core is able to export to different state management systems such as BLoC & Provider. Every developer team creates their Flutter apps differently, we added this support to help map the conversion in a more thoughtful & custom way. See [here for the release post](https://dev.to/parabeac/bloc-provider-riverpod-support-parabeac-core-v1-3-29pj) for more details!

To set the state management configuration, head over to edit `/Parabeac-Core/lib/configurations/configurations.json`. In here you'll see code like the following 

``` bash
 {
    "default": {
        "widgetStyle": "Material",
        "widgetType": "Stateless",
        "widgetSpacing": "Expanded",
        "layoutPrecedence" : ["column", "row", "stack"]
    },
    "state-management" : "None"
}
```

Here you can replace the `state-management` property to `bloc`, `provider`, or `riverpod`.

=======
You can learn how to easily create your own state management configuration in the [wiki](https://github.com/Parabeac/Parabeac-Core/wiki/How-to-Create-a-State-Management-Configuration), let us know if you're thinking about doing this and if you need any help!
=======
For sample Sketch and Figma files you can use to test state management, please see [Get Started](#get-started) 

You can learn how to easily create your own state management configuration in the [wiki](https://github.com/Parabeac/Parabeac-Core/wiki/How-to-Create-a-State-Management-Configuration), let us know if you're thinking about doing this and if you need any help!

=======
# Running the exported code
### Requirements
- Flutter
- Dart
### Steps
1. Make sure you have flutter installed correctly. (You can run ```flutter doctor``` within your terminal to easily check) 
2. Move to the Flutter Projects Root Directory 
> **If your Project utilizes Sketch Prototyping Skip to Step 5**
3. Within Main.dart import the main screen that you want the app to launch with from the screens folder
4. Next change the home property of the MaterialApp that is being returned in the Build Method to the name of the Screen imported in Step 3
5. Save Main.dart and Execute `flutter run` in your terminal

# How to create & run Parabeac eggs
Parabeac eggs are essentially plugins that change the way a set of design elements are interpreted. A very simple example of this are 2 eggs that we created called NavBar & TabBar. Eggs are loaded into the project before the runtime of Parabeac-Core because unfortunately dart doesn't support [dynamic module loading](https://github.com/dart-lang/sdk/issues/10530).

You can also create your own eggs! By using our [Parabeac Egg Template](https://github.com/Parabeac/parabeac-egg-template) you can quickly define your own semantics and corresponding code generation which allows for the most flexible and robust export customization possible. You can also upload your eggs to our **_git-based marketplace for templates_** to help support the community going forward.

To add a Parabeac egg, download the egg and add it to the `parabeac-core/plugins` folder.  When you run Parabeac-Core it will automatically grab & import the egg into the project.

# How it works
Parabeac-Core is essentially broken up into 3 pieces which you can see in the list or animation below. While most of the magic is in the interpretation engine, you can view more animations & information here.

 1. Convert design file into Parabeac design protocol
 2. [Interpretation Engine](https://github.com/Parabeac/parabeac-core/wiki/Parabeac-Interpretation-Engine-Overview)
 > Made up of the Visual, Layout, & Alignment generation services.
 3. Generate Flutter code 
  
![Parabeac High Level Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-high-level-animation2.gif)

## [Parabeac Design Protocol](https://docs.parabeac.com/)
Parabeac Design Protocol is our way of helping define UI/UX elements within Design Files for cleaner and more succinct code conversion. By adding naming-semantics to elements, symbols, and layer names to the design file, Parabeac-Core is able to identify specific UI elements & override interpretation & generation with a specific implementation.

## [Visual Generation Service](https://github.com/Parabeac/parabeac-core/wiki/Visual-Generation-Service)
These are mostly built by a one to one relationship from the Parabeac Design Language into Parabeac Intermediate Nodes. For example, a rectangle in the design language will simply convert to an `InheritedContainer`.

![Parabeac Visual Generation Service Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-visual-generation-service.gif)

## [Layout Generation Service](https://github.com/Parabeac/parabeac-core/wiki/Layout-Generation-Service)
This service is a bit more interesting, as we break down each group of nodes to be laid out by the layout service. The service takes the first 2 nodes compares them & generates a layout, we grab the next node, compare it to the layout & then the leaves if needed to and continuously traverse the rest of the layer into the laid out tree that we construct.

![Parabeac Layout Generation Service Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-layout-generation-service.gif)


## [Alignment Generation Service](https://github.com/Parabeac/parabeac-core/wiki/Alignment-Generation-Service)
In Flutter, there are only a couple ways to achieve alignment. We recognized the following as the most common:
* Flex-based layouts
* Padding/margin
* Positioning (Stacks)
* Alignment (Container/Single Child/Visual Node)

Depending on the type of layout to add alignment to we have various services to take the nodes in and apply the alignment information needed.

![Parabeac Alignment Generation Service Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-alignment-generation-service2.gif)

# How to contribute
Welcome! The best way to contribute to Parabeac is through pull requests, filing issues on Github, writing documentation & helping others in our Discord community. We are an early project, but like many other projects, helping with bugs that others have filed on Stack Overflow is extremely helpful. We recommend filing bugs & feature requests on the Github issue tracker. For more details make sure to check out our [wiki](https://github.com/Parabeac/Parabeac-Core/wiki).

# Upcoming & Known Issues

 - Plugin Duplication in the Plugin Service
 - Egg Marketplace
