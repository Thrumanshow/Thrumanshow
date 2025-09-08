---

### 4. **scripts/generate_pdf.py**
```python
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import cm
import os

# Definir rutas
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.join(BASE_DIR, "../data/cv_resumido.txt")
OUTPUT_FILE = os.path.join(BASE_DIR, "../output/cv_cristhiam_quinonez.pdf")

# Crear carpeta de salida si no existe
os.makedirs(os.path.join(BASE_DIR, "../output"), exist_ok=True)

# Leer el CV resumido
with open(DATA_FILE, "r", encoding="utf-8") as f:
    cv_text = f.readlines()

# Crear PDF
c = canvas.Canvas(OUTPUT_FILE, pagesize=A4)
width, height = A4

c.setFont("Helvetica", 11)
x, y = 2*cm, height - 2*cm

for line in cv_text:
    if y < 2*cm:  # salto de página
        c.showPage()
        c.setFont("Helvetica", 11)
        y = height - 2*cm
    c.drawString(x, y, line.strip())
    y -= 14  # interlineado

c.save()

print(f"✅ PDF generado: {OUTPUT_FILE}")