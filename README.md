# Spatial Looper
Leveraging Mixed Reality as an Interface for Clip-Based Live Music Looping of Keyboard Instruments

## Introduction
Spatial Looper is a Spatial Control Surface for Ableton Live. It was developed as part of their Bachelor Thesis by Flurin Selm. Spatial Looper allows controlling the recording, playback, and scene grouping of Ableton Live clips during a live performance through a spatially aware user interface leveraging both hand and object recognition to understand the ongoing performance. Additionally, Spatial Looper can provide automatic recording triggers based on the performer’s hands’ proximity to the keyboards.


## Features
### Spatial Looper Features
- Wireless MIDI connectivity using CoreMIDI
- MIDI QuickConnect utility
- Ableton Live integration through Remote Script (no per-set setup required)

### Spatial Looping
- Two automatic looping modes, commit and discard on leave
- Automatic mapping of loop controls to track based on the system’s spatial awareness
- Quick discard feature for the current loop
- Quick restart feature for the current loop
- Quick commit feature for the current loop
- Disabling of loop trigger by hand using a flick gesture
- Automatic tracking of music devices in space
- Buttons supporting touch and eye-tracking interaction
- Global arming of recording triggers

### Session Control
- Automatic synchronization of clip slots and colors with Live
- Animated UI showing current clip state per track
- Per-track clip controls

### Scene Control
- Create scenes from current playback
- Scene triggering
- Scene management

### Hand Position Logging
- Configurable logging of hand positions
- Configurable sample rate
- Export of position logs in CSV format


## Installation
### Hardware requirements:
- Vision Pro running visionOS 2.2 or later
- Mac running Ableton Live 11 or later

Note: For the scope of this project the implementation was only tested using Ableton Live 11. The Remote Script may need to be adjusted to work with later versions.

### Setup
#### Vision Pro Component
1. Clone this repository and open the project in TheSpatialLooper_AVP_App in Xcode.
2. Open GlobalConfig.swift and configure your tracks under the TRACK CONFIG section
> Note:
> - The field referenceObjectName for each loop source requires a valid corresponding .referenceobject file in the ObjectTrackingReferences group of the app. You can create your own referenceobjects from 3D models using Apple CreateML. Please consult the official guide for this process.
> - The field trackID starts indexing at 0.
> - A track ID needs to be within the bounding box that is configured for the live session in both the remote script and the Vision Pro app. By default, tracks 1-5 (ID: 0-4) are supported.
> - OPTIONAL: If hand position logging is desired, enable the logging feature in GlobalConfig and set the sample rate
3. Sign and deploy the app on a supported device.

#### Ableton Live Remote Script
1. Clone this repository and locate the remote script in TheSpatialLooper_AbletonControlScript.
2. Import the script (the entire folder called SpatialLooper) into the remote scripts folder of Ableton Live.
3. Open AudioMIDI Setup.
4. Configure and enable a network session in MIDI Studio.
5. Open Ableton Live.
6. Navigate to Settings, Link Tempo MIDI, and select SpatialLooper from the Control Surface Selection and assign both the in and output to the network session.

#### Connecting
1. Launch the Spatial Looper App in Vision Pro
2. Run MIDI Quick Connect in Spatial Looper
3. Go to MIDI Studio and select your Vision Pro from the available devices
4. Spatial Looper is ready to run

## Usage
A user guide for Spatial Looper can be found on the Spatial Looper YouTube Channel: TODO: Add Link



