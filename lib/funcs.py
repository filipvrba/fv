import sys
import json


def generate_dics(arg):
    obj = { arg: [] }

    try:
        exec(f"import {arg}")
    except Exception as e:
        obj[arg].append({
            "error": str(e)
        })
        return obj

    type_str = f"dir({arg})"
    dirs = eval(type_str)
    for var in dirs:
        try:
            funcs_str = f"{arg}.{var}"
            funcs = eval(funcs_str)
            typ = type( funcs )
            obj[arg].append({
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