# Software development tool lab examples

Small examples for practicing the Nagios/Git and software-tool experiments. Clone
this repository, then run each example from the repository root as shown below.
Install only the prerequisites for the experiment you are practicing.

## Prerequisites

- Git experiment: Git
- Nagios and Docker experiments: Docker Engine and the Docker Compose plugin
- Maven experiments: JDK 17+ and Maven 3.8+
- Jenkins experiments: a Jenkins controller and an agent with Git and Maven
  (for the Java pipeline); create a Pipeline job pointing at the selected
  `Jenkinsfile`
- Kubernetes experiment: `kubectl` and access to a running cluster
- AWS experiment: AWS CLI v2 and credentials configured for an AWS account with
  permission to create and delete S3 buckets and objects

These are deliberately small lab starters, not production deployments. Jenkins,
Kubernetes, and AWS still require their respective service/account to be set up.

## Question 3: Nagios or Git

### Nagios: view the built-in localhost checks

```sh
docker compose -f labs/nagios/compose.yaml up -d
```

Open <http://localhost:8080/nagios/> and sign in with the image's documented
demo credentials: `nagiosadmin` / `nagios`. View **Hosts** and **Services** to
see the localhost checks. This publishes the web UI only on your own machine.
Stop and remove the container with:

```sh
docker compose -f labs/nagios/compose.yaml down
```

The demo image is maintained by a third party and downloads from Docker Hub.
Change its demo password before exposing it beyond localhost; do not use it as
a production monitoring server.

### Git: common commands in a disposable repository

```sh
sh labs/git/git-demo.sh
```

The script creates a temporary repository, demonstrates add/commit, branching,
merging, and history inspection, then removes the temporary directory. It does
not modify this checkout.

## Question 4: other tools

### Maven Java application

```sh
cd labs/maven-java
mvn test package
java -jar target/hello-java-1.0.0.jar
cd ../..
```

Expected output: `Hello, world!`

### Maven web application

```sh
cd labs/maven-web
mvn jetty:run
```

Open <http://localhost:8080/>. Press Ctrl-C to stop the server, then return to
the repository root with `cd ../..`.

### Jenkins Java, web, and script pipelines

Create a Jenkins **Pipeline** job for each experiment and set its Pipeline
script path to the corresponding file below. Point the job at this repository
so the checkout contains the `labs/` directory.

- Java build and test: `labs/jenkins/java.Jenkinsfile` (agent must have JDK 17+
  and Maven installed)
- Web artifact: `labs/jenkins/web.Jenkinsfile` (archives the sample HTML)
- Basic scripted stages: `labs/jenkins/script.Jenkinsfile`

Run **Build Now** and inspect the stage view and console output.

### Kubernetes: scale an Nginx deployment

```sh
kubectl apply -f labs/kubernetes/nginx.yaml
kubectl get deployments,pods,services
kubectl scale deployment/hello-nginx --replicas=3
kubectl get deployment hello-nginx
kubectl port-forward service/hello-nginx 8080:80
```

Open <http://localhost:8080/> while port-forwarding. Press Ctrl-C to stop the
forward, then clean up:

```sh
kubectl delete -f labs/kubernetes/nginx.yaml
```

### Docker: single container

```sh
docker build -t hello-site labs/docker/single
docker run --rm -p 8080:80 hello-site
```

Open <http://localhost:8080/>. Press Ctrl-C to stop.

### Docker: two containers

```sh
docker compose -f labs/docker/multi/compose.yaml up --build
```

Open <http://localhost:8080/> to see Nginx proxy a request to the Python
backend. Press Ctrl-C, then remove the containers with:

```sh
docker compose -f labs/docker/multi/compose.yaml down
```

### AWS: private S3 bucket and object

Choose a globally unique bucket name beginning with `se-lab-`. Then run:

```sh
sh labs/aws/s3-demo.sh create se-lab-yourname-unique-suffix
```

The script uploads and lists a small text file. It does not enable public
access. Remove the demo object and delete the now-empty lab bucket when finished:

```sh
sh labs/aws/s3-demo.sh delete se-lab-yourname-unique-suffix
```

AWS usage may incur charges. Use a disposable bucket name and confirm the name
before running `delete`; that command refuses names without the `se-lab-`
prefix and does not recursively remove other objects.
