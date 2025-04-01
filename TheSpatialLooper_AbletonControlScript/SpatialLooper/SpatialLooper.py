from __future__ import with_statement
import time

from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.ButtonElement import ButtonElement

from .SpatialSessionComponent import SpatialSessionComponent


class SpatialLooper(ControlSurface):

    SESSION_FRAME_X = 1
    SESSION_FRAME_Y = 10

    MIDI_CHANNEL = 1 -1

    NOTE_BUTTON_OFFSET = 1

    mappedClipSlots = []
    updateButton = None

    def __init__(self, c_instance):
        # MARK: - CONTROL SURFACE
        ControlSurface.__init__(self, c_instance)
        with self.component_guard():
            self._session = SpatialSessionComponent(self.SESSION_FRAME_X, self.SESSION_FRAME_Y)
            self._session.name = 'SpatialLooper_Session'

            # MARK: - SESSION CONTROL
            momentaryButton = True

            # TODO: Update this to reflect the final grid

            track = 0
            for sceneID in range(10):
                clipNote = sceneID + self.NOTE_BUTTON_OFFSET
                clipLaunchButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, clipNote)
                scene = self._session.scene(sceneID)
                clip_slot = scene.clip_slot(track)
                clip_slot.set_launch_button(clipLaunchButton)
                self.mappedClipSlots.append(clip_slot)

            self.set_highlighting_session_component(self._session)

            self.updateButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 110)
            self.updateButton.add_value_listener(self.send_clip_updates)

            self.delete_input = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 111)
            self.delete_input.add_value_listener(self.delete_clip)

    def delete_clip(self, value):
        try:
            clip_slot = self.mappedClipSlots[value - self.NOTE_BUTTON_OFFSET]
            if clip_slot.has_clip():
                clip_slot._do_delete_clip()
        except:
            pass

    def send_clip_updates(self, value):

        # INV: only note on message
        if value != 127:
            return

        for clipSlot in self.mappedClipSlots:
            clipSlot.update()
            # As the core MIDI system only handles up to message 15 we need to ensure we do not overload the buffer
            self._flush_midi_messages()
            time.sleep(0.01)

