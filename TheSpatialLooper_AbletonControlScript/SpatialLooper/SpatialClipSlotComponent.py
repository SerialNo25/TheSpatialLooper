from _Framework.ClipSlotComponent import ClipSlotComponent
from .SpatialLooperSysExMap import *

class SpatialClipSlotComponent(ClipSlotComponent):

    clipSlotID = None

    def __init__(self, *a, **k):
        (super(SpatialClipSlotComponent, self).__init__)(*a, **k)



    def update(self, *args, **kwargs):
        super().update(*args, **kwargs)

        self.assignClipListeners()



    def set_launch_button(self, *args, **kwargs):
        super().set_launch_button(*args, **kwargs)
        self.clipSlotID = args[0].original_identifier()



    def assignClipListeners(self):
        if self._clip_slot != None:
            # clip presence
            if not self._clip_slot.has_clip_has_listener(self.clipPresenceChangeCallback):
                self._clip_slot.add_has_clip_listener(self.clipPresenceChangeCallback)

            # clip color
            if self._clip_slot.has_clip and not self._clip_slot.clip.color_has_listener(self.clipColorChangeCallback):
                self._clip_slot.clip.add_color_listener(self.clipColorChangeCallback)

                # we immediately run the callback to transmit the initial color
                self.clipColorChangeCallback()



    def clipColorChangeCallback(self):
        if self._clip_slot == None or self._clip_slot.clip == None:
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

        self.canonical_parent._send_midi(SYSEX_CLIP_PRESENT(self.clipSlotID, self._clip_slot.has_clip))