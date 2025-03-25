.
├── kubernetes/
│   ├── cilium-policies/
│   │   ├── sw_l3_l4_policy.yaml        # Basic L3/L4 policy (org=empire only)
│   │   └── sw_l3_l4_l7_policy.yaml     # Advanced L7 policy (specific HTTP routes)
│   └── applications/
│       └── http-sw-app.yaml            # Main Star Wars app deployment
├── services/
│   ├── deathstar/
│   │   ├── Dockerfile
│   │   ├── main.go                     # Deathstar API service
│   │   └── handlers/
│   │       ├── request_landing.go      # POST /v1/request-landing endpoint
│   │       └── exhaust_port.go         # PUT /v1/exhaust-port endpoint (dangerous!)
│   ├── tiefighter/
│   │   ├── Dockerfile
│   │   └── main.go                     # Empire ship client
│   └── xwing/
│       ├── Dockerfile
│       └── main.go                     # Alliance ship client
├── docs/
│   ├── architecture.md                 # Overview of the demo architecture
│   ├── cilium_http_gsg.png             # Application topology diagram
│   ├── cilium_http_l3_l4_gsg.png       # L4 policy visualization
│   └── cilium_http_l3_l4_l7_gsg.png    # L7 policy visualization
└── scripts/
    ├── deploy.sh                       # Script to deploy the demo
    ├── test-tiefighter-access.sh       # Script to test tiefighter access
    ├── test-xwing-access.sh            # Script to test xwing access
    └── cleanup.sh                      # Script to remove all resources


or ---------------------------------------------------

.
├── debug-pod.yaml
├── docker-compose.yaml
├── Docs/
│   ├── technical-docs.md
│   ├── architecture.md               # Overview of the demo architecture
│   ├── cilium_http_gsg.png           # Application topology diagram
│   ├── cilium_http_l3_l4_gsg.png     # L4 policy visualization
│   └── cilium_http_l3_l4_l7_gsg.png  # L7 policy visualization
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── patches/
│   │       ├── deathstar-dev-patch.yaml
│   │       ├── tiefighter-dev-patch.yaml
│   │       └── xwing-dev-patch.yaml
│   └── prod/
│       └── kustomization.yaml
├── pkg/
│   ├── deathstar/
│   │   ├── app.yaml                  # Main application config
│   │   └── manifests/
│   │       ├── deathstar-deploy.yaml # Deathstar deployment with replicas
│   │       ├── deathstar-svc.yaml    # Deathstar service exposing port 80
│   │       └── kustomization.yaml
│   ├── tiefighter/
│   │   ├── app.yaml                  # Empire ship client config
│   │   └── manifests/
│   │       ├── deployment.yaml       # Tiefighter deployment
│   │       └── kustomization.yaml
│   └── xwing/
│       ├── app.yaml                  # Alliance ship client config
│       └── manifests/
│           ├── deployment.yaml       # Xwing deployment 
│           └── kustomization.yaml
├── kubernetes/
│   ├── cilium-policies/
│   │   ├── sw_l3_l4_policy.yaml      # Basic L3/L4 policy (org=empire only)
│   │   └── sw_l3_l4_l7_policy.yaml   # Advanced L7 policy (specific HTTP routes)
│   └── applications/
│       └── http-sw-app.yaml          # Main Star Wars app deployment
├── prometheus.yml
├── README.md
├── services/
│   ├── deathstar/
│   │   ├── Dockerfile
│   │   ├── main.go                   # Deathstar API service
│   │   └── handlers/
│   │       ├── request_landing.go    # POST /v1/request-landing endpoint
│   │       └── exhaust_port.go       # PUT /v1/exhaust-port endpoint (dangerous!)
│   ├── tiefighter/
│   │   ├── Dockerfile
│   │   └── main.go                   # Empire ship client
│   └── xwing/
│       ├── Dockerfile
│       └── main.go                   # Alliance ship client
└── scripts/
    ├── deploy.sh                     # Script to deploy the demo
    ├── test-tiefighter-access.sh     # Script to test tiefighter access
    ├── test-xwing-access.sh          # Script to test xwing access
    └── cleanup.sh                    # Script to remove all resources

    --set ipv4NativeRoutingCIDR="10.1.0.0/16" \

    helm install cilium cilium/cilium --version 1.17.1 \
      --namespace kube-system \
      --set ipam.mode=kubernetes \
      --set kubeProxyReplacement=true \
      --set gatewayAPI.enabled=true \
      --set routingMode=tunnel \
      --set bgpControlPlane.enabled=true \
      --set prometheus.enabled=true \
      --set operator.prometheus.enabled=true \
      --set hubble.enabled=true \
      --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
      --set hubble.relay.enabled=true \
      --set hubble.ui.enabled=true \
      --set nodePort.enabled=true \
      --set authentication.mutual.spire.enabled=true \
      --set authentication.mutual.spire.install.enabled=true \
      --set ingressController.enabled=true \
      --set ingressController.default=true \
      --set ingressController.service.type=NodePort \
      --set ingressController.service.httpNodePort=31235 \
      --set ingressController.service.httpsNodePort=31613 \
      --set ingressController.loadbalancerMode=shared \
      --set crds.install=true \
      --set tetragon.enabled=true \
      --set tetragon.export.pprof.enabled=true \
      --set tetragon.export.hubble.enabled=true \
      --set tetragon.resources.requests.cpu=100m \
      --set tetragon.resources.requests.memory=100Mi \
      --set tetragon.resources.limits.cpu=500m \
      --set tetragon.resources.limits.memory=500Mi



      helm upgrade cilium cilium/cilium --version 1.17.1 \
      --namespace kube-system \
      --reuse-values \
      --set cluster.name=kind-kind \
      --set cluster.id=1 \
      --set clustermesh.useAPIServer=true \
      --set clustermesh.enableEndpointSync=true \
      --set clustermesh.enableMCSAPI=true \



      helm upgrade cilium cilium/cilium --version 1.17.1 \
      --namespace kube-system \
      --reuse-values \
      --set cluster.name=kind-koornchart \
      --set cluster.id=2 \
      --set clustermesh.useAPIServer=true \
      --set clustermesh.enableEndpointSync=true \
      --set clustermesh.enableMCSAPI=true \


      Why?
SPIRE uses the cluster name defined in the Kubernetes API server configuration.
kubectl config view --minify -o jsonpath='{.clusters[0].name}' shows the actual name Kubernetes is using.
KIND's internal name (kind get clusters) is just a label for KIND itself and may not always match what Kubernetes expects.
💡 Best Practice
Always use kubectl config view --minify -o jsonpath='{.clusters[0].name}' to check the correct cluster name for SPIRE.
In your case, use "kind-kind" instead of "kind" in SPIRE.


 kubectl -n kube-system exec ds/cilium -- cilium config | grep ingress

 kubectl patch svc cilium-ingress -n kube-system -p '{"spec":{"ports":[{"name":"http","nodePort":31235,"port":80,"protocol":"TCP"},{"na
me":"https","loadBalancer":31613,"port":443,"protocol":"TCP"}]}}'


helm repo add cnpg https://cloudnative-pg.github.io/charts
helm install --install cnpg \
  --namespace cnpg-system \
  --create-namespace \
  cnpg/cloudnative-pg


pkg2/ is for ingress stuff
