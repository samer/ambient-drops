// Waves, just shifting the frequency on some white noise and sprinkling in some dust.
{
n = OnePole.ar(WhiteNoise.ar(0.1) + Dust.ar(100, 0.5), 0.9);
n = n + Splay.ar(FreqShift.arnx, 1/(4..7)), 1, 0.5);
}.play;

// Primitive instrument based on a simple sine wave, carefully wrapped in an envelope.
SynthDef(\sine, { |amp = 0.075, freq = 440, t_trig|
	var env =  Env.perc(0.6,6);
	var data = SinOsc.ar(freq, 0, amp) * EnvGen.ar(env, t_trig, doneAction: 0);
	Out.ar(0, data ! 2);
}).store;
