# Codes
* 'Blank_frame.m' is for blank frame detection and video reconstruction.
* 'Intensity_variation.m' is for detecting and reconstructing distorted frames and producing a new video.

# Fiji Plugins 
This algorithm is deployed as a Fiji plugin. To run the plugin:

* Install Fiji [here](https://imagej.net/software/fiji/downloads)
* Download .ijm macro script in the folder "Plugins_Fiji"
* Add the script to the plugins menu in Fiji application:                          <br/>
The macro must be saved in Fiji.app/scripts/ (or a subdirectory thereof) [^1]    <br/>
The file extension of the macro file must be .ijm                              <br/>
The filename must contain an ‘_’ (underscore) character.                        <br/>

Note that, as opposed to plain IJ1 [^2], this approach allows you to register your macros and scripts in any menu. So, if for example, you place your macro script in Fiji.app/scripts/Edit/My Own Submenu, it will appear in Edit>My Own Submenu>

[^1] In Fiji, it is also possible to place scripts in another legacy location: Fiji.app/plugins/Scripts/ <br/>
[^2] In plain IJ1, the macro can have either an .ijm or .txt, and must be placed in the /plugins/ directory.

Exaplanation of adding a script to the plungin menu can be found [here](https://imagej.net/scripting/#Adding_scripts_to_the_Plugins_menu)
<br/> 

# Acknowledgement
* This work is supported by the Scientific and Technological Research Council of Turkey (TUBITAK) under grant no 119E578.
* The data used in this study is collected under the Marie Curie IRG grant (no: FP7 PIRG08-GA-2010-27697).
* The dataset contain cell motility, macrophage behaviours, and some other experimental Phase Contrast Microscopic (PCM) images.
  
# Citation
* If you find the work useful, please consider citing the paper:

>@inproceedings{ucar2022detection, <br/>
  title={Detection and Restoration Pipeline for Phase Contrast Microscopy Time Series Images}, <br/>
  author={Ucar, Mahmut and Iheme, Leonardo O and Onal, Sevgi and Ozuysal, Ozden Y and Okvur, Devrim P and Toreyin, Behcet U and Unay, Devrim}, <br/>
  booktitle={2022 Medical Technologies Congress (TIPTEKNO)}, <br/>
  pages={1--4}, <br/>
  year={2022}, <br/>
  organization={IEEE} <br/>
}
