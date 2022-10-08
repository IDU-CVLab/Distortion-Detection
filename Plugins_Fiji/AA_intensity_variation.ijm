open("D:/data/allmotilityinvestigate/Resized IR16hrglassmatrigel231liveimaging8nov.20fps.avi.avi");

getDimensions(width, height, channels, NoS, frames);

setSlice(NoS);
run("Add Slice");
setSlice(1);

arr = newArray(NoS);
std= newArray(NoS);
run("Set Measurements...", "mean redirect=None decimal=3");
for (i=0; i<(NoS); 1) 
	{
	run("Measure");
	arr[i] =getResultString("Mean",i);
	run("Next Slice [>]");
	i = i+1;
	}

arr_sorted = Array.sort(arr);
n = lengthOf(arr);
	if(n%2 == 1)
	{
	med = arr_sorted[floor(n/2)+1];
	}
	else
	{
	med = arr_sorted[(n/2)];
	}

for (i=0; i<(NoS); 1) 
	{
	arr[i] =getResultString("Mean",i);
	std[i] = (((arr[i]) - (med))/255);
	i = i+1;
	}

state = newArray(NoS);
a = 0.3;
for (i=0; i<(NoS); 1) 
	{
		if(arr[i] > (1+a)*med || arr[i] < (1-a)*med )
		{
		state[i] =1;
		}
		else
		{
		state[i] = 0;
		}
	i = i+1;
	}
Array.show(state);
///Array.show(arr);
///Array.show(med);
///Array.show(std);

setSlice(1);
for (i=0; i<(NoS); 1) 
	{
	if(state[i] == 1)
		{
		///run("Duplicate...", "title=" + (i+1));
		run("Multiply...", "value=" + std[i] + " slice");
		
		}
	run("Next Slice [>]");
	i = i+1;
	}



