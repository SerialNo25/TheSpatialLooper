from __future__ import with_statement
import time

from _Framework.ControlSurface import ControlSurface
from _Framework.InputControlElement import *
from _Framework.ButtonElement import ButtonElement

from .SpatialSessionComponent import SpatialSessionComponent


class SpatialLooper(ControlSurface):

    SESSION_FRAME_X = 5
    SESSION_FRAME_Y = 10

    MIDI_CHANNEL = 1 -1

    NOTE_BUTTON_OFFSET = 1

    UPDATE_BUTTON_NOTE_VALUE = 110
    DELETE_BUTTON_NOTE_VALUE = 111
    STOP_BUTTON_NOTE_VALUE = 112

    mappedClipSlots = []

    def __init__(self, c_instance):
        # MARK: - CONTROL SURFACE
        ControlSurface.__init__(self, c_instance)
        # initialize to prevent duplicates on session reload
        self.mappedClipSlots = []
        with self.component_guard():
            self._session = SpatialSessionComponent(self.SESSION_FRAME_X, self.SESSION_FRAME_Y)
            self._session.name = 'SpatialLooper_Session'

            # MARK: - SESSION CONTROL
            momentaryButton = True

            for trackID in range(self.SESSION_FRAME_X):
                for sceneID in range(self.SESSION_FRAME_Y):
                    trackLaunchButtonOffset = trackID * self.SESSION_FRAME_Y
                    clipNote = trackLaunchButtonOffset + sceneID + self.NOTE_BUTTON_OFFSET
                    clipLaunchButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, clipNote)
                    scene = self._session.scene(sceneID)
                    clip_slot = scene.clip_slot(trackID)
                    clip_slot.set_launch_button(clipLaunchButton)
                    self.mappedClipSlots.append(clip_slot)

            self.set_highlighting_session_component(self._session)

            # MARK: - CUSTOM COMMANDS
            # FETCH SESSION UPDATE
            self.updateButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, self.UPDATE_BUTTON_NOTE_VALUE)
            self.updateButton.add_value_listener(self.send_clip_updates)

            # DELETE CLIP
            self.deleteButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, self.DELETE_BUTTON_NOTE_VALUE)
            self.deleteButton.add_value_listener(self.delete_clip)

            # STOP CLIP
            self.stopButton = ButtonElement(momentaryButton, 0, self.MIDI_CHANNEL, self.STOP_BUTTON_NOTE_VALUE)
            self.stopButton.add_value_listener(self.stop_clip)

    def delete_clip(self, value):
        try:
            clip_slot = self.mappedClipSlots[value - self.NOTE_BUTTON_OFFSET]
            if clip_slot.has_clip():
                clip_slot._do_delete_clip()
        except:
            pass

    def stop_clip(self, value):
        try:
            clip_slot = self.mappedClipSlots[value - self.NOTE_BUTTON_OFFSET]
            if clip_slot.has_clip():
                clip_slot._clip_slot.stop()
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

