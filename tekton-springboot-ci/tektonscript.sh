#!/bin/bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
sleep 10
kubectl get pods --namespace tekton-pipelines

kubectl apply --filename https://storage.googleapis.com/tekton-releases/chains/latest/release.yaml
sleep 10

kubectl patch configmap chains-config -n tekton-chains -p='{"data":{"artifacts.taskrun.format": "in-toto"}}'
kubectl patch configmap chains-config -n tekton-chains -p='{"data":{"artifacts.taskrun.storage": "tekton"}}'


kubectl scale deployment -n tekton-chains tekton-chains-controller --replicas=0
kubectl scale deployment -n tekton-chains tekton-chains-controller --replicas=1

git clone https://github.com/sigstore/cosign
cd cosign
go install ./cmd/cosign

cosign generate-key-pair k8s://tekton-chains/signing-secrets
kubectl create -f https://raw.githubusercontent.com/tektoncd/chains/main/examples/taskruns/task-output-image.yaml
kubectl get taskrun
sleep 15
kubectl get taskrun


#Install tekton cli
sudo apt update;sudo apt install -y gnupg

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA

echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list

sudo apt update && sudo apt install -y tektoncd-cli



#Install Dashboard
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml

kubectl patch service tekton-dashboard -p '{"spec": {"type": "NodePort"}}' -n tekton-pipelines
sleep 2
kubectl get service tekton-dashboard -n tekton-pipelines


tkn version

git clone https://github.com/laxapatiakshaylearning/tektondemo
cd tektondemo
kubectl apply --filename 1_task_hello-world.yaml
kubectl apply --filename 2_taskrun_hello-world-run.yaml
kubectl apply --filename 3_goodbye-world.yaml
tkn pipeline create -f 4_hello-goodbye-pipeline.yaml
kubectl apply --filename 5_hello-goodbye-pipeline-run.yaml
kubectl apply --filename 6_clustertask_hello-world.yaml






echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "###############################################################################################################################################################" >> /tmp/tektondashboard.txt
echo "" >> /tmp/tektondashboard.txt
echo "" >> /tmp/tektondashboard.txt
echo "" >> /tmp/tektondashboard.txt

echo "Below are the public IP address of tekton-dashboard" > /tmp/tektondashboard.txt
kubectl get nodes -o wide -o yaml | grep ExternalIP -B 1 >> /tmp/tektondashboard.txt


echo "Below is the port of tekton-dashboard" >> tektondashboard.txt
kubectl get service tekton-dashboard -n tekton-pipelines -o yaml | grep nodePort | awk -F":" '{print $2}' >> /tmp/tektondashboard.txt
cat /tmp/tektondashboard.txt

