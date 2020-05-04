# VisualMidi

This is a project for the "Creative Programming And Computing" course held at "Politecnico di Milano".

# Goals

The goal of this project is to give a graphical interpretation to MIDI messages coming from a Korg Minilogue, in such a way that graphical elements and audio stream are coherent. It is also implemented an integration with a Kemper Profiler that sends MIDI messages affecting the graphics.

# Where To Use
This program is thought to be used in live performances, both by bands and single artists.

## Initial Screen
<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/InitialScreen.PNG"></p>
The initial screen allows navigation into different pages by clicking the corresponding button.

## Store Mode
<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/Store.PNG"></p>
"Store Mode" allows a user to save up to 100 Minilogue presets (only from number 0 to 100 on minilogue). After having initialized the minilogue panel (shift+play on minilogue) tune knobs until you find the desired sound. All midi messages are automatically sent to the minilogue. Once you have found the desired sound just set the preset name and store it. It is suggested to store the preset with the same name with which it will be saved on the minilogue. 


## Load Mode

<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/Load.PNG"></p>
"Load Mode" allows a user to load  Minilogue presets previously stored using "Store Mode". Visual Midi also allows users to load presets using program changes, that means simply by moving the knob "PROGRAM/VALUE" of the minilogue. Even in this case it is necessary the presets have already been stored, using "Store Mode". 

## Device Mode

<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/Device.PNG"></p>
"Device Mode" allows a user to select the proper input drivers, both for the minilogue and the Kemper Profiler. It is also possible to use a virtual midi cable, in order to use "play mode" with already recorded MIDI files.

## Guitar Mode

<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/kemperBoth.jpg"></p>
The software will also show several animations according to some parameters of the Kemper Profiler:
- Overdrive type;
- Amplifier gain;
- EQ type;
- Modulation type;
- Reverb Size;

The aforementioned parameters are obtained through the exchange of MIDI SysEx calls, with NRPN messages encapsulated inside them.
The structure of the used SysEx messages is the following:
- 0xF0: Start of SysEx;
- 0x00 0x20 0x33: Manifacturer ID (Kemper);
- 0x02 0x7f: Product type and device ID (Head, Rack Pedalboard, etc.);
- 0x02 0x7f: Product type and device ID (Head, Rack Pedalboard, etc.);
- 0x01, 0x06 or 0x41: Function code to specify how to interpret the carried data;
- 0x00: Instance (always zero);
- 0x4A (example): Controller MSB (the upper 7-bit of the 14-bit NRPN address);
- 0x04 (example): Controller LSB (the lower 7-bit of the 14-bit NRPN address);
- 0x40 (example): Value MSB (the upper 7-bit of the 14-bit value, not used when asking for some value with func. code 0x41);
- 0x3A (example): Value LSB (the lower 7-bit of the 14-bit value, not used when asking for some value with func. code 0x41);
- 0xF7: End of SysEx.

The combination of sending (0x41 to request parameters' values) and receiving (0x01 and 0x06 to receive parameters' values) SysEx messages is used along all the execution of the program to get at each time the representation of the status of the Kemper Profiling Amplifier.
