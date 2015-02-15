
import sys
import PIL.Image as Image


def main(argv):
    fn = argv[1]
    im = Image.open(fn)
    size = im.size
    hpad = "\0\0" * (800 - size[0])
    vpad = ("\0\0" * 800) * (600 - size[1])
    out = open(argv[2], 'wb')
    for i, pixel in enumerate(im.getdata()):
        x = i % size[0]
        y = i / size[0]
        lower_pixel = [val / 17 for val in pixel]
        if len(lower_pixel) == 3:
            lower_pixel.append(0)

        out.write(chr((lower_pixel[3] << 4) | lower_pixel[2]))
        out.write(chr((lower_pixel[1] << 4) | lower_pixel[0]))

        if x == size[0] - 1:
            out.write(hpad)

    out.write(vpad)

    out.close()



main(sys.argv)
