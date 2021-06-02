# RELEASE CUT: Release-1.0

# 5G Core with RAN + UE simulator deployment on Red Hat Openshift with Service Mesh<br>

Background: <br>
(a) https://open5gs.org/ <br>
(b) https://github.com/open5gs/open5gs <br>
(c) https://github.com/aligungr/UERANSIM <br>

----
Prerequisites: <br>
(i) [OCP with OSM installed and configured](https://docs.openshift.com/container-platform/4.7/service_mesh/v1x/installing-ossm.html)<br>
(ii) [Enable SCTP on OCP Reference](https://docs.openshift.com/container-platform/4.7/networking/using-sctp.html#nw-sctp-enabling_using-sctp)
```
oc create -f enablesctp.yaml

```
Wait for machine config to be applied on all worker nodes and all worker nodes come back in to ready state. Check with; 
```
oc get nodes
```

----
## [Deploying Open5GCore] 
(1) Run 0-deploy5gcore.sh that creates the project, add project to service mesh member-roll, provisions necessary role bindings , deploy helm-charts for you and also also creates virtual istio ingress for webui. <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GCoreServiceMesh2.png)<br>

----
(2) Provision user equipment (UE) imsi (see ueransim/ueransim-ue-configmap.yaml, defaul imsi is 208930000000001) to 5gcore so your ue registration (ie running ueransim ue mode) will be allowed.
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GSWebUI.png)<br>

----
## [Running EURANSIM as a pod with multiple containers inside] 
(3) Use 1-deploy5gran.sh that creates the config maps and ueransim deployment with one pod that has multiple containers (gnb, ue as separate containers inside same pod) <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-pod.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-gnb-cont.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-ue-cont.png)<br>

----
## 5GCore with GitOps

(4) If you like to leverage GitOps on your deployment you can use Red Hat Openshift GitOps operator and simply point this repo with 5gcore helm path and kickstart your deployment.
Ref: [Red Hat GitOps Operator](https://catalog.redhat.com/software/operators/detail/5fb288c70a12d20cbecc6056)<br>
If you fail using ArgoCD due to permission errors on your project, worth to check/add necessary role to your argocd controller.
```
oc adm policy add-cluster-role-to-user cluster-admin -z openshift-gitops-argocd-application-controller -n openshift-gitops
```
ArgoCD Applications; 5GCore and 5GRAN <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/argoran2.png)<br>

ArgoCD 5GCore 
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/argo.png)<br>

ArgoCD 5GRAN 
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/argoran.png)<br>

----

PS: If you wonder from where to get the default ArgoCD admin password, here it is :-). <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/argopasswd.png)<br>

----
(5) Use ./3-delete5gran.sh to wipe ueransim microservices deployment

----

(6) Clear Enviroment run ./5-delete5gcore.sh to wipe 5gcore deployment<br> 

----
