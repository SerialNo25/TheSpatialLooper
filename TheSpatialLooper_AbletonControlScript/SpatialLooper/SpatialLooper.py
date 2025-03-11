from __future__ import with_statement

from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.SessionComponent import SessionComponent
from _Framework.ButtonElement import ButtonElement


class SpatialLooper(ControlSurface):

    SESSION_FRAME_X = 1
    SESSION_FRAME_Y = 10

    MIDI_CHANNEL = 1 -1

    def __init__(self, c_instance):
        # MARK: - CONTROL SURFACE
        ControlSurface.__init__(self, c_instance)
        with self.component_guard():
            self._session = SessionComponent(self.SESSION_FRAME_X, self.SESSION_FRAME_Y)
            self._session.name = 'SpatialLooper_Session'

            # MARK: - SESSION CONTROL
            momentaryButton = True
            sessionUpButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 64)
            sessionDownButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 60)
            # TODO: Map these :)
            sessionLeftButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 0)
            sessionRightButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, 0)
            self._session.set_track_bank_buttons(sessionRightButton, sessionLeftButton)
            self._session.set_scene_bank_buttons(sessionDownButton, sessionUpButton)

            # TODO: Update this to reflect the final grid
            noteButtonOffset = 50
            track = 0
            for scene in range(10):
                clipLauncher = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, scene + noteButtonOffset)
                scene = self._session.scene(scene)
                clip = scene.clip_slot(track)
                clip.set_launch_button(clipLauncher)


            self.set_highlighting_session_component(self._session)
