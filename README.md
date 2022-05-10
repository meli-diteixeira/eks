
Everything you need to request on [shield.adminml.com](https://shield.adminml.com/login "shield.adminml.com")
to provision your EKS cluster with `CloudController`.

# CREATE SECURITY GROUP - CONTROL PLANE

Before starting the Security Group requests for your EKS cluster in SHIELD they need to be created, 
we will use [CloudController](https://cloudcontroller.furycloud.io/ "CloudController") to build them, 
but you can build directly in your AWS management console too.
For more information [click here](https://docs.google.com/document/d/1FokPaCBKm7ifW-h71bktuTvbR6hgeGfN4A_uzuTt5Y8/edit?ts=5e8dece5 "click here").

you need to create a new stack in your CloudController repository 
containing the files `sg-cluster-control-plane.tf` and `sg-cluster-worker-node.tf`, 
containing the following instructions

Secutiry group cluster control plane terraform file: `sg-cluster-control-plane.tf`

define the variable `${CLUSTER-NAME}` with the name of your cluster, and `${VPC_ID}` with your AWS VPC ID.

```terraform
resource "aws_security_group" "sg-cluster-control-plane" {
  name          = "${CLUSTER-NAME}-sg-cluster-control-plane"
  vpc_id        = "${VPC_ID}"
  description   = "Cluster communication with worker nodes"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${CLUSTER-NAME}-sg-cluster-control-plane"
  }
}
```

Secutiry group worker nodes terraform file: `sg-cluster-worker-node.tf`

define the variable `${CLUSTER-NAME}` with the name of your cluster, and `${VPC_ID}` with your AWS VPC ID.

```terraform
resource "aws_security_group" "sg-cluster-worker-node" {
  name          = "${CLUSTER-NAME}-sg-cluster-worker-node"
  vpc_id        = "${VPC_ID}"
  description   = "Security group for all nodes in the cluster"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
  tags = map(
    "Name", "${CLUSTER-NAME}-sg-cluster-worker-node",
    "kubernetes.io/cluster/${CLUSTER-NAME}", "shared",
  )
}
```

# IMPORTANT NOTES!

For `VPC` and all `SUBNETES` used on this `eks-cluster-provisioning`, it is `NECESSARY` add some tags on `AWS` to ensure 
this communication between cluster resources:

## VPC TAGS:

```terraform
    key   = kubernetes.io/cluster/"${cluster-name}"
    value = shared
```

## SUBNETS TAGS:

```terraform
    key   = kubernetes.io/cluster/"${cluster-name}"
    value = shared
```

For more detailed information on "how to" build a stack using CloudController [click here](http://furydocs.io/cloudcontroller/2021.2.12/guide/#/iac/stacks-flujo-ci-cd "click here").

# ROLES - SECURITY GROUP CONTROL PLANE

To create roles we need to request through tickets in [SHIELD](https://shield.adminml.com/login "SHIELD"). 
Please follow the information below for any tickets you need to request.

Information about variables used in this document:

```yml
CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID: Information about the ID of your previously created security group
CLUSTER-NAME-sg-cluster-worker-node-ID: Information about the ID of your previously created security group
```

## Allow workstation to communicate with the cluster API Server
SHIELD_TICKET_1.0: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID}
PROTOCOLO: TCP
PUERTOS: 443
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID}
JUSTIFICATIÓN: Allow workstation to communicate with the cluster API Server
```

## Allow Pods to communicate with the cluster API Server
SHIELD_TICKET_1.1: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID}
PROTOCOLO: TCP
PUERTOS: 443
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
JUSTIFICATIÓN: Allow Pods to communicate with the cluster API Server
```

## Allow cluster control plane to communicate with pods running extension API Servers on port 443
SHIELD_TICKET_1.2: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
PROTOCOLO: TCP
PUERTOS: 443
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
JUSTIFICATIÓN: Allow Pods to communicate with the cluster API Server
```

# ROLES - SECURITY GROUP WORKER-NODES

## Allow nodes to communicate with each other
SHIELD_TICKET_2.0: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
PROTOCOLO: TCP
PUERTOS: 0-65535
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
JUSTIFICATIÓN: Allow nodes to communicate with each other
```

## Allow Worker Kubelets and pods receive communication from the cluster control plane
SHIELD_TICKET_2.1: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
PROTOCOLO: TCP
PUERTOS: 1025-65535
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID}
JUSTIFICATIÓN: Allow Worker Kubelets and pods receive communication from the cluster control plane
```

## Allow Pods to communicate with the cluster API Server
SHIELD_TICKET_2.2: `AWS - Security Group (autom)`

```yml
LINK: https://shield.adminml.com/requests/create?search=aws
TICKET_NAME: AWS - Security Group (autom)
SG_ID: ${CLUSTER-NAME-SG-CLUSTER-WORKER-NODE-ID}
PROTOCOLO: TCP
PUERTOS: 443
SECURITY_GROUP_ORIGEN: ${CLUSTER-NAME-SG-CLUSTER-CONTROL-PLANE-ID}
JUSTIFICATIÓN: Allow Pods to communicate with the cluster API Server
```

# VARIABLES - CREATE CLUSTER EKS

After receiving all the Roles and Security Groups creation information sent by [shield.adminml.com](https://shield.adminml.com/login "shield.adminml.com"),
edit the `terraform.tfvars` file, change all values pasting yours:

```terraform
# Enter your cluster EKS name.
cluster-name = "{CLUSTER_NAME}"

# Enther your mercadolibre network user.
meli-user = "{YOUR_MELI_USER}"

# Enter the ControlPlane ARN Role.
role-eks-cluster-control-plane = "arn:aws:iam::{AWS_ACCOUNT_ID}:role/role-eks-cluster-control-plane"

#  Enter the WorkerNode ARN Role.
role-eks-cluster-worker-node = "arn:aws:iam::{AWS_ACCOUNT_ID}:role/role-eks-cluster-worker-node"

# Enter the ARN kubectl-role-team.
kubectl-role-team = "arn:aws:iam::${AWS_ACCOUNT_ID}:role/CrossAccountManager-${TEAM_NAME}"

# Enter the name of the VPC created previously, if it does not exist, it will be necessary to create one,
# This information is case sensitive, enter the resource name as
# described in the AWS console (Networking & Content Delivery > VPC > Your VPCs) or in CloudController Summary Account.
vpc-id = "{EXISTENT_VPC_ID}"
private-subnets = ["subnet-00000000", "subnet-00000000"]
sg-cluster-control-plane = "sg-34634564-id"
sg-cluster-worker-node = "sg-sdfvesg35-id"

# Enter the instance type EC2 and volume type/size (Worker Nodes)
instance-type = "{INSTANCE_TYPE}"
volume-type = "gp2"
volume-size = "40"

# Enter the minimum maximum value of instances to be created initially by autoscaling and
# max number of instances in this group that it can expand if necessary
min-size = 3
max-size = 6

# Enter the EC2 instance access key (Worker Nodes)
# Key to be used for instance access
# EC2 (WORKER-NODES), it must be created first.
key-name = "{KEY_PAIR_NAME}"
```

# CLUSTER MANAGEMENT

Install and configure aws bastion cli first (if you don't have it), then install kubectl. 

1. [aws-bastion-cli](https://docs.google.com/document/d/1KsFrvP47YSlJPwvpI4lcjy1xckq4UK5PtjhrmuV-YX0/edit "aws-bastion-cli")
2. [kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html "kubectl")

aws-bastion-cli auth:

```sh
$ aws-bastion-cli

Ingrese el nombre del rol a utilizar:
 CrossAccountManager-<team_name>
 
Ingrese el NUMERO de cuenta a la que desea saltar:
<account_id>

Usuario de red:
<meli-user>
Password: **********
```

Use aws-cli to update your kubectl context pointing to your eks-cluster:

```sh
 aws eks --region <region-code> update-kubeconfig --name <cluster_name> --role-arn arn:aws:iam::<account_id>:role/CrossAccountManager-<team_name>
```

Validate the cluster information:

```sh
 kubectl cluster-info
```

List cluster worker-nodes:

```sh
 kubectl get nodes
```

List services on default namespace:

```sh
 kubectl get svc
```

List pods on default namespace:

```sh
 kubectl get pod
```

# CREATING DEPLOYMENT EXAMPLE

```sh
 kubectl create deployment nginx-example --image=nginx --replicas=2 --port=80
```

# EXPOSING DEPLOYMENT LOADBALANCER ON PORT 80

```sh
 kubectl expose deployment/nginx-example --type="NodePort" --port=80
```

# NGINX CREATED RESOURCES TEST

```sh
 kubectl port-forward svc/nginx 8080:80 &
```

Now you can perform a local access test and check if the application started correctly in http://127.0.0.1:8080/ 

![image](https://user-images.githubusercontent.com/79920854/129096834-fe81973b-235c-41b0-b75f-4e0d29656ee0.png)

