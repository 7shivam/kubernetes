
# Tekton Pipeline For Springboot with AKS

This is a very simple but workable Tekton Pipeline development process that showcases:

- How to reuse the predefined Tasks from https://github.com/tektoncd/catalog
- How to run through the TaskRuns step by step to walk through a typical Tekton pipeline development process
- How to consolidate the desired Tasks to make it a Tekton Pipeline
- How to set up Tekton Pipeline, Dashboard from scratch

# Prerequisites


- Execute tektonscript.sh with sudo Privillages 
  on aks cluster to install tkn, pipelines etc.

  ```bash
  sudo  sh tektonscript.sh
   ```
## Adding Load Balancer for Tekton Dashboard

```bash
 kubectl patch service tekton-dashboard -p '{"spec": {"type": "LoadBalancer"}}' -n tekton-pipelines
   ```


## Run The following commands to execute Pipeline

- First clone this repo in your working dir.
- We need to add  pvc for adding workspace to pipeline. for that run the following command


```bash
 kubectl create -f pvc.yaml
   ```
- Create Task

```bash
kubectl create -f maven-task.yaml
   ```

- create pipeline

```bash
kubectl create -f maven-pipeline.yaml
   ```
- create PipelineRun

```bash
kubectl create -f maven-pipelinerun.yaml

  ```


For github authentication we need serviceaccount and secret.
I am adding empty secret template here. There are two type of authentication available in tekton.
I have used basic authentication.
you can add your github username and token and create it using the given command.
 
 ```bash
apiVersion: v1
kind: Secret
metadata:
  name: git-secrets
  annotations:
    tekton.dev/git-0: https://github.com
    
type: kubernetes.io/basic-auth
stringData:
  username: ""
  password: ""

 ```
- for creating service Account and secret run following commands.


```bash
kubectl create -f git-secret.yaml

kubectl create -f serviceaccount.yaml


  ```

As of  now for sonarqube i am giving sonar token manually to pipeline ref.






  
   


