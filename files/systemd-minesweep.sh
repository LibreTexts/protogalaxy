#!/bin/bash

kubectl get pods -n binderhub | awk '/jupyter-/{print $1}' | while read POD; do
    cat /home/milky/miners.txt | while read LINE; do
        kubectl exec -n binderhub -c notebook $POD -- pgrep -l $LINE &> /dev/null
        if [ "$?" -eq 0 ]; then
            PID=$(kubectl exec -n binderhub -c notebook $POD -- pgrep $LINE)
            kubectl exec -n binderhub -c notebook $POD -- \
            ps $PID | awk 'NR>1' | awk '{$1=$2=$3=$4=""; print $0}' | awk '{$1=$1;print}' >> /home/milky/miner-log.txt
            kubectl delete pod -n binderhub $POD &> /dev/null
            break
        fi
    done 
done
