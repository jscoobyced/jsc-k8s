# JSC k8s services

This is a sample setup for Wordpress or simple HTTP docker based images.

# Quick Start

## Secrets
Rename the `01-secret.example.yaml` files to `01-secret.yaml` and add your password to those files.
To generate the password in a terminal:
```
echo -n "YOUR_PASSWORD" | base64
```
then copy the output to the secret files.

## Domains
Edit and/or remove and/or add the domains in the [03-ingress.yaml](config/03-ingress.yaml) file. Edit and/or remove and/or add the `hosts` sections as well.

Edit the [02-certificates.yaml](config/02-certificates.yaml) file and set your email address to receive the SSL certificate updates

## Tools
You will need the following:
- kubectl
- helm
- you kubeconfig file setup

First we install our namespace to make things easy to filter:
```
kubectl --kubeconfig=path/to/kubeconfig apply -f config/01-namespace.yaml
```

Then we install and configure the ingress:
```
./config/install-ingress.sh
kubectl --kubeconfig=path/to/kubeconfig apply -f 03-ingress-k3s.yaml
```

If you don't have a cert-manager (for HTTPS), run the [install-cert-manager.sh](config/install-cert-manager.sh) to configure your cluster.

## Configure your pods

Now all you have to do is run the following minimum set:
```
kubectl --kubeconfig=path/to/kubeconfig apply -f config/01-namespace.yaml
kubectl --kubeconfig=path/to/kubeconfig apply -f config/02-certificates.yaml
kubectl --kubeconfig=path/to/kubeconfig apply -f config/03-ingress.yaml
kubectl --kubeconfig=path/to/kubeconfig apply -k hdc
```

The above will setup a Worpress instance with database. Both Worpress application and database will have their own volume for the data so restarting or re-configuring the pods will preserve the data.