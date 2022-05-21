import asyncio
import websockets
import soundcard as sc
import numpy as np
from io import BytesIO

def pack_frame(frame):
    f = BytesIO()
    np.savez_compressed(f, frame=frame)
    
    packet_size = len(f.getvalue())
    header = '{0}:'.format(packet_size)
    header = bytes(header.encode())  # prepend length of array

    out = bytearray()
    out += header
    f.seek(0)
    out += f.read()
    return out

async def sender():
    async for websocket in  websockets.connect("ws://localhost:8765"):
        default_mic = sc.default_microphone()

        with default_mic.recorder(samplerate=44100, channels=[0, 1]) as mic:
            while True:
                data = mic.record(numframes=44100)
                await websocket.send(pack_frame(data))

        # await websocket.send("hello world")
        # await websocket.recv()

asyncio.run(sender())
