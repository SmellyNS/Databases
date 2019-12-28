import jsonschema
from jsonschema import validate
import os
import json

path_schema = './schema'


schemafiles = []
for r, d, f in os.walk(path_schema):
	for file in f:
		if file.endswith('.json'):
			schemafiles.append(path_schema+"/"+file)

for schemafile in schemafiles:
        with open(schemafile) as g:
                try:
                        print(schemafile[9:]+" >>>  ",end="")
                        with open("data.json") as data:
                                data = json.loads(data.read())
                                validate(data, json.loads(g.read()))
                                print("SUCCESS")
                except jsonschema.exceptions.ValidationError as ve:
                        print("FAULT")
