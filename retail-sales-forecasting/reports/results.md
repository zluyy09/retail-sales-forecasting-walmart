# Interview Story (STAR/CAR)

**Context**: Multi‑store, multi‑dept weekly forecasting with holidays, markdowns, and macro factors. Stakeholders: merchandising, supply chain, store ops, finance.

**Task**: Improve peak‑season service level while controlling inventory and labor costs.

**Actions**:
- Built a deep EDA to quantify holiday and markdown effects; created lag/lead features and rolling stats.
- Implemented time‑aware cross‑validation and compared SARIMAX, Prophet, and a global GBM.
- Focused evaluation on holiday weeks and tail stores; added robust loss and anomaly handling.
- Translated model outputs to **order quantities** and **promo ROI** scenarios for planners.

**Results** (example placeholders):
- WAPE ↓ from 19.8% → 12.3% overall; holiday-week WAPE ↓ 10 pts.
- Stockouts during Thanksgiving‑XMAS period ↓ 18% with safety stock tuning.
- Identified low‑ROI markdowns in Dept 72; reallocated to high‑elasticity items, +4.2% margin.
