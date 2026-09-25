Explain Kubernetes authentication with Vault.
 
 Vault Kubernetes Auth Method allows applications running inside Kubernetes (including Jenkins, microservices, and cronjobs) to authenticate with Vault using their native Kubernetes Service Account tokens.

In a Kubernetes environment, I would avoid storing a static Vault token inside the application.

Instead, the workload can authenticate to Vault using the Kubernetes authentication method.

Vault validates the Kubernetes service account identity against the Kubernetes API and maps that identity to an appropriate Vault role and policy.

Once authenticated, the workload can retrieve only the secrets permitted by its policy.

# The Authentication Workflow

Pod (Service Account Token) ] --------1. Send Token--------> [ Vault ]
             ^                                                    |

             |                                                    |
      4. Return Vault Token                                2. Validate Token

             |                                                    |
             |                                                    v
     [ Service Account ] <----------3. Token Valid? ---------- [ K8s API Server ]


Pod Requests Access: A container launches with a bound Service Account. The application (or a Vault sidecar/agent) sends this local Service Account token to the Vault /v1/auth/kubernetes/login endpoint.

Vault Verifies: Vault intercepts the token and passes it to the Kubernetes API Server using the TokenReview API.

K8s Approves: The Kubernetes API server checks if the token is valid, active, and belongs to the claimed Service Account.

Vault Issues Token: If Kubernetes validates the token, Vault maps the pod's Service Account to a pre-defined Vault Role and returns a short-lived Vault Client Token scoped with specific access policies.     

1. Enable Kubernetes Auth in Vault
   vault auth enable kubernetes

2. Configure Vault to Talk to your Kubernetes Cluster
   Vault needs credentials to call the Kubernetes TokenReview API.
   
   If Vault is running inside the same K8s cluster: It automatically reads the local service account token from its own container environment.
   
   If Vault is running outside the cluster: You must provide the Kubernetes API URL, the cluster's CA certificate, and a JWT token with system:auth-delegator permissions.

   vault write auth/kubernetes/config \
    kubernetes_host="https://cluster.local"

3. Create a Vault Mapping RoleCreate a role that links a specific Kubernetes Namespace and Service Account to a specific Vault Policy.
 vault write auth/kubernetes/role/jenkins-role \
    bound_service_account_names=jenkins-sa \
    bound_service_account_namespaces=jenkins \
    policies=jenkins-policy \
    ttl=1h

Security Benefit: Only a pod running as jenkins-sa inside the jenkins namespace can assume this role.

4. Authenticate from the Pod
   Inside your application or Jenkins pipeline running on Kubernetes, you can log in using a simple curl request, passing the automatically mounted token file:

   # Read the local K8s Service Account Token
K8S_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# Exchange it for a Vault Token
VAULT_TOKEN=$(curl --request POST \
    --data "{\"jwt\": \"$K8S_TOKEN\", \"role\": \"jenkins-role\"}" \
    https://example.com \
    | jq -r '.auth.client_token')


---

# Kubernetes Deployment YAML example using the Vault Agent Injector.

The injector uses a mutating webhook. By simply adding specific ://hashicorp.com annotations to your pod template, a sidecar container is automatically injected. 
This sidecar handles the Kubernetes authentication flow, fetches the secret, and writes it to a shared memory volume at /vault/secrets/.


---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: alpha-application
  namespace: jenkins           # Must match the namespace bound in the Vault role
spec:
  replicas: 1
  selector:
    matchLabels:
      app: alpha-app
  template:
    metadata:
      labels:
        app: alpha-app
      annotations:
        # 1. Enable the Vault Agent Injector webhook for this pod
        ://hashicorp.com: "true"

        # 2. Specify the Vault role configured for Kubernetes auth
        ://hashicorp.com: "jenkins-role"

        # 3. Define the secret path to fetch and the file name to write it to
        # Format: ://hashicorp.com-secret-[filename]: "[vault-path]"
        ://hashicorp.com-secret-config.txt: "secret/data/ci-cd/api-keys"

        # 4. Optional: Format the output file using a Consul Template (e.g., as env variables or JSON)
        ://hashicorp.com-template-config.txt: |
          {{- with secret "secret/data/ci-cd/api-keys" -}}
          export API_TOKEN="{{ .Data.data.token }}"
          export DB_PASSWORD="{{ .Data.data.password }}"
          {{- end -}}
    spec:
      # 5. Use the exact Service Account bound to your Vault role
      serviceAccountName: jenkins-sa
      containers:
        - name: app-container
          image: alpine:latest
          command: ["/bin/sh", "-c"]
          # 6. Source the injected file to read secrets natively as environment variables
          args:
            - |
              while true; do
                if [ -f /vault/secrets/config.txt ]; then
                  source /vault/secrets/config.txt
                  echo "Secrets loaded! API_TOKEN length is: ${#API_TOKEN}"
                else
                  echo "Waiting for Vault Agent to mount secrets..."
                fi
                sleep 10
              done
--- 

🔍 How this configuration functions

1. ://hashicorp.com: "true": This tells the Vault Injector to intercept this deployment and modify the pod definition at runtime.

2. The Shared Volume: The Vault Agent automatically mounts an InMem (RAM-backed) shared volume at /vault/secrets/. It is completely isolated inside the pod and never touches the host node's physical hard drive.

3. agent-inject-template: By default, Vault prints secrets in a raw Go template style. Adding the template annotation lets you structure the file. In this example, it structures it as export KEY="VALUE", allowing your application container to simply source /vault/secrets/config.txt to populate its environment variables

4. Auto-Renewal: The Vault Agent sidecar continues running in the background. If your secrets have a Time-To-Live (TTL) or get updated in Vault, the agent automatically refreshes the file on the fly without restarting your application pod.