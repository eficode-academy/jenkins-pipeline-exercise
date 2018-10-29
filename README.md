## Coding Assignment

While the purpose is to learn Jenkins, this will be a coding assignment. It is made just to give you some tangible code to work with:
Remember, this is not a programming exercise, but a Jenkins one; code is only there so you have something to build :)

This repository comes with a maven based java project from the start, but any language can be used. If you want to, just replace the java code with one of the other languages from (this repository)[https://github.com/emilybache/GildedRose-Refactoring-Kata].

The description of the application can be read [here](gildedrose.md), but is not necessary yet.

## 1. Create a job

* Go into your Jenkins server and click on the `New Item` button on the left.
* Name your new job "team# gilded rose" and choose `Pipeline` and click OK
* Head down to the `Pipeline` section of the job, and click on the "try sample pipeline" and choose `Hello world`
* Save and Build it.

The result should very well be that you have a blue (successful) build, and in the main view a text saying the following will appear:

> This Pipeline has run successfully, but does not define any stages. Please use the stage step to define some stages in this Pipeline.

We have to look into that now, *don't we?*

## 2. make stages

Click `configure` to reconfigure the pipeline.

Make three stages:

* `Preparation`
* `Build`
* `Results`

each of the states should have a sh part saying `echo "stage name"`

``` groovy
stage('Build') {
    // Run the sh part in here
}
```

Run this to see that it's working, and all three stages are present in the UI afterwards.

## 3. clone the source code

We want to clone down the repository

* Click `configure` in the job.
* Under the pipeline script, click on the link to `Pipeline Syntax`
* In the `Sample Step` choose `git: Git`
* Provide with the Bitbucket url of your repository
* Click the `Generate Pipeline Script` button and copy the output into your `Preparation` stage
* Click `Save` and then the `Build Now` button.
* Observe that there is a new build in the build history, that hopefully is blue.
* Click on it and click on `Console Output` to see something like this on your screen :

``` text
Started by user Admin
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/team2 guilded rose
[Pipeline] {
[Pipeline] stage
[Pipeline] { (prep)
[Pipeline] git
Cloning the remote Git repository
Cloning repository git@github.com:praqma-training/jenkins-pipeline-exercise.git
 > git init /var/lib/jenkins/workspace/team2 guilded rose # timeout=10
Fetching upstream changes from git@github.com:praqma-training/jenkins-pipeline-exercise.git
 > git --version # timeout=10
using GIT_SSH to set credentials 
 > git fetch --tags --progress git@github.com:praqma-training/jenkins-pipeline-exercise.git +refs/heads/*:refs/remotes/origin/*
 > git config remote.origin.url git@github.com:praqma-training/jenkins-pipeline-exercise.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url git@github.com:praqma-training/jenkins-pipeline-exercise.git # timeout=10
Fetching upstream changes from git@github.com:praqma-training/jenkins-pipeline-exercise.git
using GIT_SSH to set credentials 
 > git fetch --tags --progress git@github.com:praqma-training/jenkins-pipeline-exercise.git +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 244123f08edcdea633ac8d105fef3c947f1bf74c (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 244123f08edcdea633ac8d105fef3c947f1bf74c
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b master 244123f08edcdea633ac8d105fef3c947f1bf74c
Commit message: "first commit"
First time build. Skipping changelog.
```

## 4. Running a Gradle test and archiving

With `Preperation` now being done, we need to build the code and store the result.
For each of the bullit points, try to build it to make sure it works before moving to the next.

* In your `Build` stage,  execute `./gradlew clean test jar`
* In your `Results` stage, make jUnit display the results of `**/build/test-results/test/TEST-*.xml` (lookup jUnit in the pipeline syntax if needed)
* Also in your `Results` stage, `archive` the generated jar file in the `build/libs` folder

The archiving part can be verified by looking for a small blue arrow next to the build number in the overview. Make sure you get your Jar file with you there.

## 5. fixing Gilded Rose

Having your pipeline set up, now it is time to fix the software problem itself. Go back to [the gilded rose description to read about it](gildedrose.md)

## Xtra. Parallel and stashing

We also need to get the javadoc generated for the project.

Fortunately that can be done with a small `./gradlew javadoc` command.

* Create another stage called `Javadoc` where you execute the above command, and archive the result in the `build/docs/javadoc` folder.

Now we have two processes that actually can be run in parallel. The `build` and `javadoc` steps both take in the sourcecode and produces artifacts. So lets try to run them in parallel.

> This assignment is loosely formulated, so you need to [look things up yourself](https://jenkins.io/doc/pipeline/steps/) in order to complete this one

* Stash the source code cloned in `Preparation` and call it source
* `build` and `javadoc` steps needs to be included in a parallel step like the one below

```groovy
def builders = [
	"build": {
		node {}
	},
	"javadoc": {
	node {}
	}
]
stage('parallel'){
	parallel builders
}
```

* Unstash the source code in both stages, and perform the normal build steps
* Stash the results instead of archiving. Call them `jar` and `javadoc`
* Unstash them in the `Results` step in the end where you archive them.