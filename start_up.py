from playsound import playsound
import os

path=os.path.abspath(os.path.expanduser(os.path.expandvars("~/all_media/lnch.mp3")))

playsound(path)
