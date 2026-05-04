def what(file, h=None):
    f = None
    try:
        if h is None:
            if isinstance(file, str):
                f = open(file, 'rb')
                h = f.read(32)
            else:
                location = file.tell()
                h = file.read(32)
                file.seek(location)
                f = None
        for tf in tests:
            res = tf(h, f)
            if res:
                return res
    finally:
        if f: f.close()
    return None

tests = []

def test_jpeg(h, f):
    if h[0:2] == b'\xff\xd8':
        return 'jpeg'

tests.append(test_jpeg)

def test_png(h, f):
    if h.startswith(b'\x89PNG\r\n\x1a\n'):
        return 'png'

tests.append(test_png)

def test_gif(h, f):
    if h.startswith(b'GIF87a') or h.startswith(b'GIF89a'):
        return 'gif'

tests.append(test_gif)
