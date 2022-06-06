#!/usr/bin/python
import signal

def handler( sign, type ):
    pass

signal.signal(signal.SIGUSR1, handler)
signal.pause()