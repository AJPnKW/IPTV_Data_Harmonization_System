# IPTV Harmonization System — Windows GUI Control Panel
# Requires: Python 3.10+, PyQt6, requests, pyyaml

import sys
import subprocess
import os
import json
import yaml
import requests
from glob import glob
from PyQt6.QtWidgets import (
    QApplication, QWidget, QPushButton, QVBoxLayout, QLabel, QTextEdit, QMessageBox,
    QTableWidget, QTableWidgetItem, QHeaderView
)
from PyQt6.QtCore import Qt

class IPTVGui(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("IPTV Harmonization System")
        self.setGeometry(300, 300, 900, 600)

        self.output = QTextEdit()
        self.output.setReadOnly(True)
        self.output.setStyleSheet("background-color: #1e1e1e; color: #d4d4d4; font-family: Consolas;")

        layout = QVBoxLayout()
        layout.addWidget(QLabel("📺 Select a module or panel:"))

        layout.addWidget(self.make_button("📦 Source Manager", self.show_source_manager))
        layout.addWidget(self.make_button("🧩 Mapping Dashboard", self.show_mapping_dashboard))
        layout.addWidget(self.make_button("🛠️ Rule Editor", self.show_rule_editor))
        layout.addWidget(self.make_button("🔍 Preview Panel", self.show_preview_panel))
        layout.addWidget(self.make_button("📜 Run History", self.show_run_history))
        layout.addWidget(self.make_button("🔐 Environment Validator", self.show_env_validator))

        layout.addWidget(QLabel("⚙️ Run Pipeline Modules:"))
        modules = {
            "Fetch Sources": "scripts/fetch_sources.ps1",
            "Normalize": "scripts/Normalize-And-Resolve.ps1",
            "Transform": "scripts/Transform-Canonical.ps1",
            "Reconcile": "scripts/Reconcile-And-Match.ps1",
            "Generate Outputs": "scripts/Generate-Outputs.ps1",
            "Enrich Metadata": "scripts/Enrich-Metadata.ps1"
        }
        for label, script in modules.items():
            layout.addWidget(self.make_button(label, lambda _, s=script: self.run_script(s)))

        layout.addWidget(QLabel("📝 Output:"))
        layout.addWidget(self.output)
        self.setLayout(layout)

    def make_button(self, label, action):
        btn = QPushButton(label)
        btn.clicked.connect(action)
        return btn

    def run_script(self, script_path):
        self.output.clear()
        try:
            result = subprocess.run(
                ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
                capture_output=True, text=True, timeout=300
            )
            self.output.setPlainText(result.stdout + "\n" + result.stderr)
            if result.returncode != 0:
                QMessageBox.warning(self, "Script Error", f"Script failed:\n{result.stderr}")
        except Exception as e:
            QMessageBox.critical(self, "Execution Error", str(e))
    def show_source_manager(self):
        try:
            with open("config/sources.yaml", "r", encoding="utf-8") as f:
                data = yaml.safe_load(f)
                sources = data.get("sources", [])
        except Exception as e:
            QMessageBox.critical(self, "YAML Error", f"Failed to load sources.yaml:\n{e}")
            return

        table = QTableWidget()
        table.setColumnCount(6)
        table.setHorizontalHeaderLabels(["Name", "Type", "Country", "URL", "Enabled", "Status"])
        table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        table.setRowCount(len(sources))

        for i, src in enumerate(sources):
            table.setItem(i, 0, QTableWidgetItem(src.get("name", "")))
            table.setItem(i, 1, QTableWidgetItem(src.get("type", "")))
            table.setItem(i, 2, QTableWidgetItem(src.get("country", "")))
            table.setItem(i, 3, QTableWidgetItem(src.get("url", "")))
            table.setItem(i, 4, QTableWidgetItem(str(src.get("enabled", True))))
            try:
                r = requests.head(src.get("url", ""), timeout=5)
                status = "✅ Reachable" if r.status_code < 400 else f"⚠️ {r.status_code}"
            except Exception:
                status = "❌ Unreachable"
            table.setItem(i, 5, QTableWidgetItem(status))

        self.layout().removeWidget(self.output)
        self.output.hide()
        self.layout().addWidget(table)

    def show_mapping_dashboard(self):
        folder = "data/normalized"
        files = glob(os.path.join(folder, "*.json"))
        rows = []

        for file in files:
            try:
                with open(file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    for entry in data:
                        name = entry.get("name", "")
                        resolved = entry.get("canonical_id", "")
                        if not resolved:
                            rows.append((os.path.basename(file), name, "❌ Unresolved"))
            except Exception as e:
                rows.append((os.path.basename(file), "Error loading file", str(e)))

        if not rows:
            QMessageBox.information(self, "All Resolved", "No unresolved aliases found.")
            return

        table = QTableWidget()
        table.setColumnCount(3)
        table.setHorizontalHeaderLabels(["File", "Channel Name", "Status"])
        table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        table.setRowCount(len(rows))

        for i, (file, name, status) in enumerate(rows):
            table.setItem(i, 0, QTableWidgetItem(file))
            table.setItem(i, 1, QTableWidgetItem(name))
            table.setItem(i, 2, QTableWidgetItem(status))

        self.layout().removeWidget(self.output)
        self.output.hide()
        self.layout().addWidget(table)

    def show_rule_editor(self):
        try:
            with open("config/rules.yaml", "r", encoding="utf-8") as f:
                rules = yaml.safe_load(f)
        except Exception as e:
            QMessageBox.critical(self, "YAML Error", f"Failed to load rules.yaml:\n{e}")
            return

        text = "📋 Rename Rules:\n"
        for r in rules.get("rename", []):
            text += f"• {r.get('match')} → {r.get('replace')}\n"

        text += "\n📂 Group Rules:\n"
        for r in rules.get("group", []):
            text += f"• {r.get('match')} → {r.get('assign')}\n"

        text += "\n🚫 Filter Rules:\n"
        for r in rules.get("filter", []):
            text += f"• Exclude: {r}\n"

        text += "\n🖼️ Logo Rules:\n"
        for r in rules.get("logo", []):
            text += f"• {r.get('match')} → {r.get('url')}\n"

        self.output.setPlainText(text)
    def show_preview_panel(self):
        m3uPath = "data/transformed/transformed_m3u.json"
        epgPath = "data/transformed/transformed_epg.json"
        text = ""

        if os.path.exists(m3uPath):
            with open(m3uPath, "r", encoding="utf-8") as f:
                channels = json.load(f)
                text += "📺 Transformed M3U Channels:\n"
                for c in channels[:5]:
                    text += f"• {c.get('name')} [{c.get('group')}] → {c.get('url')}\n"
        else:
            text += "❌ M3U file not found\n"

        if os.path.exists(epgPath):
            with open(epgPath, "r", encoding="utf-8") as f:
                epg = json.load(f)
                text += "\n🗓️ EPG Program Schedule:\n"
                for p in epg[0].get("programs", [])[:3]:
                    text += f"• {p.get('title')}: {p.get('start')} → {p.get('end')}\n"
        else:
            text += "\n❌ EPG file not found\n"

        self.output.setPlainText(text)

    def show_run_history(self):
        folder = "logs"
        files = sorted(glob(os.path.join(folder, "run_*.log")), reverse=True)
        text = "📜 Run History:\n"

        if not files:
            text += "No logs found.\n"
        else:
            for file in files[:5]:
                try:
                    with open(file, "r", encoding="utf-8") as f:
                        lines = f.readlines()
                        timestamp = os.path.basename(file).replace("run_", "").replace(".log", "")
                        status = "✅ Success" if any("completed" in line.lower() for line in lines) else "⚠️ Check log"
                        text += f"• {timestamp}: {status}\n"
                except Exception:
                    text += f"• {file}: ❌ Error reading log\n"

        self.output.setPlainText(text)

    def show_env_validator(self):
        required_vars = [
            "TMDB_API_KEY",
            "EPG_SOURCE_TOKEN",
            "M3U_SOURCE_TOKEN"
        ]
        text = "🔐 Environment Validator:\n"

        for var in required_vars:
            value = os.environ.get(var)
            if value:
                text += f"• {var}: ✅ Present\n"
            else:
                text += f"• {var}: ❌ Missing\n"

        self.output.setPlainText(text)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = IPTVGui()
    window.show()
    sys.exit(app.exec())
