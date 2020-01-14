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
                                print("VALIDATION SUCCEED")
                except jsonschema.exceptions.ValidationError as ve:
                        print("VALIDATION FAILED \n-----------------")
                        retstr = ''
                        for ch in str(ve):
                                if ch == '\n':
                                        break
                                retstr += ch
                        print(retstr)
                        with open("report.log","a") as r:
                                r.write(str(ve))
                        print("Watch report.log")
                        
