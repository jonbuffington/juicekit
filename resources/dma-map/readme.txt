Interim Build Instructions
--------------------------

We have not automated building the dma-map.swc artifact. As a temporary step, we are committing artifact builds into version control and manually deploying the artifact as "dma-map". Committing the artifact to version control is not a long-term solution as it encourages unreproducible builds highly dependent on an unspecified build environment.

Step 1: Build the dma-map.swc file using Adobe Flash CS4.

Step 2: Deploy the dma-map.swc file into the shared repository using:

  $ mvn deploy:deploy-file -DgroupId=org.juicekit.resources -DartifactId=dma-map -Dversion=1.0 -Dpackaging=swc -Dfile=./dma-map.swc -Durl=http://sol:8081/nexus/content/repositories/releases/ -DrepositoryId=releases

Step 3 [optional]: Deploy the dma-map.swc file into your local repository using: 
  $ mvn install:install-file -DgroupId=org.juicekit.resources -DartifactId=dma-map -Dversion=1.0 -Dpackaging=swc -Dfile=./dma-map.swc
