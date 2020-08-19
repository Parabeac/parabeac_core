# <center>Parabeac-Core

![Parabeac Logo](https://kindling-sketch.s3.amazonaws.com/Parabeac_Open-Source_README_Logo.png)


Parabeac-Core is an open-source repository that converts design files into Flutter code.

<a href="https://www.producthunt.com/posts/parabeac?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-parabeac" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=238516&theme=light" alt="Parabeac - Open-source design to Flutter converter | Product Hunt Embed" style="width: 250px; height: 54px;" width="250px" height="54px" /></a>

![google.com](https://img.shields.io/badge/license-MIT-blue.svg) [![Discord Chat](https://img.shields.io/discord/308323056592486420.svg)](https://discord.gg/qUrghes) [![https://twitter.com/parabeac?lang=en](https://img.shields.io/twitter/url/http/shields.io.svg?style=social&style=plastic)](https://twitter.com/parabeac?lang=en) [![Parabeac](https://circleci.com/gh/Parabeac/Parabeac-Core.svg?style=shield&circle-token=387c418592b3a47f3bb58caed7ff7d92afb8dd2e)](https://app.circleci.com/pipelines/github/Parabeac) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code_of_conduct.md)

# How it works
Parabeac-Core is essentially broken up into 3 pieces which you can see in the list or animation below. While most of the magic is in the interpretation engine, you can view more animations & information here.

 1. Convert design file into Parabeac design protocol
 2. [Interpretation Engine](https://github.com/Parabeac/parabeac-core/wiki/Parabeac-Interpretation-Engine-Overview)
 > Made up of the Visual, Layout, & Alignment generation services.
 3. Generate Flutter code 
  
![Parabeac High Level Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-high-level-animation2.gif)

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


# Get Started

Parabeac currently supports conversions from [Sketch](https://www.sketch.com) but is designed to support more platforms in the future.

### Dependencies

 - Dart
 - Flutter
 - Docker (*We're working on removing this*)

To test out a Sketch file feel free to download [this Sketch file](https://drive.google.com/file/d/10ZdTTUCFLrGJ-1oVmapWoH5HCe87Sz4e/view?usp=sharing)!

### Running the conversion

Follow these steps in order to run Parabeac Core on your local environment:
1. Clone PBCore repo in order to get the code on your machine
2. Make sure you have docker running
3. Within your terminal navigate to the sketch-to-svg folder within the Parabeac Core root directory. From here run `docker build -t sketch .`
4. Within the same sketch-to-svg directory run `docker run -p 5555:8081 -d sketch` 
 > :warning: **Steps 3 and 4 create a docker container in the background, we know this is not ideal and are working to remove this currently. To remove the docker instance run `docker ps` to identify the container Id and then `docker kill <containerId>` to remove it. Please see the Docker docs for more details.**
5. If you have any plugins make sure to put the plugins in the plugin folder
6. In your terminal move to the root PBCore directory and run:
``` bash
 $dart parabeac.dart -p <Absolute Path To Design File> -n <ProjectName> 
```


# Running the exported code
### Requirement(s)

- Download [Flutter](https://flutter.dev/docs/get-started/install)
- Traverse to main.dart
- Call the screen you want to view
- Execute `flutter run`

# How to contribute
Welcome! The best way to contribute to Parabeac is through pull requests, filing issues on Github, writing documentation & helping others in our Discord community. We are an early project, but like many other projects, helping with bugs that others have filed on Stack Overflow is extremely helpful. We recommend filing bugs & feature requests on the Github issue tracker. For more details make sure to check out our [wiki](https://github.com/Parabeac/open_source_prep/wiki).


# How to create & run Parabeac eggs
Parabeac eggs are essentially plugins that change the way a set of design elements are interpreted. A very simple example of this are 2 eggs that we created called NavBar & TabBar. Eggs are loaded into the project before the runtime of Parabeac-Core because unfortunately dart doesn't support [dynamic module loading](https://github.com/dart-lang/sdk/issues/10530).

To add a Parabeac egg, download the egg and add it to the `parabeac-core/plugins` folder.  When you run Parabeac-Core it will automatically grab & import the egg into the project.

# Upcoming & Known Issues

 - Plugin Duplication in the Plugin Service
 - Remove Docker Dependency
 - Support for Figma
 - Egg Marketplace
