# Dependencies to Run the Notebooks

We need to make sure we have the dependencies installed working in Python3.

## Create a Virtual Environment

Please, always use some kind of virtual environment, so that the installed libraries don't interfere with the system Python installation. Let's call it `nlp`. 

There are multiple ways of doing this, but the current standard way seems to be using the `venv` module:

    python3 -m venv nlp
    source nlp/bin/activate


If you'd rather use `conda`, check the documentation, but the following should work:

    conda create -n nlp python=3.6 anaconda
    source activate nlp


On linux, I prefer to handle virtual environments with `virtualenvwrapper` and just type once:

    mkvirtualenv -p /usr/bin/python3 nlp

And then, enable the environment with the following commands:

    workon nlp

In all cases, you can disable the current virtual environment with the
following command:

    deactivate


## `nltk`

Install `nltk` and download some data collections and models:

    pip install nltk
    python -m nltk.downloader book
    python -m nltk.downloader cess_esp


## `textblob`

Just run:

    pip install textblob


## `spaCy`

To install `spaCy` and download at least some common models (for Spanish and English), run:

    pip install spacy
    python -m spacy download es_core_news_md
    python -m spacy download en_core_web_md

If you have any problems with these two last commands, try to install the models as if they were Python libraries. Run:

    pip install https://github.com/explosion/spacy-models/releases/download/es_core_news_md
    pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_md


## `flair`

Install `flair` by running:

    pip install flair


Notice that additional pretrained models will be downloaded, if needed. This may take a while.


## `gensim`

Just run:

    pip install gensim


## PyTorch, BERT and OpenAI language models

Install some initial requirements:

    pip install numpy torchvision_nightly

If you have a CPU-only computer, install:

    pip install torch_nightly -f https://download.pytorch.org/whl/nightly/cpu/torch_nightly.html

If you are lucky enough to have a GPU, check the [Pytorch Get Started page](https://pytorch.org/get-started/locally/).

Finally, install the PyTorch version of BERT pretrain models.

    pip install pytorch_pretrained_bert

