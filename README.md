# Final Project K8s

[deployment-architecture]: https://i.imgur.com/pk2Slok.png

<!--TOC_START-->
## Contents
- [Overview](#overview)
- [Requirements](#requirements)
- [Tutorial](#tutorial)
    - [Pushing to your own GitHub repository](#pushing-to-your-own-github-repository)
    - [Setting up GitHub WebHook](#setting-up-github-webhook)
    - [Setting up the Jenkins Pipeline](#setting-up-the-jenkins-pipeline)


<!--TOC_END-->

## Overview

This repository is a solution for deploying the spring-petclinic application onto AWS EKS.
Before getting started here, make sure you have deployed the necessary infrastructure on AWS.

You can find the files and guide to do so here:

https://gitlab.com/qacdevops/final_project_aws


This guide walks you through uploading the application to your own repository, ready to be deployed as part of a CI/CD pipeline using Jenkins.

## Requirements

This guide will assume you have an existing Docker account (to use Dockerhub as the image repository) and a Github account (to use as the source code repository). We will configure the Jenkins server to pull from those two locations.

## Tutorial

This tutorial will guide you through deploying your Kubernetes application. The plan is to deploy the architecture as shown:

![deployment-architecture][deployment-architecture]

We will get started by making sure we have the project in our own repository, so your Jenkins application can listen to changes taking place in your 
repository and deploy the application.

### Pushing to your own GitHub repository

This section will cover how to clone from a repository and upload to your own without forking.

1. Clone this repository in a safe, and organised location.

```bash
git clone <https repository id>
```

2. Navigate into the folder which you just cloned. List the contents of this folder:

```bash
ls -la
```

This command will show you all the files, folders with their permissions and information.

You should see the **.git** folder. Remove this folder:

```bash
rm -rf .git
```

3. Create a new repository on Github. This will be the repository that will trigger the Jenkins pipeline.

4. After removing the `.git` folder, git no longer recognises this directory as a repository. Now we are able to re-initialise and push to your new repository.

5. Make changes to the code, as this code has been set up to use "qa" dockerhub repository. Changes need to be made to the shell scripts under scripts/ and pods/directory, where it should be referring to your own dockerhub username account.

**Note**: Make sure you are running the git commands inside the folder you have just cloned.

Run the following commands one by one (replace `<git repo link>` with the link to your new repository):

```bash
git init
git add .
git commit -m "initial commit"
git remote add origin <git repo link>
git push -u origin master
```

Your repository should now be ready for use.

**WARNING**: There are potential errors that could be thrown when you attempt to push your application. They may suggest commands such as:

- git config --global user.email "your@email.com"
- git config --global user.name "yourname"
- git push --set-upstream <remote><branch>

The first two are thrown if you had not yet authenticated your command line with Github. If so, run the commands suggested (with your own details of course) to authenticate.

The last command is GitHub telling you that it does not know where to push. If you followed the instructions correctly, you should be able to run to fix:

```bash
git push --set-upstream origin master
```

Now that this codebase is in your own repository, you can set it up to make your Jenkins server listen to changes being made, so it can auto
trigger the build process. 

### Setting up GitHub WebHook

This section will cover setting up a GitHub webhook for a Jenkins pipeline.

1. Go to your repository's settings (on Github).
2. On the left pane, click on webhooks.
3. Click the button, *Add Webhook*. Since this is a change in the repository setting, you will be prompted to log in to your GitHub account again.
4. The *Payload URL* should be the ip address and location of the Jenkins instance. This should be `http:(jenkins-machine-ip-address):(jenkins-machine-port-number)/github-webhook/`. Make sure the final `/` is included, otherwise it will not work.
5. The *Content type* is a dropdown and should be changed to **application/json**.
6. Leave the rest as default, and click on **Add webhook**.

Everyhting is now set up from the repository's perspective. Now Jenkins need to be set up, so it knows where the repository exists.

### Setting up the Jenkins Pipeline

This section will cover setting up Jenkins to listen to your repository such that changes to the specified branch will trigger the pipeline.

1. Navigate to the Jenkins homepage. If this is the first time, you will not see any existing projects. On the left pane, click on "New Item".
2. Provide a name for your project and select **Pipeline**. This means you want to orchestrate the deployment using a Jenkinsfile. Proceed to the next page.
3. Under the *General* tab, check "GitHub project", and paste in your repository web browser url, this is the one that does not end with `.git`.
4. Under *Build Triggers*, check **"Github hook trigger ..."**
5. Under *Source Code Management* check **Git**. This will provide more options to configure for Jenkins when cloning the project.
6. The *Repository URL* should be the url used to when you clone the repository. This is the same as the web url but with a .git at the end.
7. Credentials are not needed as Jenkins should be able to clone a repository down that is public. If the repository is private or hosted in a private version control service such as AWS CodeCommit, then you should provide the credentials necessary.
8. Everything else can be left as default, and you can proceed to apply and save.

Since this is a new project, you might need to manually press the *build now* button. You would normally push to your master branch for the repository to trigger a build.

Jenkins is now listening to the `master` branch of the repository for changes and will execute the build defined in the **Jenkinsfile**.




