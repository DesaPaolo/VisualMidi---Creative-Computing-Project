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
The Store Mode allows a user to save up to 100 Minilogue presets (only from number 0 to 100 on minilogue). After having initialized the minilogue panel (shift+play on minilogue) tune knobs until you find the desired sound. All midi messages are automatically sent to the minilogue. Once you have found the desired sound just set the preset name and store it. It is suggested to store the preset with the same name with which it will be saved on the minilogue. 


## Load Mode

<p align="center"><img height="500" src="https://github.com/DesaPaolo/VisualMidi---Creative-Computing-Project/blob/master/resources/Load.PNG"></p>
The Load Mode allows a user to load  Minilogue presets previously stored using "Store Mode". Visual Midi also allows users to load presets using program changes, that means simply by moving the knob "PROGRAM/VALUE" of the minilogue. Even in this case it is necessary the presets have already been stored, using "Store Mode". 
