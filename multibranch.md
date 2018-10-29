## 1. Multibranch pipeline

Having your pipeline as code is good, but having it under version control is better!

Fortuneatly, Jenkins makes this possible.

First of, go in and `Configure` your pipeline job, disabling any build triggers you might have set.

In the root of the repository there is a file called `Jenkinsfile`.

Right now it only has a dumb `hello world`

* Take your pipeline script, and replace the files content with it.
* Replace the git command with `checkout scm`. Multibranch knows where it gets triggered from.
* Push that back to the repository
* Create a new job of the `multibranch pipeline` type, and configure that to take from your repository.
* Trigger it to see that it works.
* Make a new branch locally, and push it up to GitHub to see that it automatically makes a new pipeline for you as well.
