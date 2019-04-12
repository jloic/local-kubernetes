#fix network on ubuntu
kubectl apply --filename https://git.io/weave-kube-1.6

#allow to deploy public pods to the master
kubectl taint nodes --all node-role.kubernetes.io/master-

#create the ingress controller, listen hostNetwork=true
kubectl apply -f ingress_nginx_controller.yaml

#configure dns forwarding
kubectl apply -f kube-dns.yaml

#create storage class local storage
kubectl apply -f local-storage.yml

#create the dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

#create an admin user
kubectl create -f admin_user.yml
kubectl create -f admin_role.yml

#generate a password
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') > admin_secret_token
