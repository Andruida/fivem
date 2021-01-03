for i in {$1..$2}; do
	i=0
	VER=$(cat artifacts.json | jq .[$i].build -r)
	NUM=$(cat artifacts.json | jq .[$i].version -r)
	docker build --build-arg "FIVEM_NUM=$NUM" --build-arg "FIVEM_VER=$VER" -t "andruida/fivem:$NUM" .
	docker push "andruida/fivem:$NUM"
done