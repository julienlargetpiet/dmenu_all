#!/bin/python3

from playsound import playsound

import os

path=os.path.abspath(os.path.expanduser(os.path.expandvars("~/all_media/error.wav")))

playsound(path)
