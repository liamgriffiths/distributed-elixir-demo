# Distributed Elixir Demo

Hi, I made this little demo to show an example of how to setup a distributed elixir
app that you can run on a local Kubernetes cluster.

Some of the things in this demo:
* Setting up a simple websocket-based Phoenix app
* Creating releases with Distillery
* Packaging a release inside a Docker container
* Running containers inside a Kubernetes cluster in distributed mode

## How to run this thing

### Download this stuff first

I'm using OSX, so the installation instructions are based on this.

```
# Make sure you have elixir installed
$ brew install elixir

# Install Docker
$ brew install docker
# (or just download the installer from the website)

# Install VirtualBox
# (download the installer from the website)

# Install Minikube (mini kubernetes that runs on VirtualBox)
$ brew cask install minikube

# Install kubectl (command line tool to interact with Kubernetes)
$ brew install kubectl

# Clone this repo
$ git clone <this-repo>
```

### Running the Phoenix app on the OSX host

Make sure the app works by running it on the OSX first.

```
# Install elixir app dependencies
$ mix deps.get

# Run the app
$ mix phx.server

# See that it works in the browser
$ open http://localhost:4000
```

### Creating a Distillery release

For this project I'm using [distillery]() to create an elixir release. A release in
this sense is a single, deployable binary that contains all the compiled app code as
well as the Erlang runtime required to run it. Distillery automates this process and
gives us a simple command line tool to do it.

```
# Create a release with distiller
$ mix release

# Run the release it produced
$ _build/dev/rel/hello/bin/hello foreground

# See that it works in the browser
$ open http://localhost:4000
```

### Building a Distillery release in a Docker container

If we want to deploy this release to a Linux machine, we'll need to make sure that we
also _create_ our release in the same enviornment. This is because the release is
built using various system dependencies that may be wildly different on OSX than your
deployment target. We can use a Docker container to help us here. The trick here is
to use the Docker container to describe a consistent environment that we will create
our release in - which will be the same environment we eventually run our code in.

I used this [Dockerfile]() that I got from Google to create a docker image that
creates our distillery release and then uses that compiled code to expose an
http port and run the app.

```
# Create an image using the Dockerfile
$ docker build --no-cache -t hello .

# Run the docker image we just created like this
$ docker run -it --rm -p 8080:8080 hello

# See that it works in a browser
$ open http://localhost:8080

# Stop the running container (lookup the container id, then kill it)
$ docker ps
$ docker kill <container-id>
```

### Running the container in Minikube

Running a container one at a time is pretty cool, but our goal here is to run many
containers with our app. This is where Kubernetes comes in. Using Minikube we can
play around with a local Kubernetes cluster. In addition, to just running mulitple
containerized instances of our app we would also like to let our app instances to
be able to "talk" to each other and share resources. This example repo is configured
to allow us to do this using a few tricks that I'll describe in detail later on. But
for now, let's see what it looks like to run it.

```
# Start up Minikube (takes a minute or two)
$ minikube start

# See that we're up and running the cluster
$ minikube status

# Let Minikube talk to our local Docker daemon
$ eval $(minikube docker-env)

# Build another image for our app (like we did before)
$ docker build --no-cache -t hello .

# Tag the image with a name we can use in our Kubernetes config
$ docker tag hello:latest liamgriffiths/hello:17

# Edit ./k8s/hello/deployment and change the "image" entry to be the new tag we just used
# (in this example it is "liamgriffiths/hello:17)

# Apply our kubernetes config to the cluster (more on this later)
$ ./apply-hello

# Checkout this awesome built-in dashboard to inspect it (see namespace "hello")
$ minikube dashboard

# Open the our kubernetes "service" in a web browser
$ minikube service service --namespace=hello

# Trash our Minikube cluster (if you don't want it anymore)
$ minikube delete
```

## How this all works

### Phoenix websockets, channels, Elixir processes

... tbd ...

### Distributed Elixir/Erlang

... tbd ...

### Kubernetes configuration

... tbd ...


## Thanks

... tbd ...

Some blogs and tutorials that helped me out
* https://cloud.google.com/community/tutorials/elixir-phoenix-on-kubernetes-google-container-engine
