# Acoustic-Signal-Processing
 Scripts for processing data from object ensonifications
 
 Test Data are raw recordings from an object ensonified in the big flight room. 
 Two sounds were used: synthetic bat calls (1-4) and linear sine sweeps (16-20)
 There are channels for the whole mic array (columns 1:32) but channels 2 and 24 are the 
 mics that were actually used in the set up. linearandFMsweep.m contains the signals used.
 Each excitation was repeated 10 times with 52 ms of silence between end of the last and
 start of the next.
 
 getavecho requires a lot of user input, but averages the pulse-echo repititions into one
 cleaner recording. Required inputs are mic channels to load (should be a vector of 1+ values),
 number of times each stimulus is repeated, and time in ms of time between pulses. Calls variables
 sig (signal from mic array) and fs (sampling rate) change those as needed.
 
 createIR creates an impulse response for the room/object of interest. Uses a very simple 
 Dual Channel FFT method. Use averaged data and a sine sweep for cleanest results. 
 Required inputs are the response and the impulse used to create the response. If you are just
 interested in overall room tone, you should comment out the back half of the script. For our
 purposes we want just the echo from the object we are interested in, so we collect a second IR
 using an extremely short chirp to isolate the echo in time. Cleanest results come from using very
 long windows and sine sweeps with sufficient power across all frequencies. 
