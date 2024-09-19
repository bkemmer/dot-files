setup:
    pip install --upgrade pip
    pip install -r requirements.txt

lint:
    ruff check --fix
    ruff format

test:
    pytest tests/

cov:
    coverage run --parallel -m pytest tests/
    coverage combine
    coverage lcov -o lcov.info