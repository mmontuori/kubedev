#!/bin/bash


kubectl port-forward svc/nginx --address 0.0.0.0 8080:8080
