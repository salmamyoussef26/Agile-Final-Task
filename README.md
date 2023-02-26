# Task Steps:
1. Building cloud Infrastructure using Terraform - (GCP is the used cloud provider)
2. Install jenkins on private GKE cluster.
3. Create jenkins pipeline using jenkins on GKE cluster to deploy a backend application.
--------------------------------------------------------
# Hierarchy of GCP infrastructure using terraform:
```
├── firewall
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── gke
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── main.tf
├── nat_gateway
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── service_account
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── subnet
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── vm
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
└── vpc
    ├── main.tf
    ├── output.tf
    └── variables.tf
 ```
---------------
# Install jenkins on private GKE cluster:
1. Create custom jenkins image contains docker-cli & kubectl to make jenkins use kubectl and docker-cli commands while building the pipeline

2. Build the image and push on my dockerhub.

3. create a namespace called jenkins to deploy the jenkins on it and switch context to it.

4. Apply a daemonset to install docker on the worker node to mount the docker daemon on the jenkins pod later.

5. Make a serviceAccount to give the jenkins the permissions to build and deploy the application.

6. Make a jenkins deployment using the previous custom image.

7. Expose the jenkins deployment using the LoadBalancer service.

![Screenshot from 2023-02-27 00-16-08](https://user-images.githubusercontent.com/110994084/221440754-96d2a0dc-35e8-4186-9d9a-567850192972.png)

![Screenshot from 2023-02-27 00-13-43](https://user-images.githubusercontent.com/110994084/221440785-69f57417-806c-4fed-bde5-29d090b5f75f.png)




---------------------------
# Create jenkins pipeline using jenkins on GKE cluster to deploy a backend application:
 1. put the external ip of the jenkins service:8080 to access jenkins.
 
 2. configure the jenkins credential:
     - add my docker hub username, password and ID
 
 3. create a pipeline contains 2 stages: 
 - CI:
 1. create namespace called app 
 2. build the application image.
 3. push the image on mu dockerhub using the previouse credentials.
 - CD:
 1. apply the redis deployment .yaml file.
 2. apply the redis service .yaml file.
 3. apply application deployment .yaml file
 4. apply application service .yaml file
 
 
 ![Screenshot from 2023-02-27 00-18-11](https://user-images.githubusercontent.com/110994084/221440831-03559616-beb9-4dd0-b68c-74a492bf162e.png)

![Screenshot from 2023-02-27 00-18-57](https://user-images.githubusercontent.com/110994084/221440851-d3a6ea7a-99b9-4238-99bc-03f271a3e46f.png)


