"""Banner GIF: 4 random corpus videos side by side (tracking + gesture detection).

    python make_banner.py --corpus ../..

Picks 2 random clips from motiontracking/Output_Videos and 2 random *labeled*.mp4
from gestureclassifications, trims the same window from each, and hstacks them.

Needs ffmpeg on PATH.
"""

import argparse
import glob
import os
import random
import subprocess


def pick(pattern, n, rng):
    files = glob.glob(pattern, recursive=True)
    if len(files) < n:
        raise SystemExit(f"found {len(files)} files for {pattern}, need {n}")
    return rng.sample(files, n)


def build_filter(n, start, dur, h, fps, colors):
    chains = "".join(
        f"[{i}:v]trim=start={start}:duration={dur},setpts=PTS-STARTPTS,"
        f"fps={fps},scale=-2:{h},setsar=1[v{i}];"
        for i in range(n)
    )
    inputs = "".join(f"[v{i}]" for i in range(n))
    return (
        f"{chains}{inputs}hstack=inputs={n}[s];"
        f"[s]split[a][b];[a]palettegen=max_colors={colors}[p];"
        f"[b][p]paletteuse=dither=bayer"
    )


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--corpus", default="../..")
    ap.add_argument("--out", default="./images/banner.gif")
    ap.add_argument("--start", type=float, default=3.0)
    ap.add_argument("--duration", type=float, default=4.0)
    ap.add_argument("--height", type=int, default=220)
    ap.add_argument("--fps", type=int, default=12)
    ap.add_argument("--colors", type=int, default=128)
    ap.add_argument("--seed", type=int, default=None)
    args = ap.parse_args()

    rng = random.Random(args.seed)
    tracking = pick(f"{args.corpus}/motiontracking/Output_Videos/*.mp4", 2, rng)
    gesture  = pick(f"{args.corpus}/gestureclassifications/**/*labeled*.mp4", 2, rng)
    clips = tracking + gesture

    for c in clips:
        print("  ", os.path.basename(c))

    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)

    cmd = ["ffmpeg", "-y"]
    for c in clips:
        cmd += ["-i", c]
    cmd += [
        "-filter_complex",
        build_filter(len(clips), args.start, args.duration,
                     args.height, args.fps, args.colors),
        "-loop", "0", args.out,
    ]
    subprocess.run(cmd, check=True)

    mb = os.path.getsize(args.out) / 1e6
    print(f"wrote {args.out} ({mb:.1f} MB)")
    if mb > 5:
        print("large for a web banner - lower --height, --fps, --colors, or --duration")


if __name__ == "__main__":
    main()