# About shell-operator
[GitHub] https://github.com/flant/shell-operator

# Scenario
![avatar](https://github.com/linnn2187/shell-operator/blob/main/shell-operator%20scenario.png)

# Quickstart
1. Create the failed pod.
```
kubectl create -f myReadiness-Pod.yaml
```
2. Create shell-operator pod.
```
kubectl create -f shell-operator-pod.yaml -n monitor-events
```
3. Observe hook.<br>
   Start capturing the network traffic of the failed pod(podIP: 10.244.2.61).
```
kubectl -n monitor-events logs po/shell-operator

...
"binding":"monitor-events","event":"kubernetes","hook":"pods-hook.sh","level":"info","msg":"\"Readiness probe failed: HTTP probe failed with statuscode: 404\""
...
"binding":"monitor-events","event":"kubernetes","hook":"pods-hook.sh","level":"info","msg":"    4   0.000213   10.244.2.1 → 10.244.2.61  HTTP 179 GET /error.html HTTP/1.1 "
...
"binding":"monitor-events","event":"kubernetes","hook":"pods-hook.sh","level":"info","msg":"    6   0.000304  10.244.2.61 → 10.244.2.1   HTTP 371 HTTP/1.1 404 Not Found  (text/html)"
...
```
