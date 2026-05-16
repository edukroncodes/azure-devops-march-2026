# Kubernetes `kubectl` Command Reference

This guide expands your cheat sheet: each command includes **what it does**, **typical output** (illustrative—real clusters differ by version, CNI, metrics-server, and cloud), and **how to read the output**.

> **Note:** Example outputs below are **representative**. Your cluster may show different API versions, names, or empty tables if resources do not exist. `kubectl` must be installed and `KUBECONFIG` (or default `~/.kube/config`) must point at a cluster for commands to succeed.

---

## How to read common columns

| Column / field | Meaning |
|----------------|---------|
| **NAME** | Resource name in the API. |
| **READY** (pods) | `containersReady/total` for the pod. |
| **STATUS** | Human phase or condition summary (e.g. `Running`, `Pending`). |
| **RESTARTS** | Container restart count (spikes often mean OOM, crash, or probe failure). |
| **AGE** | Time since object creation. |
| **IP** | Pod IP (cluster-internal). |
| **NODE** | Node hosting the pod (`-o wide`). |
| **NAMESPACE** | Logical isolation boundary (`-n` or `-A`). |

---

# 1. Cluster commands

### `kubectl cluster-info`

**What it does:** Prints addresses of the control plane services the client knows about (API server, often kube-dns/CoreDNS).

**Example output:**

```text
Kubernetes control plane is running at https://127.0.0.1:6443
CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

**How to read it:** The first URL is the **Kubernetes API** endpoint. Additional lines are **service proxy URLs** for cluster add-ons. If this fails, your kubeconfig or network to the API server is wrong.

---

### `kubectl cluster-info dump`

**What it does:** Collects a large bundle of cluster state (events, node/pod descriptions, logs snippets, etc.) under a directory—used for support and deep debugging.

**Example output (truncated):**

```text
Output directory: /tmp/cluster-info-dump-20260116-120000
```

**How to read it:** It writes **files to disk** (default under `/tmp` on Linux/macOS; on Windows the tool uses a temp path). Inspect the folder for `events.json`, `nodes.json`, per-namespace dumps, etc.

---

### `kubectl version`

**What it does:** Shows **client** `kubectl` version and, if reachable, **server** Kubernetes version.

**Example output:**

```text
Client Version: v1.30.0
Kustomize Version: v5.0.4
Server Version: v1.30.2
```

**How to read it:** **Client** must be roughly compatible with **server** (skew policy: usually ±1 minor version). If server is missing, only client lines appear—check connectivity and auth.

---

### `kubectl config view`

**What it does:** Prints the merged kubeconfig (clusters, users, contexts, namespaces).

**Example output (abbreviated):**

```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:6443
  name: docker-desktop
contexts:
- context:
    cluster: docker-desktop
    user: docker-desktop
  name: docker-desktop
current-context: docker-desktop
```

**How to read it:** **`current-context`** is active. **`server`** is API URL. Secrets are often redacted as `DATA+OMITTED` when not using `--raw`.

---

### `kubectl config current-context`

**What it does:** Prints only the active context name.

**Example output:**

```text
docker-desktop
```

**How to read it:** This is the cluster+user pair `kubectl` uses until you `use-context` something else.

---

### `kubectl config get-contexts`

**What it does:** Lists all contexts with cluster, auth user, and whether each is current.

**Example output:**

```text
CURRENT   NAME              CLUSTER           AUTHINFO          NAMESPACE
*         docker-desktop    docker-desktop    docker-desktop
          prod-eks          prod-eks          prod-admin        prod
```

**How to read it:** `*` marks **current**. **NAMESPACE** column shows default namespace if set on that context.

---

### `kubectl config use-context mycluster`

**What it does:** Switches kubeconfig’s `current-context` to `mycluster`.

**Example output:**

```text
Switched to context "mycluster".
```

**How to read it:** Subsequent commands hit **that** cluster until changed again.

---

### `kubectl api-resources`

**What it does:** Lists API resource types (short names, API group, namespaced or not, verbs).

**Example output (snippet):**

```text
NAME          SHORTNAMES   APIVERSION    NAMESPACED   KIND
pods          po           v1            true         Pod
deployments   deploy       apps/v1       true         Deployment
nodes                      v1            false        Node
```

**How to read it:** **`NAMESPACED`** tells you if `-n` applies. **`SHORTNAMES`** are valid in `kubectl get po`, etc.

---

### `kubectl api-versions`

**What it does:** Lists **API groups/versions** the server exposes.

**Example output (snippet):**

```text
apps/v1
v1
networking.k8s.io/v1
```

**How to read it:** If a manifest uses `apiVersion` your server does not list, `kubectl apply` will fail—upgrade cluster or change the manifest.

---

### `kubectl explain pod`

**What it does:** Opens **built-in schema documentation** for the `Pod` kind (fields, types).

**Example output (snippet):**

```text
KIND:     Pod
VERSION:  v1

DESCRIPTION:
     Pod is a collection of containers...

FIELDS:
   apiVersion	<string>
   kind	<string>
   metadata	<Object>
   spec	<Object>
```

**How to read it:** Use this to learn valid YAML paths without leaving the terminal.

---

### `kubectl explain deployment.spec`

**What it does:** Same as `explain`, but scoped to `deployment.spec` (nested field help).

**How to read it:** Drill into **`spec.template`**, **`spec.selector`**, **`spec.strategy`**, etc., for Deployment-specific tuning.

---

### `kubectl auth can-i create pods`

**What it does:** Asks the API server whether **your current identity** may `create` `pods` (RBAC check).

**Example output:**

```text
yes
```

or

```text
no
```

**How to read it:** **`yes`/`no`** is the answer. Use `--namespace dev` or `--as system:admin` (if allowed) for broader checks.

---

### `kubectl top nodes`

**What it does:** Shows **CPU/memory usage** per node from **metrics-server** (or compatible metrics pipeline).

**Example output:**

```text
NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
worker-1   450m         22%    3200Mi          40%
```

**How to read it:** If you see **“Metrics API not available”**, install/configure [metrics-server](https://github.com/kubernetes-sigs/metrics-server). **`m`** = millicores (1 core = 1000m).

---

### `kubectl top pods`

**What it does:** Same as `top nodes`, but per **pod** (current namespace unless `-n`/`-A`).

**Example output:**

```text
NAME                     CPU(cores)   MEMORY(bytes)
nginx-7d4f7c8b5-xk2cj    5m           8Mi
```

**How to read it:** Useful for right-sizing limits/requests and spotting memory leaks.

---

### `kubectl get componentstatuses` (legacy)

**What it does:** Historically reported health of **scheduler**, **controller-manager**, **etcd** via the deprecated `ComponentStatus` API.

**Example output (older clusters):**

```text
NAME                 STATUS    MESSAGE   ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   ok
```

**How to read it:** On **Kubernetes 1.19+** this API is **removed or empty**; prefer **`kubectl get --raw /healthz`**, **`/livez`**, **`/readyz`**, or cloud control-plane health tools.

---

### `kubectl get events`

**What it does:** Lists **RecentWarning** and normal events (scheduling, pulls, probes, scaling).

**Example output:**

```text
LAST SEEN   TYPE     REASON      OBJECT        MESSAGE
2m          Normal   Scheduled   pod/nginx     Successfully assigned default/nginx to node-1
1m          Warning  Unhealthy   pod/nginx     Readiness probe failed
```

**How to read it:** **`Warning`** lines are prime troubleshooting clues. Use `--sort-by=.metadata.creationTimestamp` for timeline order.

---

### `kubectl get all`

**What it does:** Lists several **namespaced** workload types (pods, services, deployments, replicasets, etc.). It does **not** literally mean “every resource type.”

**How to read it:** Convenient snapshot; for CRDs or less common kinds, use `kubectl get <kind>` explicitly.

---

### `kubectl proxy`

**What it does:** Runs a **local HTTP proxy** to the API server (uses your kubeconfig credentials).

**Example output:**

```text
Starting to serve on 127.0.0.1:8001
```

**How to read it:** Browse `http://127.0.0.1:8001/api/v1/namespaces/default/pods` in a browser. **Do not expose** this port publicly.

---

### `kubectl port-forward pod/nginx 8080:80`

**What it does:** Forwards **local port 8080** to **container port 80** on pod `nginx` (namespace default unless `-n`).

**How to read it:** While running, `curl http://127.0.0.1:8080` hits the pod. Press **Ctrl+C** to stop. Works through API server tunnel—good for quick debugging without a Service.

---

### `kubectl get namespaces`

**What it does:** Lists **Namespace** objects.

**Example output:**

```text
NAME              STATUS   AGE
default           Active   30d
kube-system       Active   30d
dev               Active   2d
```

**How to read it:** **`STATUS Active`** is normal. **`Terminating`** stuck states often mean finalizers or stuck resources.

---

# 2. Namespace commands

### `kubectl get ns`

**What it does:** Short form of `kubectl get namespaces`.

---

### `kubectl create namespace dev`

**What it does:** Creates namespace `dev`.

**Example output:**

```text
namespace/dev created
```

---

### `kubectl delete namespace dev`

**What it does:** Deletes namespace and **cascades deletion** to most namespaced resources inside it.

**How to read it:** This can be **destructive** and slow (API removes objects in waves). Finalizers may delay completion.

---

### `kubectl describe namespace dev`

**What it does:** Shows labels, annotations, **resource quotas**, **limit ranges**, and recent **namespace-scoped events** summary.

---

### `kubectl edit namespace dev`

**What it does:** Opens the live object in `$EDITOR` (patch applied on save). Use for labels/annotations; be careful with quota objects.

---

### `kubectl label namespace dev env=prod`

**What it does:** Adds or overwrites label `env=prod` on namespace `dev`. Use `--overwrite` if label exists.

---

### `kubectl annotate namespace dev owner=bharath`

**What it does:** Sets annotation `owner=bharath` (metadata for tools/people; not used in selectors).

---

### `kubectl get pods -n kube-system`

**What it does:** Lists pods **only** in `kube-system` (CoreDNS, kube-proxy, CNI, metrics-server, etc., depending on distro).

---

### `kubectl get svc -n kube-system`

**What it does:** Lists services in `kube-system` (e.g. `kube-dns`).

---

### `kubectl get deploy -n dev`

**What it does:** Lists Deployments in namespace `dev`.

---

### `kubectl config set-context --current --namespace=dev`

**What it does:** Binds **default namespace** to the current context so plain `kubectl get pods` targets `dev`.

**Example output:**

```text
Context "docker-desktop" modified.
```

---

### `kubectl get events -n dev` / `kubectl get all -n dev`

**What it does:** Same as global variants but scoped to **dev**.

---

### `kubectl get configmaps|secrets|pvc|ingress|networkpolicy|serviceaccounts|rolebindings -n dev`

**What it does:** Lists that resource type in **dev**. Empty table means none exist.

---

# 3. Pod commands

### `kubectl get pods`

**What it does:** Lists pods in the **current namespace** (or context default).

**Example output:**

```text
NAME                    READY   STATUS    RESTARTS   AGE
nginx-7d4f7c8b5-xk2cj   1/1     Running   0          5m
```

---

### `kubectl get pods -o wide`

**What it does:** Adds **NODE IP**, **NODE name**, and sometimes more scheduling detail.

---

### `kubectl describe pod nginx`

**What it does:** Rich narrative: containers, volumes, conditions, **events** (most important for failures).

---

### `kubectl logs nginx` / `kubectl logs -f nginx`

**What it does:** Streams **stdout/stderr** from the default container; **`-f`** follows like `tail -f`.

**How to read it:** Empty logs may mean the container never wrote output or wrong container name—use **`-c`**.

---

### `kubectl exec -it nginx -- /bin/bash`

**What it does:** Runs an interactive shell **in the container** (image must contain `/bin/bash`; use `sh` on minimal images).

---

### `kubectl delete pod nginx`

**What it does:** Deletes the pod. A **Deployment/ReplicaSet** will recreate it with a new name.

---

### `kubectl run nginx --image=nginx`

**What it does:** Creates a pod (behavior varies by `kubectl` version; modern versions often create a Deployment or Pod depending on flags—check `--dry-run=client -o yaml`).

---

### `kubectl apply -f pod.yaml`

**What it does:** Declarative create/update from manifest.

---

### `kubectl get pod nginx -o yaml` / `-o json`

**What it does:** Exports full live object (includes defaulted fields and status).

---

### `kubectl cp test.txt nginx:/tmp/`

**What it does:** Copies local `test.txt` into the pod at `/tmp/test.txt`. Can use `pod/nginx:container` form for multi-container pods.

---

### `kubectl attach nginx`

**What it does:** Attaches to **running** container’s main process stdio—often used with **`kubectl run --restart=Never`** debug pods.

---

### `kubectl label pod nginx app=web` / `annotate pod nginx owner=bharath`

**What it does:** Metadata changes for selectors (`label`) or documentation/automation (`annotate`).

---

### `kubectl get pods --show-labels`

**What it does:** Appends a **LABELS** column to the list view.

---

### `kubectl get pods --field-selector=status.phase=Running`

**What it does:** Server-side filter: only pods in **Running** phase.

---

### `kubectl logs nginx -c app`

**What it does:** Reads logs from container named **`app`** in the pod.

---

### `kubectl delete pod --all`

**What it does:** Deletes **every pod** in the namespace—dangerous in prod. Controllers will recreate owned pods.

---

### `kubectl rollout restart deployment nginx`

**What it does:** Triggers a rolling restart by annotating the pod template; **new ReplicaSet revision**.

---

# 4. Deployment commands

### `kubectl get deployments`

**What it does:** Lists Deployments with desired vs ready replicas.

**Example output:**

```text
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   3/3     3            3           10m
```

**How to read it:** **`READY`** = ready replicas / desired. **`UP-TO-DATE`** counts pods on latest template.

---

### `kubectl create deployment nginx --image=nginx`

**What it does:** Creates a Deployment with default rollout settings and a default selector/labels.

---

### `kubectl scale deployment nginx --replicas=5`

**What it does:** Sets **desired replicas** to 5 (horizontal scale).

---

### `kubectl rollout status deployment nginx`

**What it does:** Blocks until rollout completes or fails—good in scripts/CI.

---

### `kubectl rollout history deployment nginx`

**What it does:** Lists **ReplicaSet revisions** (change cause annotations if set).

---

### `kubectl rollout undo deployment nginx`

**What it does:** Rolls back to previous ReplicaSet template (default one revision back; `--to-revision=N` for specific).

---

### `kubectl edit deployment nginx`

**What it does:** Live edit Deployment (e.g. image, env, resources).

---

### `kubectl set image deployment/nginx nginx=nginx:1.25`

**What it does:** Updates container **`nginx`** image in Deployment **`nginx`** to `nginx:1.25` (triggers rollout).

---

### `kubectl describe deployment nginx`

**What it does:** Conditions, events, replica counts, strategy, and pod template summary.

---

### `kubectl delete deployment nginx`

**What it does:** Deletes Deployment and **cascades** ReplicaSets/Pods (unless orphan options used).

---

### `kubectl get rs`

**What it does:** Lists **ReplicaSets**—often one current + older from rollouts.

---

### `kubectl autoscale deployment nginx --cpu-percent=70 --min=2 --max=10`

**What it does:** Creates an **HorizontalPodAutoscaler** targeting CPU% with min/max bounds.

**Prerequisite:** Metrics and **resource requests** on pods for CPU-based scaling.

---

### `kubectl rollout restart deployment nginx`

**What it does:** Same as in pod section—restart via template change.

---

### `kubectl patch deployment nginx -p '{"spec":{"replicas":3}}'`

**What it does:** JSON merge patch example for replicas (same effect as `scale`).

---

### `kubectl apply -f deployment.yaml`

**What it does:** Apply from file.

---

### `kubectl get deploy -o wide` / `--show-labels`

**What it does:** More columns or label visibility.

---

### `kubectl annotate deployment nginx owner=bharath` / `label deployment nginx app=frontend`

**What it does:** Metadata on the Deployment object.

---

### `kubectl get deployment nginx -o yaml`

**What it does:** Full manifest export.

---

# 5. Service commands

### `kubectl get svc`

**What it does:** Lists Services with **TYPE**, **CLUSTER-IP**, **EXTERNAL-IP**, **PORT(S)**.

**Example output:**

```text
NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
nginx   ClusterIP   10.96.100.10    <none>        80/TCP    2m
```

**How to read it:** **`ClusterIP`** is internal only. **`NodePort`** exposes high node port. **`LoadBalancer`** provisions cloud LB when supported.

---

### `kubectl expose deployment nginx --port=80 --type=NodePort`

**What it does:** Creates a Service targeting Deployment pods’ labels on **port 80**.

---

### `kubectl describe svc nginx`

**What it does:** Endpoints, selectors, session affinity, events.

---

### `kubectl delete svc nginx`

**What it does:** Removes the Service (pods remain).

---

### `kubectl get endpoints`

**What it does:** Legacy **Endpoints** objects backing Services (being superseded by **EndpointSlices**).

**Example output:**

```text
NAME    ENDPOINTS           AGE
nginx   10.244.1.3:80       1m
```

**How to read it:** Empty **ENDPOINTS** with non-zero pods usually means **selector mismatch** or pods not **Ready**.

---

### `kubectl port-forward svc/nginx 8080:80`

**What it does:** Forwards to a **Service** (load-balances across backends on the client side through the API tunnel).

---

### `kubectl edit svc nginx` / `kubectl apply -f service.yaml`

**What it does:** Change Service fields (type, ports, selectors).

---

### `kubectl get svc -o wide` / `--all-namespaces`

**What it does:** Wider columns or all namespaces (`-A` equivalent).

---

### `kubectl get endpointslices`

**What it does:** Modern view of Service backends (may be many slices per Service).

---

### `kubectl label svc nginx env=prod` / `annotate svc nginx owner=bharath`

**What it does:** Service metadata.

---

### Service account commands (`get|create|describe|delete serviceaccount`)

**What it does:** Manage **ServiceAccount** objects used by pod identity and RBAC bindings.

---

### Ingress commands (`get|describe|delete ingress`)

**What it does:** Manage **Ingress** HTTP/S routing rules (requires an Ingress controller installed).

---

# 6. ConfigMap & Secret commands

### `kubectl get configmaps` / `create configmap app-config --from-literal=env=prod`

**What it does:** ConfigMaps store **non-secret** config as key/value or files.

---

### `kubectl describe configmap app-config`

**What it does:** Shows keys and decoded values (still avoid storing sensitive data).

---

### `kubectl delete|edit|get configmap app-config -o yaml`

**What it does:** Lifecycle and export.

---

### `kubectl get secrets`

**What it does:** Lists Secrets (values **not** shown in plain `get`).

---

### `kubectl create secret generic db-secret --from-literal=password=admin123`

**What it does:** Creates a Secret with base64-encoded data in etcd (**still protect RBAC and etcd encryption at rest**).

> **Security:** Prefer external secret managers + short-lived creds; never commit real passwords to git.

---

### `kubectl describe secret db-secret`

**What it does:** Shows keys and **sizes**, not raw secret values by default.

---

### `kubectl get secret db-secret -o yaml`

**What it does:** Shows **base64** data—decode only in secure environments.

---

### `kubectl create secret tls tls-secret --cert=cert.crt --key=cert.key`

**What it does:** TLS cert/key pair for Ingress or manual mount.

---

### `kubectl create secret docker-registry regcred ...`

**What it does:** Image pull secret for private registries.

---

### `kubectl label|annotate secret db-secret ...`

**What it does:** Metadata on Secret.

---

### `kubectl get secrets --all-namespaces`

**What it does:** Cross-namespace listing—requires RBAC permission.

---

### `kubectl apply -f secret.yaml` / `configmap.yaml`

**What it does:** Declarative apply.

---

### `kubectl rollout restart deployment nginx`

**What it does:** Often used after changing mounted ConfigMaps/Secrets so pods **reload** (unless app hot-reloads).

---

# 7. Node commands

### `kubectl get nodes`

**What it does:** Lists cluster worker/control nodes you’re authorized to see.

**Example output:**

```text
NAME       STATUS   ROLES           AGE   VERSION
node-1     Ready    control-plane   10d   v1.30.2
node-2     Ready    <none>          10d   v1.30.2
```

**How to read it:** **`Ready`** means node is healthy enough to schedule (kubelet reporting). **`NotReady`** → investigate kubelet, disk, network, or CNI.

---

### `kubectl get nodes -o wide`

**What it does:** Adds **INTERNAL-IP**, **EXTERNAL-IP**, OS image, kernel, container runtime.

---

### `kubectl describe node node01`

**What it does:** Capacity/allocatable, conditions, **images**, **taints**, **resource pressure**, and pod summary.

---

### `kubectl cordon node01`

**What it does:** Marks node **unschedulable** (no new pods); existing pods stay.

---

### `kubectl uncordon node01`

**What it does:** Re-enables scheduling.

---

### `kubectl drain node01 --ignore-daemonsets`

**What it does:** Evicts workloads (respecting PDBs when configured); **`--ignore-daemonsets`** skips DaemonSet pods that cannot be evicted the same way.

---

### `kubectl top node node01`

**What it does:** Metrics for one node.

---

### `kubectl label node node01 disktype=ssd`

**What it does:** Node labels for **scheduling** (`nodeSelector`, `affinity`).

---

### `kubectl taint nodes node01 key=value:NoSchedule`

**What it does:** Repels pods unless they **tolerate** the taint.

---

### `kubectl taint nodes node01 key=value:NoSchedule-`

**What it does:** **Removes** that taint (note trailing `-`).

---

### `kubectl get pods -o wide`

**What it does:** See which **NODE** each pod landed on.

---

### `kubectl get nodes --show-labels`

**What it does:** Long label list per node.

---

### `kubectl edit node node01` / `annotate node node01 owner=bharath`

**What it does:** Metadata edits (avoid unsafe capacity changes).

---

### `kubectl get events --field-selector involvedObject.kind=Node`

**What it does:** Filters events to Node-related messages.

---

### `kubectl top nodes`

**What it does:** All nodes’ CPU/memory usage.

---

### `kubectl debug node/node01 -it`

**What it does:** **Ephemeral debug** session on/for a node (behavior depends on feature gates and distro—often spawns a privileged helper pod).

---

### `kubectl proxy` / `kubectl get cs` / `kubectl cluster-info`

**What it does:** Same as section 1; **`cs`** is legacy component status.

---

# 8. Persistent volume commands

### `kubectl get pv`

**What it does:** Cluster-scoped **PersistentVolumes** (storage claims satisfied at cluster level).

---

### `kubectl get pvc`

**What it does:** Namespace-scoped **claims** binding to PVs or dynamic provisioning.

**Example output:**

```text
NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data   Bound    pvc-8f1c2d3e-4a5b-6c7d-8e9f0a1b2c3d   10Gi       RWO            standard       1h
```

**How to read it:** **`Pending`** = no PV match or provisioner issue. **`Bound`** = linked volume.

---

### `kubectl describe pv pv01` / `kubectl describe pvc pvc01`

**What it does:** Capacity, access modes, reclaim policy, mount options, events (provisioning failures).

---

### `kubectl delete pvc pvc01`

**What it does:** Deletes claim—**may delete underlying PV** depending on **reclaim policy** and **StorageClass** `reclaimPolicy` / provisioner behavior.

---

### `kubectl apply -f pvc.yaml`

**What it does:** Create/update PVC.

---

### `kubectl get storageclass` / `kubectl describe storageclass standard`

**What it does:** Defines **dynamic provisioning** driver and default parameters.

---

### `kubectl edit pvc pvc01`

**What it does:** Some fields immutable—edits may fail unless allowed.

---

### `kubectl get pv,pvc`

**What it does:** Combined table of both kinds.

---

### `kubectl delete pv pv01` / `kubectl apply -f pv.yaml`

**What it does:** Manual PV lifecycle (static provisioning scenarios).

---

### `kubectl get sc`

**What it does:** Short name for `storageclass`.

---

### `kubectl label|annotate pvc pvc01 ...`

**What it does:** Metadata.

---

### `kubectl get pvc -A`

**What it does:** All namespaces.

---

### `kubectl patch pvc pvc01 -p '{"metadata":{"labels":{"env":"dev"}}}'`

**What it does:** Example JSON patch for labels.

---

### `kubectl describe pod nginx`

**What it does:** Under **Volumes** / **Mounts**, verify PVC attachment.

---

### `kubectl get events`

**What it does:** Provisioning timeouts, attach/detach errors.

---

### `kubectl logs storage-provisioner`

**What it does:** Only exists on some local clusters (e.g. minikube addon)—not universal.

---

# 9. DaemonSet commands

### `kubectl get daemonsets` / `describe|delete|rollout restart|apply|edit|get -o yaml`

**What it does:** DaemonSet ensures a pod runs on **eligible** nodes (subject to taints/tolerations and node selectors).

---

### `kubectl get ds`

**What it does:** Short name for `daemonsets`.

---

### `kubectl scale daemonset fluentd --replicas=2`

**What it does:** **Note:** DaemonSets are **not** scaled like Deployments in modern Kubernetes; replica-style scaling is usually **wrong** for standard DaemonSets. Prefer node coverage + update strategy. (Older/experimental behaviors may differ—verify with your version.)

---

### `kubectl rollout status|history daemonset fluentd`

**What it does:** Same rollout concepts as Deployments.

---

### `kubectl annotate|label daemonset fluentd ...`

**What it does:** Metadata.

---

### `kubectl get pods -l app=fluentd`

**What it does:** Lists pods created by the DaemonSet controller matching labels.

---

### `kubectl logs fluentd-abcde` / `describe pod fluentd-abcde`

**What it does:** Per-pod debugging.

---

### `kubectl patch daemonset fluentd -p '...'`

**What it does:** Template/metadata patches trigger rolling update of DS pods.

---

### `kubectl delete pod fluentd-abcde`

**What it does:** Controller **recreates** the pod on that node.

---

### `kubectl top pods`

**What it does:** Resource usage for DS pods like any other workload.

---

# 10. StatefulSet commands

### `kubectl get statefulsets`

**What it does:** Ordered pods with **stable network identity** and **sticky storage** per ordinal.

---

### `kubectl describe|delete|scale|rollout|apply|edit statefulset mysql`

**What it does:** **`scale`** changes replicas; deletes are ordered (default reverse on scale-down).

---

### `kubectl get sts` / `kubectl get statefulset mysql -o yaml`

**What it does:** Short name / export.

---

### `kubectl get pvc` / `kubectl get pods`

**What it does:** StatefulSets often create **volumeClaimTemplates** → one PVC per replica.

---

### `kubectl delete pod mysql-0`

**What it does:** Pod recreated with **same name** and reattached to its PVC (behavior depends on policy and storage).

---

### `kubectl logs mysql-0` / `kubectl exec -it mysql-0 -- bash`

**What it does:** Operate on ordinal **0** pod.

---

### `kubectl label|annotate statefulset mysql ...`

**What it does:** Metadata.

---

### `kubectl patch statefulset mysql -p '{"spec":{"replicas":2}}'`

**What it does:** Example replica patch.

---

### `kubectl get events` / `kubectl top pod mysql-0`

**What it does:** Troubleshooting and metrics.

---

# 11. Job & CronJob commands

### `kubectl get jobs` / `kubectl get cronjobs`

**What it does:** **Job** runs to completion; **CronJob** creates Jobs on a schedule.

---

### `kubectl create job test-job --image=busybox`

**What it does:** Simple one-off Job (add command with `--` args as needed).

---

### `kubectl create cronjob backup --image=busybox --schedule="*/5 * * * *"`

**What it does:** Cron schedule in **standard five-field** cron syntax (minute hour dom month dow).

---

### `kubectl describe job test-job`

**What it does:** Parallelism, completions, backoff, events.

---

### `kubectl delete job test-job` / `kubectl delete cronjob backup`

**What it does:** Deletes controller; **may leave pods** unless propagation/cascade options used—check flags.

---

### `kubectl logs job/test-job`

**What it does:** Logs from pod(s) owned by the Job.

---

### `kubectl get pods`

**What it does:** Job pods often named `test-job-xxxxx`.

---

### `kubectl apply -f job.yaml` / `cronjob.yaml`

**What it does:** Declarative apply.

---

### `kubectl edit cronjob backup`

**What it does:** Change schedule, concurrency policy, suspend, job template.

---

### `kubectl get cj`

**What it does:** Short for `cronjobs`.

---

### `kubectl get jobs -o wide`

**What it does:** Extra columns when available.

---

### `kubectl annotate|label job test-job ...`

**What it does:** Metadata.

---

### `kubectl patch cronjob backup -p '{"spec":{"suspend":true}}'`

**What it does:** **Pauses** future Job creation from that CronJob.

---

### `kubectl rollout restart deployment nginx`

**What it does:** Not a direct CronJob trigger—listed in cheat sheets as a loose “reload dependents” idea; for CronJobs use **`kubectl create job --from=cronjob/backup manual-001`** for ad-hoc runs.

---

### `kubectl get events` / `kubectl top pod`

**What it does:** Debug failed jobs and resource usage.

---

# 12. Troubleshooting commands

This section repeats the highest-signal tools:

| Command | Why it matters |
|---------|----------------|
| `describe pod` | Events: image pull, mount, probe, OOM, scheduling. |
| `logs` / `logs -f` | Application and sidecar output. |
| `get events --sort-by=...` | Timeline of control plane + kubelet messages. |
| `top pod` / `top node` | CPU/memory reality vs requests/limits. |
| `exec -it ... sh` | Live inspection (packages, files, DNS). |
| `get pods -A` | Find which namespace misbehaves. |
| `get pod -o yaml` | See final spec: env, mounts, probes, nodeName. |
| `debug node/...` | Node-level investigation (platform dependent). |
| `auth can-i` | RBAC denials vs “not found.” |
| `rollout history` | Bad image/config introduced when. |
| `get endpoints` / `describe svc` | Service has no backends? wrong ports? |
| `get ingress` | Routing rules vs controller implementation. |
| `get networkpolicy` | Accidental deny-all or missing egress. |
| `get pvc` | Pending mounts, wrong storage class. |
| `cluster-info dump` | Shareable broad evidence bundle. |

---

## Quick safety reminders

- **`delete namespace`**, **`delete pod --all`**, and **`drain`** can cause outages—use **dry-run**: `kubectl delete ... --dry-run=server` where supported.
- **Secrets in shell history:** avoid `--from-literal=password=...` on shared machines; prefer files or secret managers.
- **`kubectl proxy`** and **`port-forward`** expose powerful access—bind to localhost only.

---

## Installing `kubectl` on Windows (if `kubectl` is not found)

1. Install from Kubernetes docs: [Install kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).
2. Ensure the install directory is on **PATH**.
3. Run `kubectl version --client` to verify.

---

*Document generated as a teaching reference; align behavior with your exact Kubernetes version using `kubectl version` and `kubectl explain`.*
