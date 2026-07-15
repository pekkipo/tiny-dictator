extends Control

## Developer-only overlay (PRD 02 §15, PRD 05 §7). Toggled with F1 or backtick.
## Every action goes through normal GameManager APIs; owns no gameplay logic.

var _simulator: RunSimulator
var _simulation_running: bool = false


func _ready() -> void:
	_simulator = RunSimulator.new(GameManager)
	visible = false

	%CloseButton.pressed.connect(toggle_visibility)
	%SetResourceButton.pressed.connect(_on_set_resource_pressed)
	%ForceDecisionButton.pressed.connect(_on_force_decision_pressed)
	%AddLawButton.pressed.connect(_on_add_law_pressed)
	%AddFlagButton.pressed.connect(_on_add_flag_pressed)
	%TriggerEndingButton.pressed.connect(_on_trigger_ending_pressed)
	%SetSeedButton.pressed.connect(_on_set_seed_pressed)
	%StartArcButton.pressed.connect(_on_start_arc_pressed)
	%AdvanceArcButton.pressed.connect(_on_advance_arc_pressed)
	%SelectBranchButton.pressed.connect(_on_select_branch_pressed)
	%CompleteArcButton.pressed.connect(_on_complete_arc_pressed)
	%FailArcButton.pressed.connect(_on_fail_arc_pressed)
	%ForceCrisisButton.pressed.connect(_on_force_crisis_pressed)
	%AdvanceCrisisDurationButton.pressed.connect(_on_advance_crisis_duration_pressed)
	%ResolveCrisisButton.pressed.connect(_on_resolve_crisis_pressed)
	%FailCrisisButton.pressed.connect(_on_fail_crisis_pressed)
	%AddQueueEventButton.pressed.connect(_on_add_queue_event_pressed)
	%CancelQueueEventButton.pressed.connect(_on_cancel_queue_event_pressed)
	%ConsumeQueueEventButton.pressed.connect(_on_consume_queue_event_pressed)
	%ForceQueueEventButton.pressed.connect(_on_force_queue_event_pressed)
	%AdvanceDayButton.pressed.connect(_on_advance_day_pressed)
	%RestartButton.pressed.connect(_on_restart_pressed)
	%PrintStateButton.pressed.connect(_on_print_state_pressed)
	%ReloadContentButton.pressed.connect(_on_reload_content_pressed)
	%ResetSaveButton.pressed.connect(_on_reset_save_pressed)
	%AddMedalsButton.pressed.connect(_on_add_medals_pressed)
	%RemoveMedalsButton.pressed.connect(_on_remove_medals_pressed)
	%UnlockEndingButton.pressed.connect(_on_unlock_ending_pressed)
	%PurchaseUpgradeButton.pressed.connect(_on_purchase_upgrade_pressed)
	%ClearUpgradeButton.pressed.connect(_on_clear_upgrade_pressed)
	%ResetMetaButton.pressed.connect(_on_reset_meta_pressed)
	%Sim100Button.pressed.connect(func() -> void: _run_simulation(100))
	%Sim1000Button.pressed.connect(func() -> void: _run_simulation(1000))
	%SimCustomButton.pressed.connect(func() -> void: _run_simulation(int(%SimCountSpin.value)))
	%RunStaticDiagnosticsButton.pressed.connect(_on_run_static_diagnostics_pressed)
	%PrintLatestReportButton.pressed.connect(_on_print_latest_report_pressed)
	%OpenDiagnosticsFolderButton.pressed.connect(_on_open_diagnostics_folder_pressed)

	%SimSeedModeOption.add_item("Fixed")
	%SimSeedModeOption.add_item("Random")
	%SimSeedModeOption.select(0)

	for resource_id in RunState.RESOURCE_IDS:
		%ResourceOption.add_item(resource_id)
	_populate_ending_options()
	_populate_arc_options()
	_populate_crisis_options()
	_populate_upgrade_options()

	EventBus.decision_presented.connect(func(_decision: Dictionary) -> void: _refresh())
	EventBus.decision_resolved.connect(func(_result: DecisionResult) -> void: _refresh())
	EventBus.resources_changed.connect(func(_changes: Dictionary) -> void: _refresh())
	EventBus.run_started.connect(func(_state: RunState) -> void: _refresh())
	EventBus.run_ended.connect(func(_summary: RunSummary) -> void: _refresh())
	EventBus.arc_started.connect(func(_arc_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.arc_advanced.connect(func(_arc_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.arc_completed.connect(func(_arc_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.arc_failed.connect(func(_arc_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.arc_paused.connect(func(_arc_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.crisis_started.connect(func(_crisis_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.crisis_resolved.connect(func(_crisis_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.crisis_failed.connect(func(_crisis_id: String, _runtime: Dictionary) -> void: _refresh())
	EventBus.meta_progression_updated.connect(func() -> void: _refresh())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo \
			and (event.keycode == KEY_F1 or event.keycode == KEY_QUOTELEFT):
		toggle_visibility()
		get_viewport().set_input_as_handled()


func toggle_visibility() -> void:
	visible = not visible
	if visible:
		_populate_ending_options()
		_populate_arc_options()
		_populate_crisis_options()
		_populate_upgrade_options()
		_show_feedback("", true)
		_refresh()


func _refresh() -> void:
	if not visible:
		return
	var state: RunState = GameManager.get_current_state()
	var request_dict: Dictionary = GameManager.debug_get_last_content_request()
	var request_line: String
	if request_dict.is_empty():
		request_line = "request: none"
	else:
		var prefer: String = ", ".join(request_dict.get("preferred_card_types", []))
		var exclude: String = ", ".join(request_dict.get("excluded_tags", []))
		var arc_part: String = ""
		if request_dict.get("crisis_id", "") != "":
			arc_part = " crisis=%s" % request_dict.get("crisis_id", "")
		elif request_dict.get("arc_id", "") != "":
			arc_part = " arc=%s" % request_dict.get("arc_id", "")
		request_line = "request: %s%s prefer=%s exclude=%s (%s)" % [
			request_dict.get("request_type", ""),
			arc_part,
			prefer if not prefer.is_empty() else "(none)",
			exclude if not exclude.is_empty() else "(none)",
			request_dict.get("reason", ""),
		]

	var arc_state: Dictionary = GameManager.debug_get_arc_state()
	var active_lines: PackedStringArray = []
	for arc_id in arc_state.get("active_arcs", {}):
		var runtime: Dictionary = arc_state["active_arcs"][arc_id]
		active_lines.append("%s [%s step %s branch %s]" % [
			arc_id,
			runtime.get("status", "?"),
			str(runtime.get("current_step", "?")),
			runtime.get("branch_id", "(none)"),
		])
	var completed: Array = arc_state.get("completed_arc_ids", [])
	var failed: Array = arc_state.get("failed_arc_ids", [])

	var crisis_state: Dictionary = GameManager.debug_get_crisis_state()
	var crisis_line: String
	if crisis_state.is_empty() or str(crisis_state.get("status", "")).is_empty():
		crisis_line = "active crisis: (none)"
	else:
		crisis_line = "active crisis: %s [%s] started day %s" % [
			crisis_state.get("crisis_id", "?"),
			crisis_state.get("status", "?"),
			str(crisis_state.get("started_day", "?")),
		]

	var lines: PackedStringArray = [
		"phase: %s   day: %d   seed: %d" % [
			RunState.RunPhase.keys()[state.run_phase], state.day, state.random_seed,
		],
		"meta: medals=%d  endings=%d  upgrades=%d  save=v%d  runs=%d" % [
			MetaProgressionManager.get_medals(),
			MetaProgressionManager.get_unlocked_ending_ids().size(),
			MetaProgressionManager.get_purchased_upgrades().size(),
			MetaProgressionManager.get_save_version(),
			MetaProgressionManager.get_total_runs_completed(),
		],
		"decision: %s" % (state.current_decision_id if not state.current_decision_id.is_empty() else "(none)"),
		"stage: %s" % GameManager.get_current_stage_id(),
		request_line,
		"active arcs: %s" % (", ".join(active_lines) if not active_lines.is_empty() else "(none)"),
		"completed arcs: %s" % (", ".join(completed) if not completed.is_empty() else "(none)"),
		"failed arcs: %s" % (", ".join(failed) if not failed.is_empty() else "(none)"),
		crisis_line,
		"resources: 💰 %d  🙂 %d  🛡 %d  👑 %d" % [state.treasury, state.happiness, state.order, state.elite_loyalty],
		"laws: %s" % (", ".join(state.active_laws) if not state.active_laws.is_empty() else "(none)"),
		"flags: %s" % (", ".join(state.flags) if not state.flags.is_empty() else "(none)"),
		"counters: %s" % (JSON.stringify(state.counters) if not state.counters.is_empty() else "(none)"),
		"affinity: %s" % AdvisorRelationshipManager.format_affinity_dict(state, GameManager.get_content()),
		"traits: %s" % RulerTraitManager.format_traits_dict(state),
		"event queue:",
	]
	var queue: Array = GameManager.debug_get_queue_state()
	if queue.is_empty():
		lines.append("  (none)")
	else:
		for event in queue:
			if event is Dictionary:
				var target: String = str(event.get("decision_id", ""))
				if target.is_empty():
					target = str(event.get("pool_id", "(pool)"))
				lines.append("  %s [%s] %s days %d-%d pri %d%s" % [
					event.get("event_id", "?"),
					event.get("status", "?"),
					target,
					int(event.get("earliest_day", 0)),
					int(event.get("latest_day", 0)),
					int(event.get("priority", 0)),
					" MANDATORY" if bool(event.get("mandatory", false)) else "",
				])
	_populate_queue_options(queue)
	%StateLabel.text = "\n".join(lines)


func _populate_ending_options() -> void:
	%EndingOption.clear()
	for ending in GameManager.get_content().get_raw_endings():
		%EndingOption.add_item(str(ending.get("id", "")))


func _populate_arc_options() -> void:
	%ArcOption.clear()
	for arc in GameManager.get_content().get_raw_arcs():
		%ArcOption.add_item(str(arc.get("id", "")))


func _populate_crisis_options() -> void:
	%CrisisOption.clear()
	for crisis in GameManager.get_content().get_raw_crises():
		%CrisisOption.add_item(str(crisis.get("id", "")))


func _populate_upgrade_options() -> void:
	%UpgradeOption.clear()
	for upgrade in GameManager.get_content().get_raw_palace_upgrades():
		%UpgradeOption.add_item(str(upgrade.get("id", "")))
	%UnlockEndingOption.clear()
	for ending in GameManager.get_content().get_raw_endings():
		%UnlockEndingOption.add_item(str(ending.get("id", "")))


func _selected_upgrade_id() -> String:
	if %UpgradeOption.selected < 0:
		return ""
	return %UpgradeOption.get_item_text(%UpgradeOption.selected)


func _selected_unlock_ending_id() -> String:
	if %UnlockEndingOption.selected < 0:
		return ""
	return %UnlockEndingOption.get_item_text(%UnlockEndingOption.selected)


func _selected_crisis_id() -> String:
	if %CrisisOption.selected < 0:
		return ""
	return %CrisisOption.get_item_text(%CrisisOption.selected)


func _populate_queue_options(queue: Array) -> void:
	var previous: String = ""
	if %QueueEventOption.selected >= 0:
		previous = %QueueEventOption.get_item_text(%QueueEventOption.selected)
	%QueueEventOption.clear()
	for event in queue:
		if event is Dictionary:
			%QueueEventOption.add_item(str(event.get("event_id", "")))
	if not previous.is_empty():
		for i in %QueueEventOption.item_count:
			if %QueueEventOption.get_item_text(i) == previous:
				%QueueEventOption.select(i)
				return


func _selected_queue_event_id() -> String:
	if %QueueEventOption.selected < 0:
		return ""
	return %QueueEventOption.get_item_text(%QueueEventOption.selected)


func _selected_arc_id() -> String:
	if %ArcOption.selected < 0:
		return ""
	return %ArcOption.get_item_text(%ArcOption.selected)


func _show_feedback(message: String, ok: bool) -> void:
	%FeedbackLabel.text = message
	%FeedbackLabel.add_theme_color_override(
		"font_color", Color(0.6, 0.9, 0.6) if ok else Color(0.95, 0.5, 0.4))
	_refresh()


func _on_set_resource_pressed() -> void:
	var resource_id: String = %ResourceOption.get_item_text(%ResourceOption.selected)
	var value: int = int(%ResourceValueSpin.value)
	GameManager.debug_set_resource(resource_id, value)
	_show_feedback("Set %s to %d." % [resource_id, value], true)


func _on_force_decision_pressed() -> void:
	var decision_id: String = %ForceDecisionEdit.text.strip_edges()
	if GameManager.force_decision(decision_id):
		_show_feedback("Forced '%s' as the next decision." % decision_id, true)
	else:
		_show_feedback("Unknown decision '%s'." % decision_id, false)


func _on_add_law_pressed() -> void:
	var law_id: String = %AddLawEdit.text.strip_edges()
	if GameManager.debug_add_law(law_id):
		_show_feedback("Law '%s' added." % law_id, true)
	else:
		_show_feedback("Cannot add law '%s' (unknown or already active)." % law_id, false)


func _on_add_flag_pressed() -> void:
	var flag_id: String = %AddFlagEdit.text.strip_edges()
	if GameManager.debug_add_flag(flag_id):
		_show_feedback("Flag '%s' added." % flag_id, true)
	else:
		_show_feedback("Cannot add flag '%s' (empty or already set)." % flag_id, false)


func _on_trigger_ending_pressed() -> void:
	if %EndingOption.selected < 0:
		return
	var ending_id: String = %EndingOption.get_item_text(%EndingOption.selected)
	GameManager.debug_trigger_ending(ending_id)
	_show_feedback("Triggered ending '%s'." % ending_id, true)


func _on_set_seed_pressed() -> void:
	var text: String = %SeedEdit.text.strip_edges()
	if not text.is_empty() and not text.is_valid_int():
		_show_feedback("Seed must be an integer (0 clears).", false)
		return
	var new_seed: int = int(text) if not text.is_empty() else 0
	GameManager.debug_set_fixed_seed(new_seed)
	_show_feedback("Fixed seed cleared." if new_seed == 0 else "Next run uses seed %d." % new_seed, true)


func _on_start_arc_pressed() -> void:
	var arc_id: String = _selected_arc_id()
	if arc_id.is_empty():
		_show_feedback("Select an arc first.", false)
		return
	var branch_id: String = %ArcBranchEdit.text.strip_edges()
	if GameManager.debug_start_arc(arc_id, branch_id):
		_show_feedback("Started arc '%s'." % arc_id, true)
	else:
		_show_feedback("Cannot start arc '%s'." % arc_id, false)


func _on_advance_arc_pressed() -> void:
	var arc_id: String = _selected_arc_id()
	if arc_id.is_empty():
		_show_feedback("Select an arc first.", false)
		return
	if GameManager.debug_advance_arc(arc_id, GameManager.get_current_state().current_decision_id):
		_show_feedback("Advanced arc '%s'." % arc_id, true)
	else:
		_show_feedback("Cannot advance arc '%s'." % arc_id, false)


func _on_select_branch_pressed() -> void:
	var arc_id: String = _selected_arc_id()
	var branch_id: String = %ArcBranchEdit.text.strip_edges()
	if arc_id.is_empty() or branch_id.is_empty():
		_show_feedback("Select an arc and enter a branch id.", false)
		return
	if GameManager.debug_select_branch(arc_id, branch_id):
		_show_feedback("Branch '%s' set on '%s'." % [branch_id, arc_id], true)
	else:
		_show_feedback("Cannot set branch on '%s'." % arc_id, false)


func _on_complete_arc_pressed() -> void:
	var arc_id: String = _selected_arc_id()
	if arc_id.is_empty():
		_show_feedback("Select an arc first.", false)
		return
	if GameManager.debug_complete_arc(arc_id, GameManager.get_current_state().current_decision_id):
		_show_feedback("Completed arc '%s'." % arc_id, true)
	else:
		_show_feedback("Cannot complete arc '%s'." % arc_id, false)


func _on_fail_arc_pressed() -> void:
	var arc_id: String = _selected_arc_id()
	if arc_id.is_empty():
		_show_feedback("Select an arc first.", false)
		return
	if GameManager.debug_fail_arc(arc_id):
		_show_feedback("Failed arc '%s'." % arc_id, true)
	else:
		_show_feedback("Cannot fail arc '%s'." % arc_id, false)


func _on_force_crisis_pressed() -> void:
	var crisis_id: String = _selected_crisis_id()
	if crisis_id.is_empty():
		_show_feedback("Select a crisis first.", false)
		return
	if GameManager.debug_force_crisis(crisis_id):
		_show_feedback("Forced crisis '%s'." % crisis_id, true)
	else:
		_show_feedback("Cannot force crisis '%s'." % crisis_id, false)


func _on_advance_crisis_duration_pressed() -> void:
	if GameManager.debug_advance_crisis_duration(int(%CrisisDurationSpin.value)):
		_show_feedback("Crisis duration advanced.", true)
	else:
		_show_feedback("No active crisis to advance.", false)


func _on_resolve_crisis_pressed() -> void:
	var crisis_id: String = _selected_crisis_id()
	if crisis_id.is_empty():
		_show_feedback("Select a crisis first.", false)
		return
	if GameManager.debug_resolve_crisis(crisis_id, "debug"):
		_show_feedback("Resolved crisis '%s'." % crisis_id, true)
	else:
		_show_feedback("Cannot resolve crisis '%s'." % crisis_id, false)


func _on_fail_crisis_pressed() -> void:
	var crisis_id: String = _selected_crisis_id()
	if crisis_id.is_empty():
		_show_feedback("Select a crisis first.", false)
		return
	if GameManager.debug_fail_crisis(crisis_id, "debug"):
		_show_feedback("Failed crisis '%s'." % crisis_id, true)
	else:
		_show_feedback("Cannot fail crisis '%s'." % crisis_id, false)


func _on_add_queue_event_pressed() -> void:
	var decision_id: String = %QueueDecisionEdit.text.strip_edges()
	var min_delay: int = int(%QueueMinDelaySpin.value)
	var max_delay: int = int(%QueueMaxDelaySpin.value)
	var event_id: String = GameManager.debug_add_queued_event(decision_id, min_delay, max_delay)
	if not event_id.is_empty():
		_show_feedback("Queued event '%s' for '%s'." % [event_id, decision_id], true)
	else:
		_show_feedback("Cannot queue decision '%s'." % decision_id, false)


func _on_cancel_queue_event_pressed() -> void:
	var event_id: String = _selected_queue_event_id()
	if event_id.is_empty():
		_show_feedback("No queue event selected.", false)
		return
	if GameManager.debug_cancel_queued_event(event_id):
		_show_feedback("Cancelled event '%s'." % event_id, true)
	else:
		_show_feedback("Cannot cancel event '%s'." % event_id, false)


func _on_consume_queue_event_pressed() -> void:
	var event_id: String = _selected_queue_event_id()
	if event_id.is_empty():
		_show_feedback("No queue event selected.", false)
		return
	if GameManager.debug_consume_queued_event(event_id):
		_show_feedback("Consumed event '%s'." % event_id, true)
	else:
		_show_feedback("Cannot consume event '%s'." % event_id, false)


func _on_force_queue_event_pressed() -> void:
	var event_id: String = _selected_queue_event_id()
	if event_id.is_empty():
		_show_feedback("No queue event selected.", false)
		return
	if GameManager.debug_force_queued_event(event_id):
		_show_feedback("Forced queued event '%s' as next decision." % event_id, true)
	else:
		_show_feedback("Cannot force queued event '%s'." % event_id, false)


func _on_advance_day_pressed() -> void:
	if GameManager.debug_advance_day():
		_show_feedback("Advanced to day %d." % GameManager.get_current_state().day, true)
	else:
		_show_feedback("Cannot advance day now (no run awaiting a decision).", false)


func _on_restart_pressed() -> void:
	GameManager.restart_run()
	_show_feedback("Run restarted.", true)


func _on_print_state_pressed() -> void:
	GameManager.debug_print_state()
	_show_feedback("State JSON printed to console.", true)


func _on_reload_content_pressed() -> void:
	var ok: bool = GameManager.reload_content()
	_populate_ending_options()
	_populate_arc_options()
	_populate_crisis_options()
	_show_feedback("Content reloaded. Valid: %s." % ok, ok)


func _on_reset_save_pressed() -> void:
	SaveManager.reset_save()
	_show_feedback("Full save reset.", true)


func _on_add_medals_pressed() -> void:
	var amount: int = int(%MedalsSpin.value)
	MetaProgressionManager.add_medals(amount)
	_show_feedback("Added %d medal(s)." % amount, true)


func _on_remove_medals_pressed() -> void:
	var amount: int = int(%MedalsSpin.value)
	MetaProgressionManager.add_medals(-amount)
	_show_feedback("Removed %d medal(s)." % amount, true)


func _on_unlock_ending_pressed() -> void:
	var ending_id: String = _selected_unlock_ending_id()
	if ending_id.is_empty():
		_show_feedback("Select an ending first.", false)
		return
	var result: Dictionary = MetaProgressionManager.record_ending_reached(ending_id, 1)
	_show_feedback("Unlocked ending '%s' (new=%s)." % [ending_id, result.get("is_new", false)], true)


func _on_purchase_upgrade_pressed() -> void:
	var upgrade_id: String = _selected_upgrade_id()
	if upgrade_id.is_empty():
		_show_feedback("Select an upgrade first.", false)
		return
	if MetaProgressionManager.purchase_upgrade(upgrade_id, GameManager.get_content()):
		_show_feedback("Purchased upgrade '%s'." % upgrade_id, true)
	else:
		_show_feedback("Cannot purchase '%s'." % upgrade_id, false)


func _on_clear_upgrade_pressed() -> void:
	var upgrade_id: String = _selected_upgrade_id()
	if upgrade_id.is_empty():
		_show_feedback("Select an upgrade first.", false)
		return
	MetaProgressionManager.clear_upgrade(upgrade_id)
	_show_feedback("Cleared upgrade '%s'." % upgrade_id, true)


func _on_reset_meta_pressed() -> void:
	MetaProgressionManager.reset_meta_progression()
	_show_feedback("Meta progression reset.", true)


func _build_simulation_config(run_count: int) -> SimulationConfig:
	var config := SimulationConfig.new()
	config.run_count = run_count
	config.seed_mode = SimulationConfig.SEED_MODE_RANDOM \
		if %SimSeedModeOption.selected == 1 else SimulationConfig.SEED_MODE_FIXED
	var seed_text: String = %SimSeedEdit.text.strip_edges()
	if seed_text.is_valid_int():
		config.base_seed = int(seed_text)
	elif config.seed_mode == SimulationConfig.SEED_MODE_FIXED:
		config.base_seed = SimulationConfig.DEFAULT_BASE_SEED
	config.include_static_diagnostics = run_count <= 100
	config.export_report = true
	return config


func _run_simulation(run_count: int) -> void:
	if _simulation_running:
		_show_feedback("Simulation already running.", false)
		return
	if not GameManager.is_content_valid():
		_show_feedback("Content invalid; cannot simulate.", false)
		return
	_simulation_running = true
	_set_simulation_buttons_disabled(true)
	_show_feedback("Running %d simulation(s)..." % run_count, true)
	await get_tree().process_frame

	var config := _build_simulation_config(run_count)
	var report: SimulationReport = _simulator.run_batch(config)
	var sim: Dictionary = report.simulation
	var errors: Array = sim.get("errors", [])
	var message: String = "Simulation complete: %d run(s)." % int(sim.get("run_count", 0))
	if not errors.is_empty():
		message += " %d error(s)." % errors.size()
	if report.export_paths.has("text"):
		message += " Report exported."
	_show_feedback(message, errors.is_empty())
	_set_simulation_buttons_disabled(false)
	_simulation_running = false


func _set_simulation_buttons_disabled(disabled: bool) -> void:
	%Sim100Button.disabled = disabled
	%Sim1000Button.disabled = disabled
	%SimCustomButton.disabled = disabled
	%RunStaticDiagnosticsButton.disabled = disabled


func _on_run_static_diagnostics_pressed() -> void:
	if _simulation_running:
		return
	_simulation_running = true
	_set_simulation_buttons_disabled(true)
	var report: SimulationReport = _simulator.run_static_diagnostics("ministan", true)
	var total: int = int(report.static_diagnostics.get("summary", {}).get("total_findings", 0))
	_show_feedback("Static diagnostics complete: %d finding(s)." % total, true)
	_set_simulation_buttons_disabled(false)
	_simulation_running = false


func _on_print_latest_report_pressed() -> void:
	var path: String = SimulationReport.get_latest_export_path("txt")
	if path.is_empty():
		_show_feedback("No diagnostics report found.", false)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_show_feedback("Cannot read latest report.", false)
		return
	print("[DIAG] Latest report (%s):\n%s" % [path, file.get_as_text()])
	file.close()
	_show_feedback("Latest report printed to console.", true)


func _on_open_diagnostics_folder_pressed() -> void:
	SimulationReport._ensure_diagnostics_dir()
	var absolute_path: String = SimulationReport.get_diagnostics_dir_absolute()
	var err := OS.shell_open(absolute_path)
	if err != OK:
		_show_feedback("Cannot open diagnostics folder.", false)
	else:
		_show_feedback("Opened diagnostics folder.", true)
