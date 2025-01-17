source .venv/bin/activate
pip install -r requirements.txt


continue_script=false

# Loop through all the arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --continue)
            continue_script=true
            shift
            ;;
        *)
            # Ignore unknown options
            shift
            ;;
    esac
done


if [ "$continue_script" = false ]; then

    rm -f unique_links.txt
    rm -f links.txt
    rm -f imports.txt
    rm -f .checkpoint
    if [ -d reps ];then rm -rf reps ; fi 
    python3 scripts/query.py 1

else
    page=$(cat .checkpoint)
    python3 scripts/query.py $page
fi

python3 scripts/delete_duplicates.py
python3 scripts/clone_all.py
. scripts/list_imports.sh
python3 scripts/extract.py

python3 generate_table.py > dependency.md

echo "# Awesome FastAPI Projects

> **Warning**
> If you want to help me to maintain this project, please send a message on https://github.com/Kludex/awesome-fastapi-projects/issues/16.
> I'll happily onboard you.

The aim of this repository is to have an organized list of projects that use FastAPI.

If you're looking for FastAPI content, you might want to check [Awesome FastAPI](https://github.com/mjhea0/awesome-fastapi).

---

" > README.md

more dependency.md >> README.md

echo "

## Contributing

Pull requests are welcome." >> README.md