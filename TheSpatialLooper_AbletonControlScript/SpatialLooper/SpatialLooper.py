from __future__ import with_statement

from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.ButtonElement import ButtonElement

from .SpatialSessionComponent import SpatialSessionComponent


class SpatialLooper(ControlSurface):

    SESSION_FRAME_X = 1
    SESSION_FRAME_Y = 10

    MIDI_CHANNEL = 1 -1

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
            noteButtonOffset = 1
            track = 0
            for sceneID in range(10):
                clipNote = sceneID + noteButtonOffset
                clipLaunchButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, clipNote)
                scene = self._session.scene(sceneID)
                clip_slot = scene.clip_slot(track)
                clip_slot.set_launch_button(clipLaunchButton)
                self.mappedClipSlots.append(clip_slot)

            self.set_highlighting_session_component(self._session)

            self.updateButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 110)
            self.updateButton.add_value_listener(self.send_clip_updates)


    def send_clip_updates(self, value):

        # INV: only note on message
        if value != 127:
            return

        for clipSlot in self.mappedClipSlots:
            clipSlot.update()

