# Thursday: Masking & Anonymizing Audiovisual Data

**Instructor:** Babajide Owoyele (Radboud University / SYNAPSIS)

## Overview

This full-day session covers privacy-preserving techniques for behavioral research video. Participants will learn to mask (de-identify) video data using open-source tools, evaluate how masking affects downstream analysis, and make informed decisions about masking strategies for their own research.

## Running Dataset

We use the **triadic concept generation dataset** (CDR Stanford, Edelman 2011) as the primary hands-on example: 14 teams of 3 students collaboratively redesigning a product, recorded from multiple camera angles. This multi-person, gesture-rich data presents real-world masking challenges.

## Schedule

| Time | Session | Format |
|------|---------|--------|
| 10:00-10:30 | SYNAPSIS Infrastructure + The Triadic Concept Generation Dataset | Lecture |
| 10:30-10:55 | Why Mask? The Privacy-Utility Dilemma | Lecture + Discussion |
| 10:55-11:20 | Masking Operations Taxonomy | Lecture + Demo |
| 11:20-12:05 | MaskAnyone: Architecture & Hands-On | Hands-on |
| 12:05-12:30 | MaskBench: Did Your Masking Break Your Data? | Hands-on |
| 12:30-13:00 | Lunch | |
| 13:00-13:30 | Bring-Your-Own-Video + Audio Masking | Hands-on |
| 13:30-13:45 | Archiving & Sharing | Lecture + Demo |
| 13:45-14:00 | Wrap-Up & Integration with Group Projects | Discussion |

## Requirements

Participants need:
- A laptop with a modern web browser (Chrome or Firefox)
- WiFi access (provided)
- Optionally: Python 3.10+ for the MaskBench evaluation exercise

No GPU or Docker installation required -- all masking runs on a remote server via web interface.

## Tools

- **MaskAnyone** -- open-source video masking platform (YOLO + SAM2 + pose estimation)
- **MaskBench** -- benchmarking framework for evaluating masking quality
- **SYNAPSIS infrastructure** -- hosted on Radboud HPC (Ponyland)

## Key References

- Owoyele et al. (2026). MaskingOPS: A Tutorial for Masking Operations in Behavioral Research. *Behavior Research Methods*. (under review)
- Owoyele, Riedel, Shaik et al. (2026). MaskBench: Privacy-Preserving Pose Estimation Benchmarking. *Behavior Research Methods*. (under review)
- Edelman, J. (2011). Understanding Radical Breaks: Media and Behavior in Small Teams Engaged in Redesign Scenarios. PhD dissertation, Stanford University.

## Connection to Other Days

| Day | Topic | Thursday Connection |
|-----|-------|---------------------|
| Monday | Motion tracking | Masking affects the tracking you learned |
| Tuesday | Acoustic analysis | Audio masking connects to prosodic analysis |
| Wednesday | Pose estimation | MaskBench evaluates pose on masked video |
| **Thursday** | **Masking & anonymization** | **This day** |
| Friday | Group projects | Incorporate masking into your project |
