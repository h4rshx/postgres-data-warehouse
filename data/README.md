# Olist data (not committed)

Put the 9 CSV files from the Olist dataset in this folder. Everything here except this README is git-ignored.

**Option 1, website:** open https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce, click Download, and unzip the files here.

**Option 2, Kaggle CLI** (needs a Kaggle API token, from Kaggle > Settings > API):

```bash
pip install kaggle
kaggle datasets download -d olistbr/brazilian-ecommerce -p data --unzip
```

Inside the Docker container this folder is mounted read-only at `/data`, so `\copy` reads from `/data/<file>.csv`.
