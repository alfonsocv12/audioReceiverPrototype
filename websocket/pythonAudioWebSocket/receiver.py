import asyncio
import websockets
import numpy as np
from io import BytesIO
import soundcard as sc

default_speaker = sc.default_speaker()

__play_stack = []
running = False

def unpack_data(data):
    frameBuffer = data
    length_str, ignored, frameBuffer = frameBuffer.partition(b':')
    length = int(length_str)

    return np.load(BytesIO(frameBuffer))['frame']

def play_stack():
    with default_speaker.player(samplerate=44100, channels=[0, 1]) as sp:
        running = True
        while len(__play_stack) > 0:
            current_data = __play_stack.pop(0)
            sp.play(current_data)
    running = False


def play_message(data):
    __play_stack.append(data)
    if len(__play_stack) == 1 and not running:
        play_stack()
    

async def echo(websocket):
    async for message in websocket:
        data = unpack_data(message)
        play_message(data)


async def main():
    async with websockets.serve(echo, "0.0.0.0", 8765, ping_interval=None):
        await asyncio.Future()  # run forever

asyncio.run(main())
