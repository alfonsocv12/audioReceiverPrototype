import asyncio
import websockets
import numpy as np
from io import BytesIO
import soundcard as sc

default_speaker = sc.default_speaker()

async def echo(websocket):
    async for message in websocket:
        data = np.frombuffer(message, dtype=np.float64)
        with default_speaker.player(samplerate=44100, channels=[0, 1]) as sp:
            sp.play(data)


async def main():
    async with websockets.serve(echo, "localhost", 8765):
        await asyncio.Future()  # run forever

asyncio.run(main())
