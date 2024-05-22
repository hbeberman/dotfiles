
source <(kubectl completion bash)
alias k="kubectl"
complete -F __start_kubectl k

alias azl="az login --use-device-code"

kdebug() {
  kubectl debug node/$1 -it --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11 -- chroot /host /bin/bash
}

kns() {
# Check if the first argument is a valid node number (between 0 and 9)
if [[ "$1" =~ ^[0-9]$ ]]
then
  NODE="$1"
else
  echo Invalid argument, defaulting to node 0
  NODE=0
fi

# Get the name of the first node in the cluster and trim the last character
node_name=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | sed 's/.$//')

MYNODE="$node_name$NODE"

echo "Connecting to node $MYNODE"

kubectl node-shell "$MYNODE"
}

getcred() {
  az aks get-credentials -g $1 -n $2
}

kwatch() {
  watch -n1 kubectl get nodes -o wide
}

byoi(){
echo "--aks-custom-headers AKSHTTPCustomFeatures=Microsoft.ContainerService/UseCustomizedOSImage,OSImageSubscriptionID=109a5e88-712a-48ae-9078-9ca8b3c81345,OSImageResourceGroup=AKS-CBLMariner,OSImageGallery=AKSCBLMariner,OSImageName=V2gen2,OSImageVersion=$1"
}

fssh(){
  local ip_address=$1
  ssh azureuser@$ip_address
  if [ $? -ne 0 ]; then
    echo "SSH connection failed, removing known host and trying again..."
    ssh-keygen -f "/home/$(whoami)/.ssh/known_hosts" -R "$ip_address"
    ssh azureuser@$ip_address
  fi
}

export AZL=MicrosoftCBLMariner:cbl-mariner:cbl-mariner-2-gen2:latest

export AZCOPY_AUTO_LOGIN_TYPE=AZCLI
