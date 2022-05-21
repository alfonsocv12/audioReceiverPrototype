import asyncio
import websockets
import numpy as np
from io import BytesIO
import soundcard as sc

default_speaker = sc.default_speaker()

def unpack_data(data):
    frameBuffer = data
    length_str, ignored, frameBuffer = frameBuffer.partition(b':')
    length = int(length_str)

    return np.load(BytesIO(frameBuffer))['frame']
    

async def echo(websocket):
    async for message in websocket:
        data = unpack_data(message)
        with default_speaker.player(samplerate=44100, channels=[0, 1]) as sp:
            sp.play(data)


async def main():
    async with websockets.serve(echo, "0.0.0.0", 8765):
        await asyncio.Future()  # run forever

asyncio.run(main())
