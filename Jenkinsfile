
node {
  //cleanWs()

    stage('Preparation') { // for display purposes
        // Get some code from a GitHub repository

    checkout([$class: 'GitSCM', branches: [[name: '*/ready/**']], 
    doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CleanBeforeCheckout'], 
    pretestedIntegration(gitIntegrationStrategy: accumulated(), integrationBranch: 'master', 
    repoName: 'origin')], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'sofusalbertsen', 
    url: 'git@github.com:sofusalbertsen/jenkins-workshop.git']]])
    
    stash name: "repo", includes: "**", useDefaultExcludes: false
    }
    
    stage('Build') {
        // Run the maven build
        if (isUnix()) {
           sh 'docker run -i -u "$(id -u):$(id -g)" -v maven-repo:/root/.m2 -v $PWD:/usr/src/mymaven -w /usr/src/mymaven --rm maven:3-jdk-8 mvn clean test install'
            //sh "mvn -Dmaven.test.failure.ignore clean package"
            stash name: "build-result", includes: "target/**"
  
        }
    }
    stage('Push'){
        pretestedIntegrationPublisher()

        deleteDir()
    }
  }
  node {  
    stage('Javadoc'){
          unstash 'repo'
          unstash 'build-result'

          sh 'docker run -u "$(id -u):$(id -g)" -v maven-repo:/root/.m2 -v $PWD:/usr/src/mymaven -w /usr/src/mymaven --rm maven:3-jdk-8 mvn site'
    }
    stage('Results') {
            junit '**/target/surefire-reports/TEST-*.xml'
            archiveArtifacts 'target/*.jar'
            archiveArtifacts 'target/site/**'
    }
}