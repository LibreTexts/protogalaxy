#!/bin/bash

kubectl get pods -n binderhub | awk '/jupyter-/{print $1}' | while read POD; do
    cat /home/milky/miners.txt | while read LINE; do
        kubectl exec -n binderhub -c notebook $POD -- pgrep -lf "$LINE" 2> /dev/null
        if [ "$?" -eq 0 ]; then
            PID=$(kubectl exec -n binderhub -c notebook $POD -- pgrep -lf "$LINE")
            date >> /home/milky/miner-log.txt
            kubectl exec -n binderhub -c notebook $POD -- \
            ps $PID | awk 'NR>1' | awk '{$1=$2=$3=$4=""; print $0}' | awk '{$1=$1;print}' >> /home/milky/miner-log.txt
            kubectl delete pod -n binderhub $POD 2> /dev/null
            break
        fi
    done 
done
