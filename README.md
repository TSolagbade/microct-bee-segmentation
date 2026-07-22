# Micro-CT Bee Scan Processing & Air Baseline Analysis

MATLAB scripts for processing and analyzing 1,385 high-resolution micro-CT scan slices of insect morphology (*Apis mellifera*).

---

> [!NOTE]
> ### 🐝 Key Analytical Discovery
> * **Automated Rendering:** Built a MATLAB pipeline to process and render 1,385 micro-CT slices of insect morphology using `jet(256)` colormaps.
> * **Histogram Analysis:** Investigated a recurring intensity peak at **8701.85** across Z-dimension slices to evaluate scanner consistency.
> * **Artifact Reclassification:** Disproved an initial artifact hypothesis by mapping the intensity to the non-attenuating top air layer, proving scanner detector stability across the entire volume stack.

---

## 📂 Repository Scripts

* **`generate_bee_video.m`**
  Renders slice sequences into an accelerated MPEG-4 video in 256-level Jet colormap (`jet(256)`). Includes step-size downsampling (`step_size = 5`) to optimize processing time by 80% while retaining structural detail, along with an early run-time profiler.

* **`analyze_air_baseline.m`**
  Performs Z-dimension histogram profiling to track the spatial distribution and pixel count of the **8701.85** intensity value across all 1,385 slices, confirming air attenuation baseline consistency across the scan stack.

---

## 🛠️ Usage

1. Open either script in **MATLAB (R2022b or later)**.
2. Update the dataset directory paths (`input_folder` and `output_folder`) to point to your data.
3. Press `F5` or `Ctrl + Enter` to execute.
