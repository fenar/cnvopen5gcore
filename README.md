## Open5GCore deployment on Red Hat Openshift Virtualization (CNF, VNF) with Service Mesh<br>
Background: <br>
(i) https://open5gs.org/open5gs/docs/guide/01-quickstart/ <br>
(ii) https://www.free5gc.org/ <br>

----
Prerequisites: 
OCP with OSM and CNV (Optional, if you like to use UERANSIM as container deployment, see "Option-B Fast Path" below) installed and configured.<br>

----

(1) oc new-project open5gcore<br>
(2) oc create -f sctpmod.yaml<br>
Note-1: Wait for machine config to be applied on all worker nodes and all worker nodes come back in to ready state. Check with; ''oc get nodes'' <br>
Note-2: Add your project "open5gcore" to OSM ServiceMeshMemberRoll under your istio control plane namespace (ex; istio-system)<br>
(3) Run 0-deploy5gcore.sh that creates the role bindings , deploy helm-charts for you and also also creates virtual istio ingress for webui. <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GCoreServiceMesh2.png)<br>
(4) Provision user equipment (UE) imsi (see ueransim/ueransim-ue-configmap.yaml, defaul imsi is 208930000000001) to 5gcore so your ue registration (ie running ueransim ue mode) will be allowed.
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GSWebUI.png)<br>

----

# [OPTION-A Long Path : Running EURANSIM in a Kubevirt VM]
(A5) Deploy UE RAN Simulator: 1st create a Ubuntu vm on cnv <br><br>
(A5.1) Get iso from https://ubuntu.com/download/desktop <br><br>
(A5.2) virtctl image-upload --uploadproxy-url=https://cdi-uploadproxy-openshift-cnv.apps.acmhub.narlabs.io/ dv iso-ubuntu2004-dv --size=3Gi --image-path=iso/ubuntu-20.04.2.0-desktop-amd64.iso --insecure <br><br>
(A5.3) Create vm install target disk:  oc create -f ubuntuvm-pvc.yaml <br><br>
(A5.4) Launch vm: oc create -f ubuntuvm.yaml <br>
(A5.5) Go to VM Console under OCP Web UI Workloads>Virtualization>Virtualization>Virtual Machines>ubuntu2004vm1 Console and finish installation.<br>
(A5.6) Follow guidance for ueransim install https://github.com/aligungr/UERANSIM/wiki/Installation. 
Or use prepeuransimvm.sh to perform install inside your vm.<br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/UERANSIM2.png)<br>

(A5.7) Git clone this rep in to kubevirt-vm and go to ueransim folder, run ./nr-gnb -c open5gs-gnb.yaml in UERAMSIM VM Terminal1 
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-gnb2.png)<br>

(A5.8) Under ueransim folder, run ./nr-ue -c open5gs-ue.yaml in UERANSIM VM Terminal2
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-ue2.png)<br>

# [OPTION-B Fast Path: Running EURANSIM as a pod with multiple containers inside] 
(B5.1) Use 1-deployUERANSIM.sh that creates the config maps and ueransim deployment with one pod that has multiple containers (gnb, ue as separate containers inside same pod) <br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-pod.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-gnb-cont.png)<br>

![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/ueransim-ue-cont.png)<br>

(B5.2) Use 8-deleteUERANSIM.sh to wipe ueransim microservices deployment

----

(6) Clear Enviroment run ./9-delete5gcore.sh to wipe 5gcore deployment<br> 

----

