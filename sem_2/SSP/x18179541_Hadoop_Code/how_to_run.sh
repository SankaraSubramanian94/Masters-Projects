nohup python3 linkgraph.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/input/link_10.txt -o hdfs://x18179541-hadoop-master:9000/user/output/link_graph/ > nohup.log &

nohup python3 graphsize.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/link_graph -o hdfs://x18179541-hadoop-master:9000/user/output/graphsize > nohup_1.log &

nohup python3 initPageRank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/link_graph --graphsize 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/initPageRank > nohup_2.log &

nohup python3 dangling_link.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/initPageRank -o hdfs://x18179541-hadoop-master:9000/user/output/dangling > nohup_3.log &

nohup python3 pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/initPageRank --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/pageRank > nohup_4.log &

nohup python3 pagerank_dangling.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/initPageRank --graph-size 1183423 --dangling-node-pr 0.7931779254067588 -o hdfs://x18179541-hadoop-master:9000/user/output/pagerank_dangling > nohup_5.log &

nohup python3 spider_trap_pagerank.py -r hadoop --hadoop-bin /opt/hadoop/bin/hadoop hdfs://x18179541-hadoop-master:9000/user/output/initPageRank --graph-size 1183423 -o hdfs://x18179541-hadoop-master:9000/user/output/spider_trap_pagerank > nohup_6.log &