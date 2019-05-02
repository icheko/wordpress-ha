#!/bin/bash -e

cd wordpress-ha-chart
helm package .
helm repo index .