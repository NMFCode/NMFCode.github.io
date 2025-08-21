cd src
git pull
cd ..\publications
python bib.py
cd ..
DOCFX_SOURCE_BRANCH_NAME=main docfx
