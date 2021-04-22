Open5GS deployment on Red Hat Openshift with Service Mesh<br>
Background on Open5GS: https://open5gs.org/open5gs/docs/guide/01-quickstart/ <br>

Pre-Requistes: OCP with OSM installed and configured.<br>
Ref: https://docs.openshift.com/container-platform/4.7/service_mesh/v2x/installing-ossm.html <br>
(1) oc new-project open5gs<br><br>
(2) oc create -f load-sctp-module.yaml<br>
Note-1: Wait for machine config to be applied on all worker nodes and all worker nodes come back in to ready state.<br>
Check with; ''oc get nodes'' <br>
Note-2: Add open5gs to OSM ServiceMeshMemberRoll under istio-system ns (your istio cp ns)<br>
(3) Run 0-deploy5gcore.sh that creates the role bindings and deploy helm-charts for you. <br><br>
![alt text](https://raw.githubusercontent.com/fenar/cnvopen5gcore/main/pics/Open5GCoreServiceMesh.png)<br>

(4) Deploy UE RAN Simulator: 1st create a Ubuntu vm on cnv <br><br>
(4.1) Get iso from https://ubuntu.com/download/desktop <br><br>
(4.2) virtctl image-upload --uploadproxy-url=https://cdi-uploadproxy-openshift-cnv.apps.acmhub.narlabs.io/ dv iso-ubuntu2004-dv --size=3Gi --image-path=iso/ubuntu-20.04.2.0-desktop-amd64.iso --insecure <br><br>
(4.3) Create vm install target disk:  oc create -f ubuntuvm-pvc.yaml <br><br>
(4.4) Launch vm: oc create -f ubuntuvm.yaml <br>
(4.5) Go to VM Console under OCP Web UI Workloads>Virtualization>Virtualization>Virtual Machines>ubuntu2004vm1 Console and finish installation.<br>
(4.6) upload ueransim-vm-update.sh to vm and execute. <br>
