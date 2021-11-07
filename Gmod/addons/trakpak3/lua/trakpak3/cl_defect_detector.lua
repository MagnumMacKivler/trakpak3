if not Trakpak3.EDD then --EDD stands for Equipment Defect Detector
	Trakpak3.EDD = {SoundFonts = {}}
end

--Sound Fonts
--GE Defect Detector (prototypic)
Trakpak3.EDD.SoundFonts["ge"] = {
	staticloop = "trakpak3/defect_detectors/static.wav",
	--delay = 0.05,
	delay = 0,
	
	["0"] = { "trakpak3/defect_detectors/ge/0.wav", 0.59 },
	["1"] = { "trakpak3/defect_detectors/ge/1.wav", 0.46 },
	["2"] = { "trakpak3/defect_detectors/ge/2.wav", 0.4 },
	["3"] = { "trakpak3/defect_detectors/ge/3.wav", 0.45 },
	["4"] = { "trakpak3/defect_detectors/ge/4.wav", 0.52 },
	["5"] = { "trakpak3/defect_detectors/ge/5.wav", 0.56 },
	["6"] = { "trakpak3/defect_detectors/ge/6.wav", 0.67 },
	["7"] = { "trakpak3/defect_detectors/ge/7.wav", 0.69 },
	["8"] = { "trakpak3/defect_detectors/ge/8.wav", 0.38 },
	["9"] = { "trakpak3/defect_detectors/ge/9.wav", 0.72 },
	["a"] = { "trakpak3/defect_detectors/ge/a.wav", 0.48 },
	["a_ground_inspection_is_required"] = { "trakpak3/defect_detectors/ge/a_ground_inspection_is_required.wav", 2.47 },
	["alarm"] = { "trakpak3/defect_detectors/ge/alarm.wav", 0.85 },
	["alarms"] = { "trakpak3/defect_detectors/ge/alarms.wav", 0.94 },
	["and"] = { "trakpak3/defect_detectors/ge/and.wav", 0.76 },
	["axle"] = { "trakpak3/defect_detectors/ge/axle.wav", 0.63 },
	["b"] = { "trakpak3/defect_detectors/ge/b.wav", 0.5 },
	["beep"] = { "trakpak3/defect_detectors/ge/beep.wav", 1.15 },
	["c"] = { "trakpak3/defect_detectors/ge/c.wav", 0.66 },
	["car"] = { "trakpak3/defect_detectors/ge/car.wav", 0.65 },
	["cars"] = { "trakpak3/defect_detectors/ge/cars.wav", 0.75 },
	["cold"] = { "trakpak3/defect_detectors/ge/cold.wav", 0.51 },
	["count"] = { "trakpak3/defect_detectors/ge/count.wav", 0.6 },
	["critical_alarm"] = { "trakpak3/defect_detectors/ge/critical_alarm.wav", 2.22 },
	["d"] = { "trakpak3/defect_detectors/ge/d.wav", 0.55 },
	["defect"] = { "trakpak3/defect_detectors/ge/defect.wav", 0.69 },
	["defect_as_follows"] = { "trakpak3/defect_detectors/ge/defect_as_follows.wav", 2.05 },
	["degrees"] = { "trakpak3/defect_detectors/ge/degrees.wav", 0.78 },
	["detector"] = { "trakpak3/defect_detectors/ge/detector.wav", 0.71 },
	["detector_not_working"] = { "trakpak3/defect_detectors/ge/detector_not_working.wav", 1.95 },
	["dragging_equipment"] = { "trakpak3/defect_detectors/ge/dragging_equipment.wav", 1.3 },
	["e"] = { "trakpak3/defect_detectors/ge/e.wav", 0.54 },
	["east"] = { "trakpak3/defect_detectors/ge/east.wav", 0.59 },
	["eighth"] = { "trakpak3/defect_detectors/ge/eighth.wav", 0.46 },
	["eleventh"] = { "trakpak3/defect_detectors/ge/eleventh.wav", 0.87 },
	["end"] = { "trakpak3/defect_detectors/ge/end.wav", 0.45 },
	["end_of_transmission"] = { "trakpak3/defect_detectors/ge/end_of_transmission.wav", 1.68 },
	["equipment"] = { "trakpak3/defect_detectors/ge/equipment.wav", 0.81 },
	["excessive_alarms"] = { "trakpak3/defect_detectors/ge/excessive_alarms.wav", 1.68 },
	["f"] = { "trakpak3/defect_detectors/ge/f.wav", 0.39 },
	["failure"] = { "trakpak3/defect_detectors/ge/failure.wav", 0.59 },
	["feet"] = { "trakpak3/defect_detectors/ge/feet.wav", 0.78 },
	["fifth"] = { "trakpak3/defect_detectors/ge/fifth.wav", 0.46 },
	["first"] = { "trakpak3/defect_detectors/ge/first.wav", 0.52 },
	["found"] = { "trakpak3/defect_detectors/ge/found.wav", 0.73 },
	["fourth"] = { "trakpak3/defect_detectors/ge/fourth.wav", 0.46 },
	["from"] = { "trakpak3/defect_detectors/ge/from.wav", 0.61 },
	["g"] = { "trakpak3/defect_detectors/ge/g.wav", 0.55 },
	["h"] = { "trakpak3/defect_detectors/ge/h.wav", 0.62 },
	["high"] = { "trakpak3/defect_detectors/ge/high.wav", 0.54 },
	["hot"] = { "trakpak3/defect_detectors/ge/hot.wav", 0.49 },
	["hot_box"] = { "trakpak3/defect_detectors/ge/hot_box.wav", 0.84 },
	["hot_wheel"] = { "trakpak3/defect_detectors/ge/hot_wheel.wav", 0.89 },
	["i"] = { "trakpak3/defect_detectors/ge/i.wav", 0.66 },
	["inspect"] = { "trakpak3/defect_detectors/ge/inspect.wav", 0.67 },
	["is"] = { "trakpak3/defect_detectors/ge/is.wav", 0.63 },
	["j"] = { "trakpak3/defect_detectors/ge/j.wav", 0.59 },
	["k"] = { "trakpak3/defect_detectors/ge/k.wav", 0.57 },
	["l"] = { "trakpak3/defect_detectors/ge/l.wav", 0.54 },
	["left"] = { "trakpak3/defect_detectors/ge/left.wav", 0.43 },
	["length"] = { "trakpak3/defect_detectors/ge/length.wav", 0.7 },
	["length_of_train"] = { "trakpak3/defect_detectors/ge/length_of_train.wav", 1.31 },
	["load"] = { "trakpak3/defect_detectors/ge/load.wav", 0.6 },
	["m"] = { "trakpak3/defect_detectors/ge/m.wav", 0.55 },
	["main"] = { "trakpak3/defect_detectors/ge/main.wav", 0.55 },
	["maintenance_required"] = { "trakpak3/defect_detectors/ge/maintenance_required.wav", 1.75 },
	["malfunction"] = { "trakpak3/defect_detectors/ge/malfunction.wav", 0.92 },
	["middle"] = { "trakpak3/defect_detectors/ge/middle.wav", 0.5 },
	["milepost"] = { "trakpak3/defect_detectors/ge/milepost.wav", 0.94 },
	["minus"] = { "trakpak3/defect_detectors/ge/minus.wav", 0.71 },
	["more"] = { "trakpak3/defect_detectors/ge/more.wav", 0.64 },
	["multiple"] = { "trakpak3/defect_detectors/ge/multiple.wav", 0.83 },
	["n"] = { "trakpak3/defect_detectors/ge/n.wav", 0.51 },
	["near"] = { "trakpak3/defect_detectors/ge/near.wav", 0.57 },
	["ninth"] = { "trakpak3/defect_detectors/ge/ninth.wav", 0.68 },
	["no"] = { "trakpak3/defect_detectors/ge/no.wav", 0.52 },
	["no_alarms"] = { "trakpak3/defect_detectors/ge/no_alarms.wav", 1.33 },
	["no_defects"] = { "trakpak3/defect_detectors/ge/no_defects.wav", 1.41 },
	["norfolk_southern"] = { "trakpak3/defect_detectors/ge/norfolk_southern.wav", 1.32 },
	["north"] = { "trakpak3/defect_detectors/ge/north.wav", 0.53 },
	["not"] = { "trakpak3/defect_detectors/ge/not.wav", 0.77 },
	["notify_dispatcher"] = { "trakpak3/defect_detectors/ge/notify_dispatcher.wav", 1.44 },
	["o"] = { "trakpak3/defect_detectors/ge/o.wav", 0.51 },
	["of"] = { "trakpak3/defect_detectors/ge/of.wav", 0.23 },
	["out"] = { "trakpak3/defect_detectors/ge/out.wav", 0.48 },
	["p"] = { "trakpak3/defect_detectors/ge/p.wav", 0.51 },
	["point"] = { "trakpak3/defect_detectors/ge/point.wav", 0.51 },
	["power"] = { "trakpak3/defect_detectors/ge/power.wav", 0.48 },
	["q"] = { "trakpak3/defect_detectors/ge/q.wav", 0.51 },
	["r"] = { "trakpak3/defect_detectors/ge/r.wav", 0.48 },
	["rail"] = { "trakpak3/defect_detectors/ge/rail.wav", 0.87 },
	["railroad"] = { "trakpak3/defect_detectors/ge/railroad.wav", 1.06 },
	["railway"] = { "trakpak3/defect_detectors/ge/railway.wav", 0.89 },
	["rebroadcast"] = { "trakpak3/defect_detectors/ge/rebroadcast.wav", 1.05 },
	["repeat"] = { "trakpak3/defect_detectors/ge/repeat.wav", 0.74 },
	["restriction"] = { "trakpak3/defect_detectors/ge/restriction.wav", 0.79 },
	["right"] = { "trakpak3/defect_detectors/ge/right.wav", 0.46 },
	["s"] = { "trakpak3/defect_detectors/ge/s.wav", 0.51 },
	["second"] = { "trakpak3/defect_detectors/ge/second.wav", 0.68 },
	["seventh"] = { "trakpak3/defect_detectors/ge/seventh.wav", 0.78 },
	["shifted"] = { "trakpak3/defect_detectors/ge/shifted.wav", 0.68 },
	["side"] = { "trakpak3/defect_detectors/ge/side.wav", 0.65 },
	["sixth"] = { "trakpak3/defect_detectors/ge/sixth.wav", 0.89 },
	["south"] = { "trakpak3/defect_detectors/ge/south.wav", 0.69 },
	["system"] = { "trakpak3/defect_detectors/ge/system.wav", 0.6 },
	["system_working"] = { "trakpak3/defect_detectors/ge/system_working.wav", 1.15 },
	["t"] = { "trakpak3/defect_detectors/ge/t.wav", 0.46 },
	["temperature"] = { "trakpak3/defect_detectors/ge/temperature.wav", 0.83 },
	["tenth"] = { "trakpak3/defect_detectors/ge/tenth.wav", 0.6 },
	["third"] = { "trakpak3/defect_detectors/ge/third.wav", 0.48 },
	["thirteenth"] = { "trakpak3/defect_detectors/ge/thirteenth.wav", 1.07 },
	["too"] = { "trakpak3/defect_detectors/ge/too.wav", 0.61 },
	["total_axle"] = { "trakpak3/defect_detectors/ge/total_axle.wav", 1.14 },
	["total_cars"] = { "trakpak3/defect_detectors/ge/total_cars.wav", 1.27 },
	["track"] = { "trakpak3/defect_detectors/ge/track.wav", 0.55 },
	["train"] = { "trakpak3/defect_detectors/ge/train.wav", 0.61 },
	["train_speed"] = { "trakpak3/defect_detectors/ge/train_speed.wav", 1.49 },
	["train_too_slow"] = { "trakpak3/defect_detectors/ge/train_too_slow.wav", 1.31 },
	["twelfth"] = { "trakpak3/defect_detectors/ge/twelfth.wav", 0.79 },
	["u"] = { "trakpak3/defect_detectors/ge/u.wav", 0.61 },
	["v"] = { "trakpak3/defect_detectors/ge/v.wav", 0.52 },
	["w"] = { "trakpak3/defect_detectors/ge/w.wav", 0.63 },
	["weather"] = { "trakpak3/defect_detectors/ge/weather.wav", 0.55 },
	["west"] = { "trakpak3/defect_detectors/ge/west.wav", 0.53 },
	["wide"] = { "trakpak3/defect_detectors/ge/wide.wav", 0.54 },
	["x"] = { "trakpak3/defect_detectors/ge/x.wav", 0.57 },
	["y"] = { "trakpak3/defect_detectors/ge/y.wav", 0.76 },
	["you_have_a_defect"] = { "trakpak3/defect_detectors/ge/you_have_a_defect.wav", 1.49 },
	["z"] = { "trakpak3/defect_detectors/ge/z.wav", 0.59 }


}
--Paree (Tinkleheart)
Trakpak3.EDD.SoundFonts["paree"] = {
	staticloop = "trakpak3/defect_detectors/static.wav",
	--delay = 0.05,
	delay = -0.1,

	["0"] = { "trakpak3/defect_detectors/paree/0.wav", 0.86 },
	["1"] = { "trakpak3/defect_detectors/paree/1.wav", 0.81 },
	["2"] = { "trakpak3/defect_detectors/paree/2.wav", 0.68 },
	["3"] = { "trakpak3/defect_detectors/paree/3.wav", 0.7 },
	["4"] = { "trakpak3/defect_detectors/paree/4.wav", 0.7 },
	["5"] = { "trakpak3/defect_detectors/paree/5.wav", 0.62 },
	["6"] = { "trakpak3/defect_detectors/paree/6.wav", 0.93 },
	["7"] = { "trakpak3/defect_detectors/paree/7.wav", 0.91 },
	["8"] = { "trakpak3/defect_detectors/paree/8.wav", 0.57 },
	["9"] = { "trakpak3/defect_detectors/paree/9.wav", 0.78 },
	["a"] = { "trakpak3/defect_detectors/paree/a.wav", 0.6 },
	["a_ground_inspection_is_required"] = { "trakpak3/defect_detectors/paree/a_ground_inspection_is_required.wav", 2.73 },
	["ambient"] = { "trakpak3/defect_detectors/paree/ambient.wav", 0.83 },
	["and"] = { "trakpak3/defect_detectors/paree/and.wav", 0.63 },
	["axle"] = { "trakpak3/defect_detectors/paree/axle.wav", 0.89 },
	["axles"] = { "trakpak3/defect_detectors/paree/axles.wav", 1.07 },
	["b"] = { "trakpak3/defect_detectors/paree/b.wav", 0.62 },
	["beep"] = { "trakpak3/defect_detectors/paree/beep.wav", 0.5 },
	["c"] = { "trakpak3/defect_detectors/paree/c.wav", 0.73 },
	["car"] = { "trakpak3/defect_detectors/paree/car.wav", 0.76 },
	["cars"] = { "trakpak3/defect_detectors/paree/cars.wav", 1.07 },
	["celsius"] = { "trakpak3/defect_detectors/paree/celsius.wav", 1.1 },
	["count"] = { "trakpak3/defect_detectors/paree/count.wav", 0.73 },
	["d"] = { "trakpak3/defect_detectors/paree/d.wav", 0.6 },
	["defect"] = { "trakpak3/defect_detectors/paree/defect.wav", 0.72 },
	["defect_as_follows"] = { "trakpak3/defect_detectors/paree/defect_as_follows.wav", 2 },
	["degrees"] = { "trakpak3/defect_detectors/paree/degrees.wav", 0.92 },
	["detector"] = { "trakpak3/defect_detectors/paree/detector.wav", 0.94 },
	["detector_out"] = { "trakpak3/defect_detectors/paree/detector_out.wav", 1.26 },
	["dragging_equipment"] = { "trakpak3/defect_detectors/paree/dragging_equipment.wav", 1.33 },
	["e"] = { "trakpak3/defect_detectors/paree/e.wav", 0.65 },
	["east"] = { "trakpak3/defect_detectors/paree/east.wav", 0.74 },
	["end_of_transmission"] = { "trakpak3/defect_detectors/paree/end_of_transmission.wav", 1.46 },
	["equipment"] = { "trakpak3/defect_detectors/paree/equipment.wav", 0.79 },
	["f"] = { "trakpak3/defect_detectors/paree/f.wav", 0.7 },
	["fahrenheit"] = { "trakpak3/defect_detectors/paree/fahrenheit.wav", 1.03 },
	["feet"] = { "trakpak3/defect_detectors/paree/feet.wav", 0.76 },
	["g"] = { "trakpak3/defect_detectors/paree/g.wav", 0.73 },
	["h"] = { "trakpak3/defect_detectors/paree/h.wav", 0.93 },
	["hot_box"] = { "trakpak3/defect_detectors/paree/hot_box.wav", 1.08 },
	["hot_wheel"] = { "trakpak3/defect_detectors/paree/hot_wheel.wav", 1.02 },
	["i"] = { "trakpak3/defect_detectors/paree/i.wav", 0.75 },
	["inspect"] = { "trakpak3/defect_detectors/paree/inspect.wav", 1 },
	["j"] = { "trakpak3/defect_detectors/paree/j.wav", 0.75 },
	["k"] = { "trakpak3/defect_detectors/paree/k.wav", 0.78 },
	["kph"] = { "trakpak3/defect_detectors/paree/kph.wav", 2.12 },
	["l"] = { "trakpak3/defect_detectors/paree/l.wav", 0.75 },
	["left"] = { "trakpak3/defect_detectors/paree/left.wav", 0.71 },
	["length_of_train"] = { "trakpak3/defect_detectors/paree/length_of_train.wav", 1.59 },
	["m"] = { "trakpak3/defect_detectors/paree/m.wav", 0.62 },
	["main"] = { "trakpak3/defect_detectors/paree/main.wav", 0.57 },
	["meters"] = { "trakpak3/defect_detectors/paree/meters.wav", 1.01 },
	["middle"] = { "trakpak3/defect_detectors/paree/middle.wav", 0.6 },
	["milepost"] = { "trakpak3/defect_detectors/paree/milepost.wav", 1.03 },
	["minus"] = { "trakpak3/defect_detectors/paree/minus.wav", 0.98 },
	["mph"] = { "trakpak3/defect_detectors/paree/mph.wav", 1.72 },
	["n"] = { "trakpak3/defect_detectors/paree/n.wav", 0.7 },
	["near"] = { "trakpak3/defect_detectors/paree/near.wav", 0.69 },
	["no_defects"] = { "trakpak3/defect_detectors/paree/no_defects.wav", 1.35 },
	["north"] = { "trakpak3/defect_detectors/paree/north.wav", 0.6 },
	["notify_dispatcher"] = { "trakpak3/defect_detectors/paree/notify_dispatcher.wav", 1.67 },
	["o"] = { "trakpak3/defect_detectors/paree/o.wav", 0.68 },
	["p"] = { "trakpak3/defect_detectors/paree/p.wav", 0.78 },
	["point"] = { "trakpak3/defect_detectors/paree/point.wav", 0.7 },
	["q"] = { "trakpak3/defect_detectors/paree/q.wav", 0.75 },
	["r"] = { "trakpak3/defect_detectors/paree/r.wav", 0.65 },
	["rail"] = { "trakpak3/defect_detectors/paree/rail.wav", 0.7 },
	["railroad"] = { "trakpak3/defect_detectors/paree/railroad.wav", 0.97 },
	["railway"] = { "trakpak3/defect_detectors/paree/railway.wav", 1 },
	["repeat"] = { "trakpak3/defect_detectors/paree/repeat.wav", 0.54 },
	["right"] = { "trakpak3/defect_detectors/paree/right.wav", 0.62 },
	["s"] = { "trakpak3/defect_detectors/paree/s.wav", 0.81 },
	["side"] = { "trakpak3/defect_detectors/paree/side.wav", 0.77 },
	["south"] = { "trakpak3/defect_detectors/paree/south.wav", 0.71 },
	["stop_your_train"] = { "trakpak3/defect_detectors/paree/stop_your_train.wav", 1.66 },
	["system"] = { "trakpak3/defect_detectors/paree/system.wav", 1.05 },
	["t"] = { "trakpak3/defect_detectors/paree/t.wav", 0.7 },
	["temperature"] = { "trakpak3/defect_detectors/paree/temperature.wav", 0.91 },
	["total"] = { "trakpak3/defect_detectors/paree/total.wav", 0.82 },
	["track"] = { "trakpak3/defect_detectors/paree/track.wav", 0.54 },
	["train_speed"] = { "trakpak3/defect_detectors/paree/train_speed.wav", 1.23 },
	["u"] = { "trakpak3/defect_detectors/paree/u.wav", 0.75 },
	["v"] = { "trakpak3/defect_detectors/paree/v.wav", 0.73 },
	["w"] = { "trakpak3/defect_detectors/paree/w.wav", 0.91 },
	["west"] = { "trakpak3/defect_detectors/paree/west.wav", 0.7 },
	["x"] = { "trakpak3/defect_detectors/paree/x.wav", 0.88 },
	["y"] = { "trakpak3/defect_detectors/paree/y.wav", 0.81 },
	["you_have_a_defect"] = { "trakpak3/defect_detectors/paree/you_have_a_defect.wav", 1.28 },
	["z"] = { "trakpak3/defect_detectors/paree/z.wav", 0.73 }
}
--Text to Speech (e-Speak MS David)
Trakpak3.EDD.SoundFonts["tts"] = {
	staticloop = "trakpak3/defect_detectors/static.wav",
	delay = -0.1,
	
	["0"] = { "trakpak3/defect_detectors/tts/0.wav", 0.56 },
	["1"] = { "trakpak3/defect_detectors/tts/1.wav", 0.42 },
	["2"] = { "trakpak3/defect_detectors/tts/2.wav", 0.42 },
	["3"] = { "trakpak3/defect_detectors/tts/3.wav", 0.49 },
	["4"] = { "trakpak3/defect_detectors/tts/4.wav", 0.52 },
	["5"] = { "trakpak3/defect_detectors/tts/5.wav", 0.59 },
	["6"] = { "trakpak3/defect_detectors/tts/6.wav", 0.68 },
	["7"] = { "trakpak3/defect_detectors/tts/7.wav", 0.68 },
	["8"] = { "trakpak3/defect_detectors/tts/8.wav", 0.35 },
	["9"] = { "trakpak3/defect_detectors/tts/9.wav", 0.59 },
	["a"] = { "trakpak3/defect_detectors/tts/a.wav", 0.38 },
	["a_ground_inspection_is_required"] = { "trakpak3/defect_detectors/tts/a_ground_inspection_is_required.wav", 2.03 },
	["ambient"] = { "trakpak3/defect_detectors/tts/ambient.wav", 0.7 },
	["and"] = { "trakpak3/defect_detectors/tts/and.wav", 0.52 },
	["axle"] = { "trakpak3/defect_detectors/tts/axle.wav", 0.66 },
	["axles"] = { "trakpak3/defect_detectors/tts/axles.wav", 0.73 },
	["b"] = { "trakpak3/defect_detectors/tts/b.wav", 0.4 },
	["beep"] = { "trakpak3/defect_detectors/tts/beep.wav", 0.75 },
	["c"] = { "trakpak3/defect_detectors/tts/c.wav", 0.54 },
	["car"] = { "trakpak3/defect_detectors/tts/car.wav", 0.54 },
	["cars"] = { "trakpak3/defect_detectors/tts/cars.wav", 0.59 },
	["celsius"] = { "trakpak3/defect_detectors/tts/celsius.wav", 0.89 },
	["count"] = { "trakpak3/defect_detectors/tts/count.wav", 0.61 },
	["d"] = { "trakpak3/defect_detectors/tts/d.wav", 0.42 },
	["defect"] = { "trakpak3/defect_detectors/tts/defect.wav", 0.8 },
	["defect_as_follows"] = { "trakpak3/defect_detectors/tts/defect_as_follows.wav", 1.52 },
	["degrees"] = { "trakpak3/defect_detectors/tts/degrees.wav", 0.79 },
	["detector"] = { "trakpak3/defect_detectors/tts/detector.wav", 0.82 },
	["detector_out"] = { "trakpak3/defect_detectors/tts/detector_out.wav", 0.94 },
	["dragging_equipment"] = { "trakpak3/defect_detectors/tts/dragging_equipment.wav", 1.19 },
	["e"] = { "trakpak3/defect_detectors/tts/e.wav", 0.35 },
	["east"] = { "trakpak3/defect_detectors/tts/east.wav", 0.54 },
	["end_of_transmission"] = { "trakpak3/defect_detectors/tts/end_of_transmission.wav", 1.24 },
	["equipment"] = { "trakpak3/defect_detectors/tts/equipment.wav", 0.77 },
	["f"] = { "trakpak3/defect_detectors/tts/f.wav", 0.47 },
	["fahrenheit"] = { "trakpak3/defect_detectors/tts/fahrenheit.wav", 0.77 },
	["feet"] = { "trakpak3/defect_detectors/tts/feet.wav", 0.54 },
	["g"] = { "trakpak3/defect_detectors/tts/g.wav", 0.42 },
	["h"] = { "trakpak3/defect_detectors/tts/h.wav", 0.52 },
	["hot_box"] = { "trakpak3/defect_detectors/tts/hot_box.wav", 0.94 },
	["hot_wheel"] = { "trakpak3/defect_detectors/tts/hot_wheel.wav", 0.77 },
	["i"] = { "trakpak3/defect_detectors/tts/i.wav", 0.38 },
	["inspect"] = { "trakpak3/defect_detectors/tts/inspect.wav", 0.8 },
	["j"] = { "trakpak3/defect_detectors/tts/j.wav", 0.45 },
	["k"] = { "trakpak3/defect_detectors/tts/k.wav", 0.4 },
	["kph"] = { "trakpak3/defect_detectors/tts/kph.wav", 1.45 },
	["l"] = { "trakpak3/defect_detectors/tts/l.wav", 0.49 },
	["left"] = { "trakpak3/defect_detectors/tts/left.wav", 0.59 },
	["length_of_train"] = { "trakpak3/defect_detectors/tts/length_of_train.wav", 1.15 },
	["m"] = { "trakpak3/defect_detectors/tts/m.wav", 0.47 },
	["main"] = { "trakpak3/defect_detectors/tts/main.wav", 0.59 },
	["meters"] = { "trakpak3/defect_detectors/tts/meters.wav", 0.7 },
	["middle"] = { "trakpak3/defect_detectors/tts/middle.wav", 0.59 },
	["milepost"] = { "trakpak3/defect_detectors/tts/milepost.wav", 0.98 },
	["minus"] = { "trakpak3/defect_detectors/tts/minus.wav", 0.7 },
	["mph"] = { "trakpak3/defect_detectors/tts/mph.wav", 1.12 },
	["n"] = { "trakpak3/defect_detectors/tts/n.wav", 0.49 },
	["near"] = { "trakpak3/defect_detectors/tts/near.wav", 0.56 },
	["no_defects"] = { "trakpak3/defect_detectors/tts/no_defects.wav", 1.05 },
	["north"] = { "trakpak3/defect_detectors/tts/north.wav", 0.59 },
	["notify_dispatcher"] = { "trakpak3/defect_detectors/tts/notify_dispatcher.wav", 1.47 },
	["o"] = { "trakpak3/defect_detectors/tts/o.wav", 0.38 },
	["p"] = { "trakpak3/defect_detectors/tts/p.wav", 0.4 },
	["point"] = { "trakpak3/defect_detectors/tts/point.wav", 0.59 },
	["q"] = { "trakpak3/defect_detectors/tts/q.wav", 0.59 },
	["r"] = { "trakpak3/defect_detectors/tts/r.wav", 0.54 },
	["rail"] = { "trakpak3/defect_detectors/tts/rail.wav", 0.52 },
	["railroad"] = { "trakpak3/defect_detectors/tts/railroad.wav", 0.8 },
	["railway"] = { "trakpak3/defect_detectors/tts/railway.wav", 0.68 },
	["repeat"] = { "trakpak3/defect_detectors/tts/repeat.wav", 0.66 },
	["right"] = { "trakpak3/defect_detectors/tts/right.wav", 0.56 },
	["s"] = { "trakpak3/defect_detectors/tts/s.wav", 0.52 },
	["side"] = { "trakpak3/defect_detectors/tts/side.wav", 0.66 },
	["south"] = { "trakpak3/defect_detectors/tts/south.wav", 0.63 },
	["stop_your_train"] = { "trakpak3/defect_detectors/tts/stop_your_train.wav", 1.19 },
	["system"] = { "trakpak3/defect_detectors/tts/system.wav", 0.8 },
	["t"] = { "trakpak3/defect_detectors/tts/t.wav", 0.4 },
	["temperature"] = { "trakpak3/defect_detectors/tts/temperature.wav", 0.84 },
	["total"] = { "trakpak3/defect_detectors/tts/total.wav", 0.61 },
	["track"] = { "trakpak3/defect_detectors/tts/track.wav", 0.68 },
	["train_speed"] = { "trakpak3/defect_detectors/tts/train_speed.wav", 1.01 },
	["u"] = { "trakpak3/defect_detectors/tts/u.wav", 0.49 },
	["v"] = { "trakpak3/defect_detectors/tts/v.wav", 0.49 },
	["w"] = { "trakpak3/defect_detectors/tts/w.wav", 0.8 },
	["west"] = { "trakpak3/defect_detectors/tts/west.wav", 0.63 },
	["x"] = { "trakpak3/defect_detectors/tts/x.wav", 0.59 },
	["y"] = { "trakpak3/defect_detectors/tts/y.wav", 0.52 },
	["you_have_a_defect"] = { "trakpak3/defect_detectors/tts/you_have_a_defect.wav", 1.22 },
	["z"] = { "trakpak3/defect_detectors/tts/z.wav", 0.45 }
}

--"Speak 'N' Spell" (e-speak EN-US)
Trakpak3.EDD.SoundFonts["sns"] = {
	staticloop = "trakpak3/defect_detectors/static.wav",
	delay = 0.1,
	
	["0"] = { "trakpak3/defect_detectors/sns/0.wav", 0.53 },
	["1"] = { "trakpak3/defect_detectors/sns/1.wav", 0.5 },
	["2"] = { "trakpak3/defect_detectors/sns/2.wav", 0.41 },
	["3"] = { "trakpak3/defect_detectors/sns/3.wav", 0.42 },
	["4"] = { "trakpak3/defect_detectors/sns/4.wav", 0.49 },
	["5"] = { "trakpak3/defect_detectors/sns/5.wav", 0.57 },
	["6"] = { "trakpak3/defect_detectors/sns/6.wav", 0.54 },
	["7"] = { "trakpak3/defect_detectors/sns/7.wav", 0.57 },
	["8"] = { "trakpak3/defect_detectors/sns/8.wav", 0.41 },
	["9"] = { "trakpak3/defect_detectors/sns/9.wav", 0.56 },
	["a"] = { "trakpak3/defect_detectors/sns/a.wav", 0.4 },
	["a_ground_inspection_is_required"] = { "trakpak3/defect_detectors/sns/a_ground_inspection_is_required.wav", 1.95 },
	["ambient"] = { "trakpak3/defect_detectors/sns/ambient.wav", 0.7 },
	["and"] = { "trakpak3/defect_detectors/sns/and.wav", 0.45 },
	["axle"] = { "trakpak3/defect_detectors/sns/axle.wav", 0.54 },
	["axles"] = { "trakpak3/defect_detectors/sns/axles.wav", 0.64 },
	["b"] = { "trakpak3/defect_detectors/sns/b.wav", 0.41 },
	["beep"] = { "trakpak3/defect_detectors/sns/beep.wav", 0.5 },
	["c"] = { "trakpak3/defect_detectors/sns/c.wav", 0.41 },
	["car"] = { "trakpak3/defect_detectors/sns/car.wav", 0.5 },
	["cars"] = { "trakpak3/defect_detectors/sns/cars.wav", 0.59 },
	["celsius"] = { "trakpak3/defect_detectors/sns/celsius.wav", 0.74 },
	["count"] = { "trakpak3/defect_detectors/sns/count.wav", 0.55 },
	["d"] = { "trakpak3/defect_detectors/sns/d.wav", 0.36 },
	["defect"] = { "trakpak3/defect_detectors/sns/defect.wav", 0.62 },
	["defect_as_follows"] = { "trakpak3/defect_detectors/sns/defect_as_follows.wav", 1.3 },
	["degrees"] = { "trakpak3/defect_detectors/sns/degrees.wav", 0.63 },
	["detector"] = { "trakpak3/defect_detectors/sns/detector.wav", 0.69 },
	["detector_out"] = { "trakpak3/defect_detectors/sns/detector_out.wav", 0.95 },
	["dragging_equipment"] = { "trakpak3/defect_detectors/sns/dragging_equipment.wav", 1.18 },
	["e"] = { "trakpak3/defect_detectors/sns/e.wav", 0.34 },
	["east"] = { "trakpak3/defect_detectors/sns/east.wav", 0.41 },
	["end_of_transmission"] = { "trakpak3/defect_detectors/sns/end_of_transmission.wav", 1.22 },
	["equipment"] = { "trakpak3/defect_detectors/sns/equipment.wav", 0.82 },
	["f"] = { "trakpak3/defect_detectors/sns/f.wav", 0.38 },
	["fahrenheit"] = { "trakpak3/defect_detectors/sns/fahrenheit.wav", 0.78 },
	["feet"] = { "trakpak3/defect_detectors/sns/feet.wav", 0.43 },
	["g"] = { "trakpak3/defect_detectors/sns/g.wav", 0.38 },
	["h"] = { "trakpak3/defect_detectors/sns/h.wav", 0.45 },
	["hot_box"] = { "trakpak3/defect_detectors/sns/hot_box.wav", 0.87 },
	["hot_wheel"] = { "trakpak3/defect_detectors/sns/hot_wheel.wav", 0.8 },
	["i"] = { "trakpak3/defect_detectors/sns/i.wav", 0.41 },
	["inspect"] = { "trakpak3/defect_detectors/sns/inspect.wav", 0.69 },
	["j"] = { "trakpak3/defect_detectors/sns/j.wav", 0.42 },
	["k"] = { "trakpak3/defect_detectors/sns/k.wav", 0.44 },
	["kph"] = { "trakpak3/defect_detectors/sns/kph.wav", 1.19 },
	["l"] = { "trakpak3/defect_detectors/sns/l.wav", 0.4 },
	["left"] = { "trakpak3/defect_detectors/sns/left.wav", 0.5 },
	["length_of_train"] = { "trakpak3/defect_detectors/sns/length_of_train.wav", 1.09 },
	["m"] = { "trakpak3/defect_detectors/sns/m.wav", 0.45 },
	["main"] = { "trakpak3/defect_detectors/sns/main.wav", 0.56 },
	["meters"] = { "trakpak3/defect_detectors/sns/meters.wav", 0.57 },
	["middle"] = { "trakpak3/defect_detectors/sns/middle.wav", 0.49 },
	["milepost"] = { "trakpak3/defect_detectors/sns/milepost.wav", 0.75 },
	["minus"] = { "trakpak3/defect_detectors/sns/minus.wav", 0.57 },
	["mph"] = { "trakpak3/defect_detectors/sns/mph.wav", 1.03 },
	["n"] = { "trakpak3/defect_detectors/sns/n.wav", 0.45 },
	["near"] = { "trakpak3/defect_detectors/sns/near.wav", 0.53 },
	["no_defects"] = { "trakpak3/defect_detectors/sns/no_defects.wav", 0.99 },
	["north"] = { "trakpak3/defect_detectors/sns/north.wav", 0.51 },
	["notify_dispatcher"] = { "trakpak3/defect_detectors/sns/notify_dispatcher.wav", 1.24 },
	["o"] = { "trakpak3/defect_detectors/sns/o.wav", 0.41 },
	["p"] = { "trakpak3/defect_detectors/sns/p.wav", 0.36 },
	["point"] = { "trakpak3/defect_detectors/sns/point.wav", 0.53 },
	["q"] = { "trakpak3/defect_detectors/sns/q.wav", 0.46 },
	["r"] = { "trakpak3/defect_detectors/sns/r.wav", 0.44 },
	["rail"] = { "trakpak3/defect_detectors/sns/rail.wav", 0.51 },
	["railroad"] = { "trakpak3/defect_detectors/sns/railroad.wav", 0.65 },
	["railway"] = { "trakpak3/defect_detectors/sns/railway.wav", 0.65 },
	["repeat"] = { "trakpak3/defect_detectors/sns/repeat.wav", 0.53 },
	["right"] = { "trakpak3/defect_detectors/sns/right.wav", 0.48 },
	["s"] = { "trakpak3/defect_detectors/sns/s.wav", 0.42 },
	["side"] = { "trakpak3/defect_detectors/sns/side.wav", 0.55 },
	["south"] = { "trakpak3/defect_detectors/sns/south.wav", 0.51 },
	["stop_your_train"] = { "trakpak3/defect_detectors/sns/stop_your_train.wav", 1.13 },
	["system"] = { "trakpak3/defect_detectors/sns/system.wav", 0.59 },
	["t"] = { "trakpak3/defect_detectors/sns/t.wav", 0.38 },
	["temperature"] = { "trakpak3/defect_detectors/sns/temperature.wav", 0.78 },
	["total"] = { "trakpak3/defect_detectors/sns/total.wav", 0.51 },
	["track"] = { "trakpak3/defect_detectors/sns/track.wav", 0.5 },
	["train_speed"] = { "trakpak3/defect_detectors/sns/train_speed.wav", 0.83 },
	["u"] = { "trakpak3/defect_detectors/sns/u.wav", 0.42 },
	["v"] = { "trakpak3/defect_detectors/sns/v.wav", 0.45 },
	["w"] = { "trakpak3/defect_detectors/sns/w.wav", 0.57 },
	["west"] = { "trakpak3/defect_detectors/sns/west.wav", 0.53 },
	["x"] = { "trakpak3/defect_detectors/sns/x.wav", 0.49 },
	["y"] = { "trakpak3/defect_detectors/sns/y.wav", 0.49 },
	["you_have_a_defect"] = { "trakpak3/defect_detectors/sns/you_have_a_defect.wav", 1.09 },
	["z"] = { "trakpak3/defect_detectors/sns/z.wav", 0.46 }
}

--Sound Font Formatter (should only work on Windows?)

concommand.Add("tp3_formatsoundfont",function(ply, cmd, args)
	local fname = args[1] or ""
	local folder = "trakpak3/defect_detectors/"..fname --No 'sound/', no slash
	local sounds = file.Find("sound/"..folder.."/*.wav","GAME")
	
	local text = ""
	
	for n = 1, #sounds do
		local sound = sounds[n]
		local sname = string.Left(sound,#sound-4)
		local fullpath = folder.."/"..sound
		local sdr = math.ceil(SoundDuration(fullpath)*100)/100
		local comma = ",\n"
		if n==#sounds then comma = "" end
		text = text.."[\""..sname.."\"] = { \""..fullpath.."\", "..sdr.." }"..comma
		--print(sname)
	end 
	SetClipboardText(text)
	print("SoundFont data copied to clipboard! "..folder)
end)


--Receive EDD Broadcast from Server
net.Receive("tp3_edd_broadcast", function(length, ply)
	local font = net.ReadString()
	local sentence = net.ReadString()
	
	Trakpak3.EDD.BroadcastNear(font, sentence)
	
end)

concommand.Add("tp3_defect_detector_test", function(ply, cmd, args, argStr)
	local font = args[1]
	local sentence = ""
	
	if font and args[2] then --Play Test Sentence
		sentence = string.Right(argStr,#argStr - (#font+1))
		
		Trakpak3.EDD.BroadcastNear(font, sentence)
		print("Transmitting the following sentence:\n"..sentence.."\n(SoundFont: "..font..")")
	elseif font then --Play all sounds in the font, and print the sounds available
		local soundfont = Trakpak3.EDD.SoundFonts[font]
		if soundfont then
			local wordarray = {}
			for sname, v in pairs(soundfont) do
				if (sname!="delay") and (sname!="staticloop") then
					table.insert(wordarray,sname)
				end
			end
			
			table.sort(wordarray)
			for n = 1, #wordarray do
				sentence = sentence..wordarray[n].." "
				print(wordarray[n])
			end
			
			Trakpak3.EDD.BroadcastNear(font, sentence)
			print("\nTesting all sounds in soundfont '"..font.."'.")
		else
			print("The soundfont '"..font.."' does not exist.")
		end
	else --List Fonts
		print("List of Defect Detector Soundfonts:")
		for k, v in pairs(Trakpak3.EDD.SoundFonts) do print(k) end
	end

end, nil, "Test the Defect Detector functions. You must be near a Trakpak3 Cab Signal Box with the 'Enable' input on.\n1: If you enter no arguments, it will print a list of sound fonts.\n2: If you enter a font name, it will print a list of sounds in that font and play them in alphabetical order.\n3: If you enter a font name and a string of words, it will attempt to play that string of words.")

--Send the EDD message to all cabsignal boxes within 2048 inches of the player
function Trakpak3.EDD.BroadcastNear(font, sentence)
	if font and sentence then
		local ppos = LocalPlayer():GetPos()
		for k, box in pairs(ents.FindByClass("gmod_wire_tp3_cabsignal_box")) do
			local bpos = box:GetPos()
			if bpos:DistToSqr(ppos) < (2048*2048) then
				box:DetectorQueue(font, sentence)
			end
		end
	end
end