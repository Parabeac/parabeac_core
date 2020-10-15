# Contributing to Parbeac Core
First and foremost, thanks for considering contribution here at Parabeac Core! 

Below you'll find a set of guidelines around how to contribute here at Parabeac. These aren't rules set in stone, feel free to use your best guidance, and if you have any ideas feel to make a Pull Request and suggest changes. We've also created an updated [Getting started with Contribution Guide](https://github.com/Parabeac/Parabeac-Core/wiki/Getting-Started-Contributor-Guide) on our wiki which we recommend for a brief overview and introduction to contributing here on Parabeac-Core.

> :partying_face: **Special Shout out if you're here for #HacktoberFest! Double your swag by contributing to Parabeac as one of our first 100 contributors!**

**Table Of Contents** 

[Code of Conduct](#code-of-conduct)

[Getting Started](#getting-started)
* [What is Parabeac Core](#what-is-parabeac-core)
* [Running Parabeac Core Locally](#running-parabeac-core-locally)
* [Understanding the Code Export](#understanding-the-code-export)

[How Can I Contribute](#how-can-i-contribute)
* [Filing Issues](#filing-issues)
* [Contributing Overview](#contributing-overview)

[Parabeac Eggs](#parabeac-eggs)

## Code of Conduct 
Everything and everyone within this project is governed by the [Parabeac Code Of Conduct](https://github.com/Parabeac/Parabeac-Core/blob/master/CODE_OF_CONDUCT.md). By participating in this project you are expected to follow this code. If there are any questions or you see any unacceptable behavior please contact support@parabeac.com.
## Getting Started

### What is Parabeac Core
Parabeac Core(or PBCore) is the tool that translates design files to flutter code. We do this by reading through the complex design file inner-workings to convert the UI elements within the design file to the appropriate Flutter Widgets. You can use this tool via our cli.

#### Our Commitment to Quality Code
We would rather be great at one thing than mediocre at many. With that mentality in mind we designed Parabeac Core to export code that not only can be used but also makes sense from the developer perspective. This aligns with our commitment to ensure developers have the most flexibility with the code they export, which is where Parabeac Eggs comes in. Parabeac Eggs, our name for custom defined Plug-ins, allow developers to define their own code exports and allow designers to be even more specific with the way they define the elements PBCore generates. 

#### Our Process
We've divided the code conversion and export process into 3 key phases:

* Design Phase (Parabeac Design Protocol & Parabeac Design Language)
* Conversion Phase (Parabeac Interpretation Engine)
* Exportation Phase (Parabeac Generation Service)

![Parabeac High Level Animation](https://kindling-sketch.s3.amazonaws.com/parabeac-high-level-animation.gif)

First, in the Design Phase, designers build their UI/UX elements within the design language of their choice (at the moment we only support sketch but have plans to shortly support other platforms like Figma). From here Designers can use the **_Parabeac Design Protocol_** to denote the elements they would like PBCore to generate. After the designs are ready to be converted they are handed to PBCore where we're able to convert the platform specific files into our intermediate design language: **_PBDL_**.

Next, in the Conversion Phase, the newly created PBDL code is sent to the Parabeac Interpretation Engine within PBCore. This then works to convert the PBDL into **_Parabeac Intermediate Nodes_**, the last form it will take before becoming Flutter Code. The Interpretation Engine is divided into the following three primary services:

* Parabeac Visual Service
* Parabeac Layout Service
* Parabeac Alignment Service
These services work in tandem to create the correct code structure before the elements are generated as Flutter Project. To learn more about these services inner workings look [here](https://github.com/Parabeac/parabeac-core/wiki/Parabeac-Interpretation-Engine-Overview).

Finally, in the Generation Phase, the Parabeac Intermediate Nodes are then converted into their final form: the **_Flutter Code_**. It is here that all the work put together over the last 2 Phases culminates into the final product as the generation service takes the correctly formatted Parabeac Intermediate Nodes and uses them to create the appropriate widgets.

With a clear picture of how each of the different phases within the Parabeac Export Process works let's take a look at what it takes to run Parabeac Core on your machine.

### Running Parabeac Core Locally
#### What You'll need
You'll need the following tools to run Parabeac Core, as well as a text editor or IDE of your choice (we recommend Visual Studio Code with the Dart and Flutter Extensions)
* Git
* Dart
    * Install latest version (If using Visual Studio Code simply install the Dart Extension)
* Flutter Latest version
    * Install latest version (If using Visual Studio Code simply install the Dart Extension)
* [node.js](https://nodejs.org/en/download/)
    * node.js is needed in order to run the Sketch-Asset-Converter.
    
#### Running PBCore
Follow these steps in order to run PBCore on your local environment:

1. Clone PBCore repo in order to get the code on your machine
2. If you have any plugins make sure to put the plugins in the plugin folder
3. In your terminal change directory to the root PBCore directory and run:
``` bash
 $dart parabeac.dart -p <Absolute Path To Design File> -n <ProjectName> 
```

And your done! Keep an eye on the terminal and your flutter project should ready to use in only a few moments. 

## How Can I Contribute
### Filiing Issues
#### What to do when you run into a problem
When filing an issue please make sure to have the most up to date version of parabeac core installed. Please see our FAQ Page for some of the larger known issues. 
#### Process
When filing an issue with Parabeac Core please follow these steps so we can resolve the problem as quickly as possible
1. Check the Issues section of our GitHub for any issues with the tag "bug" or "breaking issue" to make sure there isn't already an issue encompassing this problem thats already filed.
2. Please include the Parabeac Core version, link to Design File, and Code Exportation Snippet with Error Code (if applicable) within the issue.
3. Post said issue to our GitHub Issues section with the above stated information. 
4. Please make sure to include as much detail as possible so we can replicate the problem and find a solution as quickly as we can.
5. Keep an eye on any updates as we will try and get in touch with you as soon as possible. 
#### Recommended Next steps
While we're dedicated to our community we are always looking at ways to improve our tool and tech. Feel free to leave suggestions that you would like to see in the future, we're constantly working to improve our process and make things easier going forward. 

### Contributing Overview

#### Working on Issues

When looking to contribute there are a few simple steps you can follow to make sure the work you do is prioritized and beneficial to Parabeac-Core. The following Process is how we manage the contribution flow here at Parabeac:

1. Fork the Repository on Github.
2. Check the issues section on Github to see if an issue has already been made for the work to be completed:
* If it has, reach out to whoever was assigned said issue or, if that issue is not assigned to anyone contact us in the #dev_questions or #parabeac_hackers channels on our [Discord](https://discord.com/invite/qUrghes) to discuss taking the issue.
* If it has not, verify that the work is non-trivial and then create an issue on our Github issues section, make sure to reach out to the Team on [Discord](https://discord.com/invite/qUrghes) if this issue is pressing. You can put the tag proposal on the work you’re trying to do to help us identify and help with prioritization.
3. Create a branch off of the dev branch (if the issue is non-breaking) or the stable branch (if the issue is breaking) within your fork of the repo and implement your changes. Make sure to reach out to someone with the “Team” Role on our [Discord](https://discord.com/invite/qUrghes) to discuss your changes or ideas if you have any questions.
4. Submit this branch to the repo as a Pull Request.
5. Undergo code review. These reviews usually take the form of comments either on the PR on GitHub or within the Parabeac Core [Discord](https://discord.com/invite/qUrghes). More often than not a Parabeac Team Member or Committer will respond or comment to your PR within about 48 hours. If you haven’t heard from anyone by that time feel free to poke anyone on the Parabeac Team on our [Discord](https://discord.com/invite/qUrghes) (But especially our CEO @SiliconIvan).

Once you have the appropriate sign offs, your final reviewer should merge your code but if they haven’t feel free to merge it in.  

While following these steps should you have any issues don’t hesitate to reach out to anyone on Team Parabeac on our [Discord](https://discord.com/invite/qUrghes)

#### Pull Requests

Pull Requests are how you bring the work you’ve done back into the Parabeac-Core codebase. By submitting a Pull Request (or PR) you’re able to merge the changes you've made on your own branch into either dev or stable(Depending on the work done). All PR’s must be reviewed before they can be merged into the codebase in order to ensure that the work being done follows our guidelines and does what it says it will. Code review is usually done within Github itself but in special cases with complex work we do recommend talking with the team directly in our [Discord](https://discord.com/invite/qUrghes). For Additional insight, check out or [Tree Hygiene](https://github.com/Parabeac/Parabeac-Core/wiki/Tree-Hygiene) Page on our Wiki!

Contribution is the best way to make sure Parabeac Core keeps driving forward to its fullest potential and your contributions are the best way to get us there. 

## Parabeac Eggs 

### How Parabeac Does Plugins
At Parabeac we wanted to make sure developers could create plugins that changed the way code would be exported. To do this we built our tool to take in semantics that override the way Parabeac normally treats these elements. By creating an egg, developers can add new semantics and choose how those semantics are converted into code during the generation process. This allows for the most specific code generation without putting a large amount of work and hassle on the designers. 

To get started with Parabeac Eggs check out our [Parabeac Egg Template](https://github.com/Parabeac/parabeac-egg-template) or check out our _**git-based marketplace for templates**_. 
