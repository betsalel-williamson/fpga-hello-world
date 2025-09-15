import subprocess
from waveform_exporter.backends import (
    WaveformExporterBackend,
    GtkWaveBackend,
    MatplotlibBackend,
)


def _is_gtkwave_available() -> bool:
    """Checks if gtkwave executable is available in PATH."""
    return subprocess.run(["which", "gtkwave"], capture_output=True).returncode == 0


class WaveformExporter:
    def __init__(self):
        if _is_gtkwave_available():
            print("GTKWave detected. Using GtkWaveBackend.")
            self.backend: WaveformExporterBackend = GtkWaveBackend()
        else:
            print("GTKWave not found. Falling back to MatplotlibBackend.")
            self.backend: WaveformExporterBackend = MatplotlibBackend()

    def export(self, vcd_file: str, output_path: str, signals_to_display: list[str]):
        self.backend.export_waveform(vcd_file, output_path, signals_to_display)
