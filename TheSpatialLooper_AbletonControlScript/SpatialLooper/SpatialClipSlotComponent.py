from _Framework.ClipSlotComponent import ClipSlotComponent
from .SpatialLooperSysExMap import *

class SpatialClipSlotComponent(ClipSlotComponent):

    clipSlotID = None

    def __init__(self, *a, **k):
        (super(SpatialClipSlotComponent, self).__init__)(*a, **k)



    def update(self, *args, **kwargs):
        super().update(*args, **kwargs)

        self.clipColorChangeCallback()
        self.clipPresenceChangeCallback()



    def set_launch_button(self, *args, **kwargs):
        super().set_launch_button(*args, **kwargs)
        self.clipSlotID = args[0].original_identifier()



    def clipColorChangeCallback(self):
        if self._clip_slot == None or self._clip_slot.clip == None:
            return

        if self.clipSlotID == None:
            return

        color = self._clip_slot.clip.color

        redComponent = (color) >> 16 % 0x100
        greenComponent = (color >> 8) % 0x100
        blueComponent = color % 0x100

        # SpatialLooper reduces color information to 7 bit to fit in with SysEx specification.
        redComponentMIDI = redComponent // 2
        greenComponentMIDI = greenComponent // 2
        blueComponentMIDI = blueComponent // 2

        self.canonical_parent._send_midi(SYSEX_COLOR_CHANGE(self.clipSlotID, redComponentMIDI, greenComponentMIDI, blueComponentMIDI))



    def clipPresenceChangeCallback(self):
        if self._clip_slot == None:
            return

        if self.clipSlotID == None:
            return

        self.canonical_parent._send_midi(SYSEX_CLIP_PRESENT(self.clipSlotID, self._clip_slot.has_clip))