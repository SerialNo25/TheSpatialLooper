from _Framework.ClipSlotComponent import ClipSlotComponent

class SpatialClipSlotComponent(ClipSlotComponent):

    def __init__(self, *a, **k):
        (super(SpatialClipSlotComponent, self).__init__)(*a, **k)



    def update(self, *args, **kwargs):
        super().update(*args, **kwargs)

        self.assignClipListeners()



    def assignClipListeners(self):
        if self._clip_slot != None:
            # clip presence
            if not self._clip_slot.has_clip_has_listener(self.clipPresenceChangeCallback):
                self._clip_slot.add_has_clip_listener(self.clipPresenceChangeCallback)

            # clip color
            if self._clip_slot.has_clip and not self._clip_slot.clip.color_has_listener(self.clipColorChangeCallback):
                self._clip_slot.clip.add_color_listener(self.clipColorChangeCallback)
                # we run the callback to transmit the initial color
                self.clipColorChangeCallback()



    def clipColorChangeCallback(self):
        if self._clip_slot == None or self._clip_slot.clip == None:
            return

        color = self._clip_slot.clip.color
        self.canonical_parent.show_message(f"color was changed from CS. New color is: {color}")



    def clipPresenceChangeCallback(self):
        if self._clip_slot == None:
            return

        clipState = "present" if self._clip_slot.has_clip else "no clip"
        self.canonical_parent.show_message(f"clip presence was changed from CS. New state is: { clipState }")