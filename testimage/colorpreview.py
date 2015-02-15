
import PIL.Image as Image
import PIL.ImageDraw as ImageDraw

im_color = Image.new("RGB", (64, 64))
im_grey = Image.new("RGB", (16, 16))
im_gui = Image.new("RGB", (640, 480))

def generate_color():
    for y in xrange(0, 64):
        for x in xrange(0, 64):
            r = x % 16
            g = y % 16
            b = (x / 16) + 4 * (y / 16)
            yield (r * 17, g * 17, b * 17)

def generate_grey():
    for y in xrange(0, 16):
        for x in xrange(0, 16):
            yield (x * 17, x * 17, x * 17)

def draw_gui_mock(im):
    draw = ImageDraw.Draw(im)
    white = (15 * 17, 15 * 17, 15 * 17)
    black = (0, 0, 0)
    grey = (8 * 17, 8 * 17, 8 * 17)
    blue = (3 * 17, 6 * 17, 9 * 17)

    draw.rectangle(((0, 0),(639, 479)), grey, grey)
    draw.rectangle(((0, 0),(639, 20)), white, white)
    draw.line(((0, 20), (639, 20)), black, 1)

    draw.rectangle(((100, 100), (200, 120)), blue, blue)
    draw.line(((100, 100), (200, 100)), white, 1)
    draw.line(((100, 100), (100, 120)), white, 1)
    draw.line(((100, 120), (200, 120)), black, 1)
    draw.line(((200, 100), (200, 120)), black, 1)

im_color.putdata(list(generate_color()))
im_color.save("colorpreview.png")

im_grey.putdata(list(generate_grey()))
im_grey.save("greypreview.png")

draw_gui_mock(im_gui)
im_gui.save("guipreview.png")
