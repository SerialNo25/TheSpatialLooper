from __future__ import with_statement

from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.ButtonElement import ButtonElement

from .SpatialSessionComponent import SpatialSessionComponent


class SpatialLooper(ControlSurface):

    SESSION_FRAME_X = 1
    SESSION_FRAME_Y = 10

    MIDI_CHANNEL = 1 -1

    def __init__(self, c_instance):
        # MARK: - CONTROL SURFACE
        ControlSurface.__init__(self, c_instance)
        with self.component_guard():
            self._session = SpatialSessionComponent(self.SESSION_FRAME_X, self.SESSION_FRAME_Y)
            self._session.name = 'SpatialLooper_Session'

            # MARK: - SESSION CONTROL
            momentaryButton = True
            sessionUpButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 64)
            sessionDownButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 60)
            # TODO: Map these :) -> Do we even need these actually? We might want them for convenience but thats about it
            sessionLeftButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 0)
            sessionRightButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 0)
            self._session.set_track_bank_buttons(sessionRightButton, sessionLeftButton)
            self._session.set_scene_bank_buttons(sessionDownButton, sessionUpButton)

            # TODO: Update this to reflect the final grid
            noteButtonOffset = 50
            track = 0
            for sceneID in range(10):
                clipNote = sceneID + noteButtonOffset
                clipLauncher = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, clipNote)
                scene = self._session.scene(sceneID)
                clip_slot = scene.clip_slot(track)
                clip_slot.set_launch_button(clipLauncher)



            self.set_highlighting_session_component(self._session)
