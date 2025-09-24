from vcdvcd import VCDVCD


class WaveformAssertError(Exception):
    pass


def assert_signal_value_at_time(
    vcd_file: str, signal_name: str, time_ns: int, expected_value: str
):
    """Asserts that a signal has a specific value at a given timestamp."""
    vcd = VCDVCD(vcd_file)

    if signal_name not in vcd.signals:
        raise WaveformAssertError(f"Signal '{signal_name}' not found in VCD file.")

    signal_tv = vcd.signals[signal_name]["tv"]

    # Find the value at or immediately before the specified time
    actual_value = None
    for t, val in signal_tv:
        if t <= time_ns:
            actual_value = val
        else:
            break

    if actual_value is None:
        raise WaveformAssertError(
            f"No value found for signal '{signal_name}' at or before time {time_ns}ns."
        )

    if actual_value != expected_value:
        raise WaveformAssertError(
            f"Assertion failed for signal '{signal_name}' at {time_ns}ns: "
            f"Expected '{expected_value}', got '{actual_value}'."
        )
    print(
        f"Assertion passed: Signal '{signal_name}' at {time_ns}ns is '{actual_value}'."
    )


def assert_signal_toggles(
    vcd_file: str,
    signal_name: str,
    start_time_ns: int,
    end_time_ns: int,
    min_toggles: int,
):
    """Asserts that a signal toggles at least a minimum number of times within a time range."""
    vcd = VCDVCD(vcd_file)

    if signal_name not in vcd.signals:
        raise WaveformAssertError(f"Signal '{signal_name}' not found in VCD file.")

    signal_tv = vcd.signals[signal_name]["tv"]

    toggles = 0
    prev_value = None
    for t, val in signal_tv:
        if start_time_ns <= t <= end_time_ns:
            if prev_value is not None and val != prev_value:
                toggles += 1
            prev_value = val
        elif t > end_time_ns:
            break

    if toggles < min_toggles:
        raise WaveformAssertError(
            f"Assertion failed for signal '{signal_name}' between {start_time_ns}ns and {end_time_ns}ns: "
            f"Expected at least {min_toggles} toggles, got {toggles}."
        )
    print(
        f"Assertion passed: Signal '{signal_name}' toggled {toggles} times (>= {min_toggles}) "
        f"between {start_time_ns}ns and {end_time_ns}ns."
    )


# Add more assertion functions as needed
