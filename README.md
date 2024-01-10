# start-wars
This is ciliums demo app

Deploy the Demo Application
When we have Cilium deployed and kube-dns operating correctly we can deploy our demo application.

In our Star Wars-inspired example, there are three microservices applications: deathstar, tiefighter, and xwing. The deathstar runs an HTTP webservice on port 80, which is exposed as a Kubernetes Service to load-balance requests to deathstar across two pod replicas. The deathstar service provides landing services to the empire’s spaceships so that they can request a landing port. The tiefighter pod represents a landing-request client service on a typical empire ship and xwing represents a similar service on an alliance ship. They exist so that we can test different security policies for access control to deathstar landing services.

The file http-sw-app.yaml contains a Kubernetes Deployment for each of the three services. Each deployment is identified using the Kubernetes labels (org=empire, class=deathstar), (org=empire, class=tiefighter), and (org=alliance, class=xwing). It also includes a deathstar-service, which load-balances traffic to all pods with label (org=empire, class=deathstar).

Kubernetes will deploy the pods and service in the background. Running kubectl get pods,svc will inform you about the progress of the operation. Each pod will go through several states until it reaches Running at which point the pod is ready.

Each pod will be represented in Cilium as an Endpoint in the local cilium agent. We can invoke the cilium tool inside the Cilium pod to list them (in a single-node installation kubectl -n kube-system exec ds/cilium -- cilium endpoint list lists them all, but in a multi-node installation, only the ones running on the same node will be listed):

Check Current Access
From the perspective of the deathstar service, only the ships with label org=empire are allowed to connect and request landing. Since we have no rules enforced, both xwing and tiefighter will be able to request landing. To test this, use the commands below.

Apply an L3/L4 Policy
When using Cilium, endpoint IP addresses are irrelevant when defining security policies. Instead, you can use the labels assigned to the pods to define security policies. The policies will be applied to the right pods based on the labels irrespective of where or when it is running within the cluster.

We’ll start with the basic policy restricting deathstar landing requests to only the ships that have label (org=empire). This will not allow any ships that don’t have the org=empire label to even connect with the deathstar service. This is a simple policy that filters only on IP protocol (network layer 3) and TCP protocol (network layer 4), so it is often referred to as an L3/L4 network security policy.

Note: Cilium performs stateful connection tracking, meaning that if policy allows the frontend to reach backend, it will automatically allow all required reply packets that are part of backend replying to frontend within the context of the same TCP/UDP connection.

L4 Policy with Cilium and Kubernetes



CiliumNetworkPolicies match on pod labels using an “endpointSelector” to identify the sources and destinations to which the policy applies. The above policy whitelists traffic sent from any pods with label (org=empire) to deathstar pods with label (org=empire, class=deathstar) on TCP port 80.



Inspecting the Policy
If we run cilium endpoint list again we will see that the pods with the label org=empire and class=deathstar now have ingress policy enforcement enabled as per the policy above.
