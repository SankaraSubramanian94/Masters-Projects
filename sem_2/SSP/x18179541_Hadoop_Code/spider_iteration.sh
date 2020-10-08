#!/bin/bash



python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/initPageRank --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_1

python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_1 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_2
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_2 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_3
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_3 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_4
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_4 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_5
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_5 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_6
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_6 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_7
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_7 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_8
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_8 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_9
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_9 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_10
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_10 --graph-size 1183423 -o  hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_11
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_11 --graph-size 1183423 -o  hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_12
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_12 --graph-size 1183423 -o  hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_13
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_13 --graph-size 1183423 -o  hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_14
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_14 --graph-size 1183423 -o  hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_15
python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_15 --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank_16
