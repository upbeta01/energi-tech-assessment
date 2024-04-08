# Question 1

**Docker Whale:** Write a Dockerfile to run Energi Node in a container. It should somehow verify the checksum of the downloaded release (there's no need to build the project), run as a normal user, it should run the client, and print its output to the console (https://wiki.energi.world/en/downloads/core-node).

The build should be security conscious, and ideally pass a container image security test such as ECR, or Trivy.

# Answer

The `energi-core.dockerfile` contains the build procedure to run the release binaries in a container environment. The file supports dynamic declaration of variable so it knows which of the following binaries to support; _abigen_, _bootnode_, _clef_, _energi3_, _evm_, _rlpdumpa_.
```
sudo docker build -t energi3-v1.1.7:0.1 --build-arg BINARY=energi3 -f energi-core.dockerfile .
```

To run the image, specify the binary and param (optional).
```
sudo docker run --name energi -e "BINARY=energi3" -e "PARAM=--nousb" energi3-v1.1.7:0.1
```