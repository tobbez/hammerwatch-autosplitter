// Hammerwatch auto-splitter for Livesplit by tobbez

state("Hammerwatch") {}

startup
{
	vars.debug = (Action<string>)((s) => {
		print("[Hammerwatch.asl] " + s);
	});
	vars.debug_change = (Action<string, dynamic, dynamic>)((name, watcher, format) => {
		if (watcher.Current != watcher.Old) {
			dynamic oldTmp = watcher.Old, currentTmp = watcher.Current;
			if (oldTmp is string) oldTmp = "\"" + oldTmp + "\"";
			if (currentTmp is string) currentTmp = "\"" + currentTmp + "\"";
			vars.debug(String.Format("{0} changed: {1} => {2}", name, oldTmp.ToString(format), currentTmp.ToString(format)));
		}
	});

	vars.scan = (Func<Process, int, string, IntPtr>)((process, offset, needle) => {
		IntPtr ptr = IntPtr.Zero;
		foreach (var page in process.MemoryPages()) {
			var scanner = new SignatureScanner(process, page.BaseAddress, (int)page.RegionSize);
			ptr = scanner.Scan(new SigScanTarget(offset, needle));
			if (ptr != IntPtr.Zero) {
				return ptr;
			}
		}
		return ptr; // not found
	});
	vars.changed = (Func<MemoryWatcher<int>, int, int, bool>)((watcher, old_value, current_value) => {
		return watcher.Old == old_value && watcher.Current == current_value;
	});
        vars.changed_to = (Func<MemoryWatcher<int>, int, bool>)((watcher, current_value) => {
                return watcher.Old != watcher.Current && watcher.Current == current_value;
        });
        vars.changed_from = (Func<MemoryWatcher<int>, int, bool>)((watcher, old_value) => {
                return watcher.Old != watcher.Current && watcher.Old == old_value;
        });

	vars.ReadString = (Func<Process, DeepPointer, string>)((proc, deepPtr) => {
		IntPtr strObjAddr;
		if (!deepPtr.DerefOffsets(proc, out strObjAddr)) return null;

		Int32 length = proc.ReadValue<Int32>(strObjAddr+4);
		if (length > 64) {
			// Longer than reasonable - the pointer is likely pointing at some random memory (and not a string we're looking for)
			return null;
		}
		return proc.ReadString(strObjAddr+8, length*2); // UTF-16 => x2
	});

	vars.NewFakeMemoryWatcher = (Func<dynamic, dynamic>)(initial_value => {
		dynamic w = new ExpandoObject();
		w.Old = initial_value;
		w.Current = initial_value;
		w.Changed = false;
		return w;
	});

	vars.UpdateString = (Action<Process, dynamic, DeepPointer>)((proc, fakeWatcher, ptr) => {
		string new_value = vars.ReadString(proc, ptr);
		if (new_value != null) {
			fakeWatcher.Old = fakeWatcher.Current;
			fakeWatcher.Current = new_value;
			fakeWatcher.Changed = fakeWatcher.Old != fakeWatcher.Current;
		}
	});


	// Initialize splits
	Func<String, Func<String, bool>, KeyValuePair<String, Func<String, bool>>> NewSplitCondition = ((name, cond) => {
		return new KeyValuePair<string, Func<string, bool>>(name, cond);
	});

	// FIXME: add floor 2 split?

	vars.splits = new ExpandoObject();
	vars.splits.conditions = new List<KeyValuePair<string, Func<string, bool>>>();
	// Act 1
	vars.splits.conditions.Add(NewSplitCondition("Floor 1", splitname => vars.CurrentLevel.Old == "1" && vars.CurrentLevel.Current == "3" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Floor 3", splitname => vars.CurrentLevel.Old == "3" && vars.CurrentLevel.Current == "boss_1" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Queen", splitname => vars.CurrentLevel.Old == "boss_1" && vars.CurrentLevel.Current == "4" && ++vars.splits.state[splitname] == 1));
	// Act 2
	vars.splits.conditions.Add(NewSplitCondition("Floor 4", splitname => vars.CurrentLevel.Old == "4" && vars.CurrentLevel.Current == "6" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Floor 6", splitname => vars.CurrentLevel.Old == "4" && vars.CurrentLevel.Current == "5" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Floor 5", splitname => vars.CurrentLevel.Old == "4" && vars.CurrentLevel.Current == "boss_2" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Knight", splitname => vars.CurrentLevel.Old == "boss_2" && vars.CurrentLevel.Current == "7" && ++vars.splits.state[splitname] == 1));
	// Act 3
	vars.splits.conditions.Add(NewSplitCondition("Floor 7", splitname => vars.CurrentLevel.Old == "7" && vars.CurrentLevel.Current == "8" && ++vars.splits.state[splitname] == 2));
	vars.splits.conditions.Add(NewSplitCondition("Floor 8", splitname => vars.CurrentLevel.Old == "8" && vars.CurrentLevel.Current == "9" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Floor 9", splitname => vars.CurrentLevel.Old == "9" && vars.CurrentLevel.Current == "boss_3" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Lich", splitname => vars.CurrentLevel.Old == "boss_3" && vars.CurrentLevel.Current == "10" && ++vars.splits.state[splitname] == 1));
	// Act 4
	vars.splits.conditions.Add(NewSplitCondition("Floor 10", splitname => vars.CurrentLevel.Old == "10" && vars.CurrentLevel.Current == "11" && ++vars.splits.state[splitname] == 2));
	vars.splits.conditions.Add(NewSplitCondition("Floor 11", splitname => vars.CurrentLevel.Old == "11" && vars.CurrentLevel.Current == "12" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Floor 12", splitname => vars.CurrentLevel.Old == "12" && vars.CurrentLevel.Current == "11" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Dragon Reached", splitname => vars.CurrentLevel.Old == "11" && vars.CurrentLevel.Current == "boss_4" && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("Dragon Killed", splitname => vars.CurrentLevel.Current == "boss_4" && vars.GameHUDBossHP.Old > 0.0 && vars.GameHUDBossHP.Current == 0.0 && ++vars.splits.state[splitname] == 1));
	vars.splits.conditions.Add(NewSplitCondition("End", splitname => vars.CurrentLevel.Current == "boss_4" && vars.EndMenuHeader.Current == "e.win-congrats" && ++vars.splits.state[splitname] == 1));

	vars.splits.state = new Dictionary<string, int>();
	foreach(var split in vars.splits.conditions) {
		vars.splits.state.Add(split.Key, 0);
	}

	vars.splits.ResetState = (Action)(() => {
		foreach(var split in vars.splits.conditions) {
			vars.splits.state[split.Key] =  0;
		}
	});

	// Add settings for splits
	string prev = "";
	int act = 0;
	settings.Add("Splits");
	foreach (var split in vars.splits.conditions) {
		if (split.Key.StartsWith("Floor") && !prev.StartsWith("Floor")) {
			settings.CurrentDefaultParent = "Splits";
			act++;
			string actText = "Act " + act.ToString();
			settings.Add(actText);
			settings.CurrentDefaultParent = actText;
		}
		settings.Add(split.Key);
		prev = split.Key;
	}
	settings.CurrentDefaultParent = null;

	vars.debug("Startup complete.");
}

init
{
	IntPtr gameBaseCtor = IntPtr.Zero; // ARPGGame.GameBase::.ctor
	while (gameBaseCtor == IntPtr.Zero) {
		gameBaseCtor = vars.scan(game, 0, "8B C2 8D 15");
		if (gameBaseCtor == IntPtr.Zero) {
			vars.debug("ARPGGame.GameBase::.ctor not found, sleeping");
			System.Threading.Thread.Sleep(1000);
		}
	}

	IntPtr gameBasePtr = (IntPtr)(game.ReadValue<Int32>(gameBaseCtor+4));
	vars.debug(String.Format("gameBasePtr = {0}", gameBasePtr.ToString("X8")));

	// GameBase -> GamePlayers Players
	vars.gamePlayers = new MemoryWatcher<int>(new DeepPointer(gameBasePtr, new Int32[] { 0x38 }));
	vars.gamePlayersPrevValues = new Queue<int>();

	// GameBase -> LevelList lvlList -> LevelEntry CurrentLevel -> String *Id -> String
	vars.CurrentLevelPtr = new DeepPointer(gameBasePtr, new Int32[] { 0x18, 0x14, 4, 0}); // Id
	vars.CurrentLevel = vars.NewFakeMemoryWatcher("");

	// GameBase -> MenuList menus -> List<GameMenu> menus -> List<>._items -> GameMenu _items[0] -> float bossHp
	vars.GameHUDBossHPWatcher = new MemoryWatcher<float>(new DeepPointer(gameBasePtr, new Int32[] { 0x44, 0x8, 0x4, 0x8, 0x4c}));
	vars.GameHUDBossHP = vars.NewFakeMemoryWatcher(0f);
	vars.GameHUDBossHPPrevValues = new Queue<float>();

	// GameBase -> MenuList menus -> List<GameMenu> menus -> List<>._items -> GameMenu _items[0] -> String *header -> String
	vars.EndMenuHeaderPtr = new DeepPointer(gameBasePtr, new Int32[] { 0x44, 0x8, 0x4, 0x8, 0x10, 0x0});
	vars.EndMenuHeader = vars.NewFakeMemoryWatcher("");

	vars.debug("Initialization complete.");
}

update
{
	vars.gamePlayers.Update(game);
	vars.UpdateString(game, vars.CurrentLevel, vars.CurrentLevelPtr);
	vars.UpdateString(game, vars.EndMenuHeader, vars.EndMenuHeaderPtr);
	vars.GameHUDBossHPWatcher.Update(game);

	if (vars.gamePlayers.Current != 0) {
		vars.debug_change("CurrentLevel", vars.CurrentLevel, null);
	}
	
	vars.debug_change("gamePlayers", vars.gamePlayers, "X8");

	// vars.gamePlayers becomes 0 for a very short time during loading
	// screens (detected very rarely by the auto-splitter).
	//
	// Without this workaround, however, a reset would be triggered in those cases
	vars.gamePlayersPrevValues.Enqueue(vars.gamePlayers.Current);
	while (vars.gamePlayersPrevValues.Count > 10) vars.gamePlayersPrevValues.Dequeue();
	
	// When the boss health bar is visible, the game sets the boss HP value
	// to 0, then sets it to the actual value every single update.
	//
	// Check the values from the last 5 times update was called to prevent
	// false positives.
	vars.GameHUDBossHPPrevValues.Enqueue(vars.GameHUDBossHPWatcher.Current);
	while (vars.GameHUDBossHPPrevValues.Count > 5) vars.GameHUDBossHPPrevValues.Dequeue();
	if (vars.GameHUDBossHPWatcher.Current != 0.0 || System.Linq.Enumerable.Sum(vars.GameHUDBossHPPrevValues) == 0.0) {
		vars.GameHUDBossHP.Old = vars.GameHUDBossHP.Current;
		vars.GameHUDBossHP.Current = vars.GameHUDBossHPWatcher.Current;
		vars.Changed = vars.GameHUDBossHP.Old != vars.GameHUDBossHP.Current;
	}
	//vars.debug_change("bossHpWatcher", vars.GameHUDBossHPWatcher, "");
	vars.debug_change("GameHUDBossHP", vars.GameHUDBossHP, "");
}

start
{
	if (vars.changed_from(vars.gamePlayers, 0)) {
		vars.debug("Start triggered");
		vars.splits.ResetState();
		return true;
	}
}

reset
{
	// see related explanation in update above
	if (System.Linq.Enumerable.All(vars.gamePlayersPrevValues, (Func<int, bool>)(x => x == 0))) {
		vars.debug("Reset triggered");
		return true;
	}
}

split
{
	foreach(var split in vars.splits.conditions) {
		if (settings[split.Key] && split.Value(split.Key)) {
			vars.debug("Splitting split '" + split.Key + "'");
			return true;
		}
	}
}
