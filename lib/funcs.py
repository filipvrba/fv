import sys
import json


def generate_dics(arg):
    obj = { "funcs": [] }

    exec(f"import {arg}")

    type_str = f"dir({arg})"
    dirs = eval(type_str)
    for var in dirs:
        try:
            funcs_str = f"{arg}.{var}"
            funcs = eval(funcs_str)
            typ = type( funcs )
            obj["funcs"].append({
                "name": var,
                "type": {
                    "name": typ.__name__,
                    "class": typ.__class__.__name__
                }
            })
        except:
            pass
    return obj


def p_json(obj):
    json_data = json.dumps(obj, indent=4)
    print(json_data)


def main(args):
    name = args[0]

    funcs = generate_dics(name)
    p_json(funcs)


if __name__ == "__main__":
    main(sys.argv[1:])