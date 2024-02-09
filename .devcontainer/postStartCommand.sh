#!/usr/bin/env bash

# pull images to save time later
# for FL
df -h
docker system df

docker pull hasan7/fltest:0.0.0-cpu
docker pull mlcommons/miccai2023-tutorial-prep:0.0.0
# for evaluation
docker pull mlcommons/miccai2023-trained:1.0.0
docker pull mlcommons/miccai2023-metrics:0.0.0

# run medperf server
cd /medperf/server
cp .env.local.local-auth .env
# hotfix: use python3.9 in place of python
sed -i 's/python /python3.9 /g' setup-dev-server.sh
echo "Running a local MedPerf server"
nohup bash ./setup-dev-server.sh < /dev/null &>server.log &
sleep 30
if [ ! -f ".already_seeded" ]; then
    echo "Setting up the local database"
    python3.9 ./seed.py --demo benchmark
    touch .already_seeded
fi
medperf profile activate local