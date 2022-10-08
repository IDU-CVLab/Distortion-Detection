open();

getDimensions(width, height, channels, NoS, frames);

setSlice(NoS);
run("Add Slice");
setSlice(1);

BF = newArray(NoS);
arr = newArray(NoS);
run("Set Measurements...", "mean redirect=None decimal=3");

for (i=0; i<(NoS); 1) 
	{
	run("Measure");
	arr[i] =getResultString("Mean",i);
		if (floor(arr[i]) == 0)
			{
			BF[i] = 1;
			run("Delete Slice");
			run("Next Slice [>]");
			}
		else
			{
			BF[i] = 0;
			run("Next Slice [>]");
			}
	i = i+1;
	}
run("Delete Slice");
run("AVI... ", "compression=None frame=20 save=[]");
close();
