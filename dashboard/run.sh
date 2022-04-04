#!/bin/bash

# Refer the dashboard here
# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

showtoken=1
cmd="kubectl proxy"
count=`pgrep -- -cf "$cmd"`
dashboard_yaml="https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml"
msgstarted="-e Kubernetes Dashboard Started"
msgstopped="Kubernetes Dashboard Stopped"

case $1 in
start)
   kubectl apply -f $dashboard_yaml
   kubectl apply -f dashboard/admin.yaml
   kubectl apply -f dashboard/read-only.yaml

   if [[ $count = 0 ]]; then
      nohup $cmd
      echo $msgstarted
   else
      echo "Kubernetes Dashboard already running"
   fi
   ;;

stop)
   showtoken=0
   if [[ $count -gt 0 ]]; then
      kill -9 $(pgrep -f "$cmd")
   fi
   kubectl delete -f $dashboard_yaml --ignore-not-found
   kubectl delete -f dashboard/admin.yaml --ignore-not-found
   kubectl delete -f dashboard/read-only.yaml --ignore-not-found
   echo $msgstopped
   ;;

status)
   found=`kubectl get serviceaccount admin-user -n kubernetes-dashboard 2>/dev/null`
   if [[ $count = 0 ]] || [[ $found = "" ]]; then
      showtoken=0
      echo $msgstopped
   else
      found=`kubectl get clusterrolebinding admin-user -n kubernetes-dashboard 2>/dev/null`
      if [[ $found = "" ]]; then
         nopermission=" but user has no permissions."
         echo $msgstarted$nopermission
         echo 'Run "dashboard start" to fix it.'
      else
         echo $msgstarted
      fi
   fi
   ;;
esac

# Show full command line # ps -wfC "$cmd"
if [ $showtoken -gt 0 ]; then
   # Show token
   echo "Admin token:"
   kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount admin-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
   echo

   echo "User read-only token:"
   kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount read-only-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
   echo
fi