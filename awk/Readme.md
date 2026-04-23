awk '$4 == "A" {print $1, $2, $3}' data.txt

awk '{sum[$2]+=$3; count[$2]++} END {for (c in sum) print c, sum[c]/count[c]}' data.txt

awk '{count[$1]++} END {for (name in count) print name, count[name]}' data.txt