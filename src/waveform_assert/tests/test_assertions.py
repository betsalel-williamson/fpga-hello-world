import pytest
from unittest.mock import MagicMock, patch

from waveform_assert.assertions import (
    assert_signal_value_at_time,
    assert_signal_toggles,
    WaveformAssertError,
)

# Helper to create a mock VCDVCD object
def create_mock_vcd(signals_data):
    mock_vcd = MagicMock()
    mock_vcd.signals = {}
    for signal_name, tv_data in signals_data.items():
        mock_vcd.signals[signal_name] = {"tv": tv_data}
    return mock_vcd


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_value_at_time_success(mock_vcdvcd):
    signals_data = {"top.clk": [(0, "0"), (10, "1"), (20, "0")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    assert_signal_value_at_time("dummy.vcd", "top.clk", 15, "1")
    assert_signal_value_at_time("dummy.vcd", "top.clk", 0, "0")
    assert_signal_value_at_time("dummy.vcd", "top.clk", 20, "0")


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_value_at_time_signal_not_found(mock_vcdvcd):
    signals_data = {"top.clk": [(0, "0")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    with pytest.raises(WaveformAssertError, match="Signal 'top.reset' not found in VCD file."):
        assert_signal_value_at_time("dummy.vcd", "top.reset", 10, "1")


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_value_at_time_no_value_found(mock_vcdvcd):
    signals_data = {"top.clk": [(10, "1")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    with pytest.raises(WaveformAssertError, match="No value found for signal 'top.clk' at or before time 5ns."):
        assert_signal_value_at_time("dummy.vcd", "top.clk", 5, "0")


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_value_at_time_value_mismatch(mock_vcdvcd):
    signals_data = {"top.clk": [(0, "0"), (10, "1")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    with pytest.raises(WaveformAssertError, match="Assertion failed for signal 'top.clk' at 10ns: Expected '0', got '1'."):
        assert_signal_value_at_time("dummy.vcd", "top.clk", 10, "0")


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_toggles_success(mock_vcdvcd):
    signals_data = {"top.data": [(0, "0"), (5, "1"), (10, "0"), (15, "1"), (20, "0")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    assert_signal_toggles("dummy.vcd", "top.data", 0, 20, 4)
    assert_signal_toggles("dummy.vcd", "top.data", 0, 10, 2)


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_toggles_signal_not_found(mock_vcdvcd):
    signals_data = {"top.data": [(0, "0")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    with pytest.raises(WaveformAssertError, match="Signal 'top.addr' not found in VCD file."):
        assert_signal_toggles("dummy.vcd", "top.addr", 0, 10, 1)


@patch("waveform_assert.assertions.VCDVCD")
def test_assert_signal_toggles_insufficient_toggles(mock_vcdvcd):
    signals_data = {"top.data": [(0, "0"), (5, "1"), (10, "1"), (15, "0")]}
    mock_vcdvcd.return_value = create_mock_vcd(signals_data)

    with pytest.raises(WaveformAssertError, match="Expected at least 3 toggles, got 2."):
        assert_signal_toggles("dummy.vcd", "top.data", 0, 15, 3)
