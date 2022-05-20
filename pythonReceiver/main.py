import numpy
import soundcard as sc
import soundfile as sf

# get a list of all speakers:
# speakers = sc.all_speakers()
# get the current default speaker on your system:
default_speaker = sc.default_speaker()

default_mic = sc.default_microphone()
sample, samplerate = sf.read('/Users/alfonso/Desktop/test.wav')

# print(sample, samplerate)

# data = default_mic.record(numframes=44100, samplerate=44100, channels=[0])
# data = default_mic.record(samplerate=44100, numframes=48000)
# print(data)

# default_speaker.play(data/numpy.max(data), samplerate=44100)
# default_speaker.play(data, samplerate=48000, channels=[0])
# print(samplerate)
# default_speaker.play(sample, samplerate=samplerate)

with default_mic.recorder(samplerate=44100, channels=[0, 1]) as mic, \
        default_speaker.player(samplerate=44100, channels=[0, 1]) as sp:
    while True:
        data = mic.record(numframes=1024)
        sp.play(data)

# print(default_mic)
