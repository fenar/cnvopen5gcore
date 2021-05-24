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
(1) oc new-project open5gcore<br>
Note: Add your project "open5gcore" to OSM ServiceMeshMemberRoll under your istio control plane namespace (ex; istio-system)<br>
Or you can you following cli command. <9br>
```
oc -n istio-system patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"open5gcore"'"]}]'
```

----
## [Deploying Open5GCore] 
(2) Run 0-deploy5gcore.sh that creates the role bindings , deploy helm-charts for you and also also creates virtual istio ingress for webui. <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GCoreServiceMesh2.png)<br>

----
(3) Provision user equipment (UE) imsi (see ueransim/ueransim-ue-configmap.yaml, defaul imsi is 208930000000001) to 5gcore so your ue registration (ie running ueransim ue mode) will be allowed.
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GSWebUI.png)<br>

----
## [Running EURANSIM as a pod with multiple containers inside] 
(4) Use 1-deployUERANSIM.sh that creates the config maps and ueransim deployment with one pod that has multiple containers (gnb, ue as separate containers inside same pod) <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-pod.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-gnb-cont.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-ue-cont.png)<br>

----
## 5GCore with GitOps

(5) If you like to leverage GitOps on your deployment you can use Red Hat Openshift GitOps operator and simply point this repo with acmcicd path and kickstart your deployment.
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/argo.png)<br>

----
(6) Use 8-deleteUERANSIM.sh to wipe ueransim microservices deployment

----

(7) Clear Enviroment run ./9-delete5gcore.sh to wipe 5gcore deployment<br> 

----
