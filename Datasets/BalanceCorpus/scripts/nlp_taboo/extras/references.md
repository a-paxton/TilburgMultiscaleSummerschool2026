# NLP track — references

Real, Crossref-verified references for the methods used across the NLP notebooks. Each DOI was
checked against the Crossref API. Cite the ones relevant to the notebook you build on.

1. **Reimers, N., & Gurevych, I. (2019).** Sentence-BERT: Sentence Embeddings using Siamese
   BERT-Networks. *Proceedings of EMNLP-IJCNLP 2019.* https://doi.org/10.18653/v1/D19-1410
   — the sentence-embedding method behind semantic homing (Nb 2) and topic modeling (Nb 5).

2. **Pickering, M. J., & Garrod, S. (2004).** Toward a mechanistic psychology of dialogue.
   *Behavioral and Brain Sciences, 27*(2), 169–190. https://doi.org/10.1017/S0140525X04000056
   — the interactive-alignment theory the lexical-alignment notebook (Nb 3) tests.

3. **Ireland, M. E., & Pennebaker, J. W. (2010).** Language style matching in writing: Synchrony
   in essays, correspondence, and poetry. *Journal of Personality and Social Psychology, 99*(3),
   549–571. https://doi.org/10.1037/a0020386
   — the Linguistic Style Matching (LSM) measure computed directly in Nb 3.

4. **Brennan, S. E., & Clark, H. H. (1996).** Conceptual pacts and lexical choice in conversation.
   *Journal of Experimental Psychology: Learning, Memory, and Cognition, 22*(6), 1482–1493.
   https://doi.org/10.1037/0278-7393.22.6.1482
   — lexical entrainment / how partners settle on shared terms; the core of the Taboo naming task.

5. **Blei, D. M. (2012).** Probabilistic topic models. *Communications of the ACM, 55*(4), 77–84.
   https://doi.org/10.1145/2133806.2133826
   — the topic-modeling backdrop for Nb 5.

## Also relevant

- **Reimers, N., & Gurevych, I. (2020).** Making Monolingual Sentence Embeddings Multilingual using
  Knowledge Distillation. *Proceedings of EMNLP 2020.* https://doi.org/10.18653/v1/2020.emnlp-main.365
  — the paper for the exact multilingual MiniLM model the notebooks load.

## Not in Crossref (cite by arXiv ID)

These two tools are used in the track but are arXiv-only preprints with no Crossref DOI:

- **Radford, A., et al. (2022).** Robust Speech Recognition via Large-Scale Weak Supervision
  (Whisper). arXiv:2212.04356 — the ASR model in Nb 1 (via faster-whisper).
- **Grootendorst, M. (2022).** BERTopic: Neural topic modeling with a class-based TF-IDF procedure.
  arXiv:2203.05794 — the embed → cluster → c-TF-IDF recipe Nb 5 reimplements by hand.
