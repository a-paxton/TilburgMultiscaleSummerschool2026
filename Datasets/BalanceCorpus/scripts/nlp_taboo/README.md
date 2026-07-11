# NLP track — Language in the Taboo Balance Corpus

A short track that goes from **raw audio → transcripts → meaning → interpersonal coordination →
themes**, using the Balance Corpus (dyads playing Taboo while standing on a balance board vs. on
the ground). Everything runs **CPU-only** — no GPU needed. Models are multilingual (the game is in
English, but with many non-native speakers).

**New here? Start with [`NLP_overview.ipynb`](NLP_overview.ipynb)** — the front door. It frames the
dataset, runs a compact live demo of every stage on a few trials, and links to the deep dives below.

## The notebooks

| # | Notebook | What it does | Needs |
|---|----------|--------------|-------|
| — | `NLP_overview.ipynb` | **Start here.** One-page tour: live mini-demo of all five stages + links. | audio (few trials) |
| 0 | `00_dataset_preview.ipynb` | **Zero-setup preview** (no audio): spaCy part-of-speech tagging of the target/taboo words + a **semantic network graph** of the whole game. Great first look / poster visual. | metadata only |
| 1 | `01_audio_to_transcripts.ipynb` | `faster-whisper` turns each trial's **stereo** audio into **role-labeled** transcripts (each channel is one speaker; the clue-giver is read from metadata; mic crosstalk removed). Saves `transcripts/`. | audio |
| 2 | `02_semantic_homing.ipynb` | Do the clue-giver's words steadily approach the **target** word in meaning? Taboo-boundary pressure; board-vs-ground contrast. | Nb 1 output |
| 3 | `03_lexical_alignment.ipynb` | Do the two partners **converge**? Lexical reuse, Linguistic Style Matching (LSM), semantic turn-coupling. | Nb 1 output |
| 4 | `04_multimodal_bonus.ipynb` *(advanced)* | Line language up with **gesture bouts** and **board sway** on one trial clock — the multiscale picture. | Nb 1 output + gyroscope/gesture data |
| 5 | `05_topic_modeling.ipynb` | **Topic modeling** of clue-giving language: embed → cluster → label with distinctive words (c-TF-IDF), using lightweight scikit-learn. | Nb 1 output |

Notebooks 0 and 1 are the two entry points: **0** needs nothing but the metadata; **1** creates the
transcripts that **2–5** consume. Run **1** with `MAX_TRIALS = None` before 2–5 for the full picture.

## Setup

**Conda (recommended):**
```bash
conda env create -f environment.yml
conda activate mdig-nlp
python -m ipykernel install --user --name mdig-nlp
```
**pip:**
```bash
pip install -r requirements.txt
```

First run downloads two models (~0.5 GB each): Whisper `small` and a multilingual
sentence-embedding model. This happens once and is then cached.

## How to run

1. Open **Notebook 1**. It transcribes a small `MAX_TRIALS` subset by default so the first run
   is quick; set `MAX_TRIALS = None` to do all 80 trials, then re-run. Output lands in
   `transcripts/` (git-ignored — each user generates their own).
2. Run Notebooks 2, 3, and 4. They read `transcripts/transcripts_all.csv`.

## Notes & caveats

- Only **2 dyads** currently have media on disk (80 trials, ~25 min of audio), so all results are
  **exploratory / hypothesis-generating** — read effect *shapes*, not significance. The same code
  scales to the full corpus on Zenodo.
- Join keys are consistent throughout: `pair_id` + `trial_number`, with all times **trial-relative
  (0 s = trial start)**.
- Speaker separation is free because each stereo channel is a separate lavalier mic
  (verified in Notebook 1).
