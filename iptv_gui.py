import sys
import subprocess
# Extra tools needed for Source Manager
import yaml  # lets us read YAML files like sources.yaml
import requests  # lets us check if a URL is reachable

# PyQt6 GUI components
from PyQt6.QtWidgets import (
    QApplication, QWidget, QPushButton, QVBoxLayout, QLabel, QTextEdit, QMessageBox,
    QTableWidget, QTableWidgetItem, QHeaderView  # needed for Source Manager table
)
from PyQt6.QtCore import Qt

class IPTVGui(QWidget):

    def __init__(self):
        super().__init__()
        self.setWindowTitle("IPTV Harmonization System")
        self.setGeometry(300, 300, 600, 400)

        self.output = QTextEdit()
        self.output.setReadOnly(True)

        layout = QVBoxLayout()
        layout.addWidget(QLabel("📺 Select a module to run:"))

        modules = {
            "Fetch Sources": "scripts/fetch_sources.ps1",
            "Normalize & Resolve": "scripts/Normalize-And-Resolve.ps1",
            "Transform Canonical": "scripts/Transform-Canonical.ps1",
            "Reconcile & Match": "scripts/Reconcile-And-Match.ps1",
            "Generate Outputs": "scripts/Generate-Outputs.ps1",
            "Enrich Metadata": "scripts/Enrich-Metadata.ps1"
        }

        for label, script in modules.items():
            btn = QPushButton(label)
            btn.clicked.connect(lambda _, s=script: self.run_script(s))
            layout.addWidget(btn)

        layout.addWidget(QLabel("📝 Output:"))
        layout.addWidget(self.output)
        self.setLayout(layout)

    def run_script(self, script_path):
        self.output.clear()
        try:
            result = subprocess.run(
                ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
                capture_output=True, text=True, timeout=300
            )
            self.output.setPlainText(result.stdout + "\n" + result.stderr)
            if result.returncode != 0:
                QMessageBox.warning(self, "Error", f"Script failed:\n{result.stderr}")
        except Exception as e:
            QMessageBox.critical(self, "Exception", str(e))

    # 📦 Source Manager Panel — shows all sources from sources.yaml
def show_source_manager(self):
    try:
        # Try to open and read the sources.yaml file
        with open("config/sources.yaml", "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            sources = data.get("sources", [])
    except Exception as e:
        # If there's an error reading the file, show a popup
        QMessageBox.critical(self, "YAML Error", f"Failed to load sources.yaml:\n{e}")
        return

    # Create a table with 6 columns
    table = QTableWidget()
    table.setColumnCount(6)
    table.setHorizontalHeaderLabels(["Name", "Type", "Country", "URL", "Enabled", "Status"])
    table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
    table.setRowCount(len(sources))

    # Fill each row with source info
    for i, src in enumerate(sources):
        table.setItem(i, 0, QTableWidgetItem(src.get("name", "")))
        table.setItem(i, 1, QTableWidgetItem(src.get("type", "")))
        table.setItem(i, 2, QTableWidgetItem(src.get("country", "")))
        table.setItem(i, 3, QTableWidgetItem(src.get("url", "")))
        table.setItem(i, 4, QTableWidgetItem(str(src.get("enabled", True))))

        # Check if the URL is reachable
        try:
            r = requests.head(src.get("url", ""), timeout=5)
            status = "✅ Reachable" if r.status_code < 400 else f"⚠️ {r.status_code}"
        except Exception:
            status = "❌ Unreachable"
        table.setItem(i, 5, QTableWidgetItem(status))

    # Replace the output box with the table
    self.layout().removeWidget(self.output)
    self.output.hide()
    self.layout().addWidget(table)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = IPTVGui()
    window.show()
    sys.exit(app.exec())
