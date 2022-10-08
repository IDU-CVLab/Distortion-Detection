# Distortion-Detection Codes

Blank_frame.m for blank frame detection and reconstruct video without blank frames.

Intensity_variation.m detects and reconstruct distorted frames and produce new video

# Plugins Deployment via Fiji
This algorithm is deployed as a Fiji plugin. To run the plugin:

* Install Fiji [here](https://imagej.net/software/fiji/downloads)
* Download .ijm macro in the folder "Plugins_Fiji"
* Add the script to the plugins menu application:
The macro must be saved in Fiji.app/scripts/ (or a subdirectory thereof) [^1]    <br/>
The file extension of the macro file must be .ijm                              <br/>
The filename must contain an ‘_’ (underscore) character                        <br/>

Note that, as opposed to plain IJ1 [^2], this approach allows you to register your macros and scripts in any menu. So, if for example, you place your macro in Fiji.app/scripts/Edit/My Own Submenu, it will appear in Edit>My Own Submenu>

[^1] In Fiji, it is also possible to place scripts in another legacy location: Fiji.app/plugins/Scripts/ <br/>
[^2] In plain IJ1, the macro can have either an .ijm or .txt, and must be placed in the /plugins/ directory).

Exaplanation of adding a script to the plungin menu can be found [here](https://imagej.net/scripting/#Adding_scripts_to_the_Plugins_menu)
<br/> 
* Please send an email in csae of issues.
# Citation
* If you find the work useful, please consider citing the paper:
> TODO: Get citation info.

# Acknowledgements
> TODO: 
