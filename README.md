A VGA monitor requires 5 signals to display a picture:

    R, G and B (red, green and blue signals).
    HS and VS (horizontal and vertical synchronization).

https://www.fpga4fun.com/images/VGAconnector.gif 

The R, G and B are analog signals, while HS and VS are digital signals.

Frequency generator

A monitor always displays a picture line-by-line, from top-to-bottom. Each line is drawn from left-to-right.

That's hard-coded, you cannot change that.

But you specify when the drawing starts by sending short pulses on HS and VS at fixed intervals. HS makes a new line to start drawing; while VS tells that the bottom has been reached (makes the monitor go back up to the top line).

For the standard 640x480 VGA video signal, the frequencies of the pulses should be:

Vertical Freq (VS)	Horizontal Freq (HS)
     60 Hz 	             31.5 kHz 
