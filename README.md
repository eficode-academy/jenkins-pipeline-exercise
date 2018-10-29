## Coding Assignment

While the purpose is to learn Jenkins, this will be a coding assignment. It is made just to give you some tangible code to work with:
Remember, this is not a programming exercise, but a Jenkins one; code is only there so you have something to build :)

This repository comes with a maven based java project from the start, but any language can be used. If you want to, just replace the java code with one of the other languages from (this repository)[https://github.com/emilybache/GildedRose-Refactoring-Kata].

## Gilded Rose Requirements Specification

Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a
prominent city run by a friendly innkeeper named Allison. We also buy and sell only the finest goods.
Unfortunately, our goods are constantly degrading in quality as they approach their sell by date. We
have a system in place that updates our inventory for us. It was developed by a no-nonsense type named
Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that
we can begin selling a new category of items. First an introduction to our system:

   - All items have a SellIn value which denotes the number of days we have to sell the item
   - All items have a Quality value which denotes how valuable the item is
   - At the end of each day our system lowers both values for every item

Pretty simple, right? Well this is where it gets interesting:

       - Once the sell by date has passed, Quality degrades twice as fast
       - The Quality of an item is never negative
       - "Aged Brie" actually increases in Quality the older it gets
       - The Quality of an item is never more than 50
       - "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
       - "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
	   Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
   	   Quality drops to 0 after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

   - "Conjured" items degrade in Quality twice as fast as normal items

Feel free to make any changes to the UpdateQuality method and add any new code as long as everything
still works correctly. However, do not alter the Item class or Items property as those belong to the
goblin in the corner who will insta-rage and one-shot you as he doesn't believe in shared code
ownership (you can make the UpdateQuality method and Items property static if you like, we'll cover
for you).

Just for clarification, an item can never have its Quality increase above 50, however "Sulfuras" is a
legendary item and as such its Quality is 80 and it never alters.

## 1. Create a job 


* Go into your Jenkins server and click on the `New Item` button on the left.
* Name your new job "team# gilded rose" and choose `Pipeline` and click OK
* Head down to the `Pipeline` section of the job, and click on the "try sample pipeline" and choose `Hello world`
* Save and Build it.

The result should very well be that you have a blue (succesful) build, and in the main view a text saying the following will appear:

> This Pipeline has run successfully, but does not define any stages. Please use the stage step to define some stages in this Pipeline.

We have to look into that now, *don't we?*

## 2. make stages:
Make three stages:

* `Preparation`
* `Build`
* `Results`

each of the states should have a sh part saying `echo "stagename"`

``` groovy
stage('Build') {
    // Run the sh part in here
}
```

Run this to see that it's working. The archiving part can be verified by looking for a small blue arrow next to the build number in the overview. Make sure you get your Jar file with you there.

## 2. clone the source code:

* Go into your Jenkins server and click on the `New Item` button on the left.
* Name your new job "gilded rose" and choose `Pipeline` and click OK
* Under `Source Code Management` choose git, and paste in your git clone URL for this project (Remember to use the _ssh_-url to _your repository_!).
* Choose the credentials that you have set up in Jenkins to auth it against GitHub.
* Click `Save` and then the `Build Now` button.
* Observe that there is a new build in the build history, that hopefully is blue.
* Clik on it and click on `Console Output` to see something like this on your screen :

## 2. Running a Gradle test

* `Preparation`: Clone the repository from git.
* `Build` : Executes `gradle clean test jar`
* `Results` :  Make jUnit display the results of `**/build/test-results/test/TEST-*.xml`, and archive the generated jar file in the `build/libs` folder

## 5. fixing Gilded Rose

Having your pipeline set up, now it is time to fix the software problem itself. Go back to [the main document and go through that](../README.md)


## Xtra. Parallel and stashing

We also need to get the javadoc generated for the project.

Fortunately that can be done with a small `mvn site` command.

* Create another stage called `Javadoc` where you execute the above command, and archive the result in the `target/javadoc` folder.
* Archive the `target/gildedrose-*.jar` as well

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