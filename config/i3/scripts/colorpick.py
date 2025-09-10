from Xlib import X, display
from PIL import ImageGrab

def get_click():
    dsp = display.Display()
    root = dsp.screen().root

    # Grab mouse click
    root.grab_pointer(True,
                      X.ButtonPressMask,
                      X.GrabModeAsync,
                      X.GrabModeAsync,
                      0, 0, X.CurrentTime)

    while True:
        event = dsp.next_event()
        if event.type == X.ButtonPress:
            dsp.ungrab_pointer(0)  # Correct: use 0, not time.time()
            return event.root_x, event.root_y

print("Click anywhere on the screen to pick a color.")

x, y = get_click()
img = ImageGrab.grab()
color = img.getpixel((x, y))
color_hex = f'{color[0]:x}' + f'{color[1]:x}' + f'{color[2]:x}'

print(f"Clicked at ({x}, {y}) - Color: RGB {color} - Hex: {color_hex}")
