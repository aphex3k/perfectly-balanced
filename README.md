# Perfectly Balanced ⚖️

![image](https://user-images.githubusercontent.com/88283485/130841235-3e8901c5-3477-4107-b15f-f284a06a9665.png)

Script to attempt and make your LND node pefectly balanced as all things should be. (without throwing all economic considerations out of the window)
Inspired by [Igniter](https://github.com/RooSoft/igniter), [rebalance-lnd](https://github.com/C-Otto/rebalance-lnd) and [Balance Of Satoshi](https://github.com/alexbosworth/balanceofsatoshis)
Based on (abandoned?) [perfectly-balanced](https://github.com/cuaritas/perfectly-balanced)

## Requirements:

Almost all included by default in most linux distros:

- `bash`
- `python3`
- `pip`
- `bc`
- `wget`
- `unzip`

Make sure your LND path is located or linked to `$HOME/.lnd`

## Usage

Not need to edit anything, just run it! 🚀

```
Usage: ./perfectlybalanced.sh {-v|-h|-r=MAX_PPM|-t=TOLERANCE|-n=THREADS|list|rebalance}

Optional:
        -v, --version
                Shows the version for this script

        -h, --help
                Shows this help

        -i=CHANNEL_ID, --ignore=CHANNEL_ID
                Ignores a specific channel id useful only if passed before 'list' or 'rebalance'
                It can be used many times and should match a number of 18 digits

        -r=MAX_PPM, --max-fee-rate=MAX_PPM
                (Default: 10) Changes max fee rate useful only if passed before 'list' or 'rebalance'

        -t=TOLERANCE, --tolerance=TOLERANCE
                (Default: 0.95) Changes tolerance useful only if passed before 'rebalance'

        -n=THREADS, --number-of-threads=THREADS
                (Default: 8) maximum number of threads used for the multi-threaded functionality

list:
        Shows a list of all channels in compacted mode using 'rebalance.py -c -l'
        for example to: './perfectlybalanced.sh --tolerance=0.99 list'

rebalance:
        Tries to rebalance unbalanced channels with default max fee of 50 and tolerance 0.95
        for example to: './perfectlybalanced.sh --max-fee=10 --tolerance=0.98 rebalance'
```

## Examples

List all channels within tolerance 0.92:

`./perfectlybalanced.sh --tolerance=0.92 list`

or

`./perfectlybalanced.sh -t=0.92 list`

Default list within tolerance 0.95:

`./perfectlybalanced.sh list`

Unbalanced channels being rebalanced max fee 10 sats and tolerance 0.97:

`./perfectlybalanced.sh --max-fee-rate=10 --tolerance=0.97 rebalance`

or

`./perfectlybalanced.sh -r=10 -t=0.97 rebalance`


Default max fee 50 sats and tolerance 0.95:

`./perfectlybalanced.sh rebalance`

Rebalance with max fee 10 sats and tolerance 0.98, ignoring channel id '761128128258703361':

`./perfectlybalanced.sh --ignore=761128128258703361 -t=0.98 -r=10 rebalance`

![image](https://user-images.githubusercontent.com/88283485/131256805-edf995b9-3307-4e10-900c-e9d92a7908b1.png)

## Contribute

Feel free to collaborate with code or donate a few Satoshi ⚡ 😄

[LNURL1DP68GUP69UHK6CT4VD4K26N9D4EX7M3JXEKHSEMDXA4NVENDDENHSER5XEUKYME5VVMHWVMTX4UXGUMVD35H5VNWV4KHJUMVWD5KGTN0DE5K7M30D3H82UNVWQHKZURF9AMRZTMVDE6HYMP0XULPLCCR](http://mauckejemron26mxgm7k6fmngxdt6ybo4c7w3k5xdslliz2nemyslsid.onion/lnurlp/7)
