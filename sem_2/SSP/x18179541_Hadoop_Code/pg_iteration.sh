#!/bin/bash


python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_20/ --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_1/

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_1/ --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_2

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_2 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_3

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_3 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_4

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_4 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_5

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_5 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_6

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_6 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_7

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_7 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_8

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_8 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_9

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_9 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_10

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_10 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_11

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_11 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_12

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_12 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_13

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_13 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_14

python3 /home/sankar_hadoop/pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/pageRank_14 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank_15


