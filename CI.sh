#!/bin/sh
. ~/.bashrc

app_name=$1
app_version=$2

export ARGOCD_SERVER='https://localhost:8080'
export ARGOCD_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJkZXBsb3ktYWdlbnQ6YXBpS2V5IiwibmJmIjoxNzMyODc1NzEzLCJpYXQiOjE3MzI4NzU3MTMsImp0aSI6IjA2MDEwZGY1LTg3NDUtNGMzNi1iMDg2LTM4OWJiODE5NDhjZCJ9.8W_KF3HnhpfGG3hrtl4sqvhi9fgJvUsWm8utdUwWlI0"


argocd app get $app_name --auth-token "$ARGOCD_TOKEN"
if [ $? -ne 0 ]
then
    echo "l'application $app_name n'existe pas"
    exit 1
fi

argocd app set $app_name --parameter image.tag=$app_version --auth-token "$ARGOCD_TOKEN"
if [ $? -ne 0 ]
then
    echo "Echec du changement de version de $app_name. Version cible $app_version"
    exit 1
fi

argocd app sync $app_name --auth-token "$ARGOCD_TOKEN"
if [ $? -ne 0 ]
then
    echo "Echec de la synchronisation de $app_name. Version cible $app_version"
    exit 1
fi

argocd app wait $app_name --auth-token "$ARGOCD_TOKEN"
