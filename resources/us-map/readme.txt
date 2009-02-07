Interim Build Instructions
--------------------------

We have not automated building the us-map.swc artifact. As a temporary step, we are committing artifact builds into version control and manually deploying the artifact as "us-map". Committing the artifact to version control is not a long-term solution as it encourages unreproducible builds highly dependent on an unspecified build environment.

Step 1: Build the us-map.swc file using Adobe Flash CS3.

Step 2: Deploy the us-map.swc file into the shared repository using:

  $ mvn deploy:deploy-file -DgroupId=org.juicekit.resources -DartifactId=us-map -Dversion=1.0 -Dpackaging=swc -Dfile=./us-map.swc -Durl=[url] -DrepositoryId=[id]

Step 3 [optional]: Deploy the us-map.swc file into your local repository using: 
  $ mvn install:install-file -DgroupId=org.juicekit.resources -DartifactId=us-map -Dversion=1.0 -Dpackaging=swc -Dfile=./us-map.swc
