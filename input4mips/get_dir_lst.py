import os.path, json, sys

obj=json.load(open(sys.argv[1]))
thekey = list(obj.keys())[0]
for x in set([os.path.dirname(x) for x in obj[thekey]["file_list"]]):
    print(x)
    