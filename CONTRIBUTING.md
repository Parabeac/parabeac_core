# Contributing to Parbeac Core
First and foremost, thanks for considering contribution here at Parabeac Core! 

Below you'll find a set of guidelines around how to contribute here at Parabeac. These aren't rules set in stone, feel free to use your best guidance, and if you have any ideas feel to make a Pull Request and suggest changes. 

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
Everthing and everyone within this project is governed by the [Parabeac Code Of Conduct](https://github.com/Parabeac/Parabeac-Core/blob/master/CODE_OF_CONDUCT.md). By participating in this project you are expected to follow this code. If there are any questions or you see any unnacceptable behavior please contact support@parabeac.com.
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
* Docker
    * You don't need to have a Docker account but Docker does need to be running
#### Running PBCore
Follow these steps in order to run PBCore on your local environment:

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
#### How to get started
We're very happy to have any help we can get on our tool as those with the best feedback and input are usually the people using the tool. If you're looking to contribute there are a number of ways you can help:
* Feature Development 
* Triage
* Helping others

**Feature Development**
There are a number of new features and objectives we're hoping to reach and as a contributor, your work can help take us there. Please feel free to look over the Issues section of our GitHub and find any issues with the "Feature Work" Label. These issues are things we're looking to add going forward and are depending on the community to assist with. Feel free to join our [discord](https://discord.gg/mZTkke) and chat with us to determine the best course of action and to help with guidance. 
**Triage**
As more people use and more features get implemented on Parabeac Core more issues are created. One of the best, and most straight forward, ways to help is by helping us solve bugs. Within the Issues section of our GitHub, you'll find a number of issues that have tags denoting an issue area of relevance. It may be defined by the service or more specifically the node/widget that's being affected. By stepping in and solving these issues you'll be able to speed up our development of features going forward. 
**Helping Others**
One of the best ways to help is by not only by helping out in the code but also by helping out others that are having issues. Being a resource for support and guidance to developers that are having problems is the best way to keep the platform healthy and strong moving forward. You can do this by finding issues that have the "Help Wanted" label. Parabeac Advocates keep us going and allow us to drive the best changes we can.
#### Process
**Feature Development**
The following process should be kept in mind when doing feature development for Parabeac Core:
1. Be Kind and Courteous to Others 
2. When Branching and determining which feature to work on make sure to join #ParabeacHackers channel on our [discord](https://discord.gg/mZTkke), you'll need to request the contributor role, to ensure there isn't duplicated work. 
3. Make sure your Parabeac Core Developer Environment is configured to the correct version for the feature at hand.
4. Once you've finished working on the task, make a PR and reach out to one of the Discord Members that have the "Team" Role.
5. When performing a code review make sure all edge cases and test cases have been accounted for and that a Parabeac Team member is invited. If a Parabeac Team Member is not present during the code review, the PR will be automatically declined.
6. Keep talking and keep an open mind, the more teamwork the better.

**Triage**
1. Be Kind and Courteous to Others 
2. When picking which issues to work on make sure to join the #ParabeacHackers channel and the #ParabeacTriage channel on our [discord](https://discord.gg/mZTkke), you'll need to request the contributor role, to stay up to date on the latest progress and to ensure no duplicated work. 
3. Make sure your development environment is up to date with the correct version in the Issue and make sure to read the corresponding page associated with the task at hand. 
4. Once you've finished working on the task, make a PR and reach out to one of the Discord Members that have the "Team" Role.
5. When performing a code review make sure all edge cases and test cases have been accounted for and that a Parabeac Team member is invited. If a Parabeac Team Member is not present during the code review, the PR will be automatically declined.
6. Keep talking and keep an open mind, the more teamwork the better.

Contribution is the best way to make sure Parabeac Core keeps driving forward to its fullest potential and your contributions are the best way to get us there. 

## Parabeac Eggs 

### How Parabeac Does Plugins
At Parabeac we wanted to make sure developers could create plugins that changed the way code would be exported. To do this we built our tool to take in semantics that override the way Parabeac normally treats these elements. By creating an egg, developers can add new semantics and choose how those semantics are converted into code during the generation process. This allows for the most specific code generation without putting a large amount of work and hassle on the designers. 

To get started with Parabeac Eggs check out our [Parabeac Egg Template](https://github.com/Parabeac/parabeac-egg-template) or check out our _**git-based marketplace for templates**_. 
