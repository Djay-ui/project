#!/bin/bash
sed "s/tagVersion/$1/g" node-deployment.yml > node-deployment.yaml
sed "s/tagVersion/$1/g" pods.yml > pods.yaml
