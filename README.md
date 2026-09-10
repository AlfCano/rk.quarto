# rk.quarto

> **Quarto Document Generation Suite for RKWard**

![Version](https://img.shields.io/badge/Version-0.0.5-blue.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![RKWard](https://img.shields.io/badge/Platform-RKWard-green)
[![R Linter](https://github.com/AlfCano/rk.quarto/actions/workflows/lintr.yml/badge.svg)](https://github.com/AlfCano/rk.quarto/actions/workflows/lintr.yml)
![AI Gemini](https://img.shields.io/badge/AI-Gemini-4285F4?logo=googlegemini&logoColor=white)

**rk.quarto** is an RKWard plugin that provides a graphical interface for generating boilerplates, YAML headers, and syntax snippets for [Quarto](https://quarto.org/) (`.qmd`) documents. It allows users to easily set up complex metadata, insert native Quarto features (like callouts and multi-column layouts), and configure academic journal extensions without needing to memorize syntax rules.


## Features

*   **GUI-Driven YAML Generation**: Configure complex nested YAML metadata (formats, tables of contents, section numbering) with simple checkboxes and dropdowns.
*   **One-Click Themes**: Instantly apply professional Bootswatch themes for HTML outputs (Cosmo, Flatly, Darkly, Sketchy, Journal).
*   **Quarto Syntax Helpers**: 
    *   **Chunks**: Insert pre-configured R chunks with cross-reference labels (`@fig-label`).
    *   **Layouts**: Generate Quarto HTML `:::` div containers for notes, tabs, and columns.
*   **Academic Ready**: Bypass LaTeX headaches by using Quarto's native extension system for academic journals.
*   **Terminal Helpers**: Automatically generates the exact `quarto add` or `quarto use template` CLI commands you need to paste into your terminal for journal templates to work.
*   **Seamless Rendering**: Compile your documents locally via the new Exporter tool, which includes real-time path calculations and supports over 10 Quarto output formats (including eBooks and presentations).
*   **Smart Save**: Leave the "Save as" field blank, and the plugin will automatically calculate the correct output path and file extension (e.g., swapping `.qmd` to `.docx`) in the same directory as your source file. Alternatively, define a custom path to overwrite this behavior.

## What's New in Version 0.0.5

**⚙️ Strict YAML 1.2 Compliance & Boilerplate Polish**

*   **Native Strict Booleans:** Completely overhauled the YAML generation engine across the plugin (Document Builder and Journal Templates). Bypassed R's default behavior of converting logicals to `"yes"/"no"`, using custom handlers to strictly enforce Quarto's required `"true"/"false"` (YAML 1.2 standards). This permanently eliminates the `Validation of YAML front matter failed` crash when toggling features like Tables of Contents or Numbered Sections.
*   **Future-Proofed Journal Templates:** Upgraded the Academic Journal component to inherit the strict YAML 1.2 handlers. This ensures that complex extensions (like APA 7th Edition or Elsevier formats) will compile flawlessly, and paves the way for safely adding new boolean parameters to journal templates in future updates.

## What's New in Version 0.0.4

**🚀 Cross-Platform Stability & Smart Rendering**

*   **Cross-Platform Auto-Detection:** RKWard GUI environments often fail to inherit system `$PATH` variables, causing "Quarto not found" errors. The plugin now features a robust auto-detection engine that actively hunts down the Quarto CLI across standard Linux, macOS, and Windows installation paths.
*   **Smart Export Routing:** Bypassed Quarto's strict "paths are not allowed" restriction for output files. The plugin now safely renders documents in their native directories and uses native R file operations to seamlessly move the final export to your desired destination.
*   **Strict YAML 1.2 Compliance:** Fixed a rendering crash by ensuring that generated booleans (like `toc: true`) strictly follow Quarto's modern YAML 1.2 standards, moving away from legacy R Markdown syntax (`yes`/`no`).
*   **Advanced Compilation Controls:** Added a new "Advanced Options" menu. Users can now toggle **Quiet Mode** to show or hide the detailed Quarto compilation log directly in the RKWard console (perfect for debugging broken documents), and manually override the Quarto CLI path if using custom installations.


## What's New in Version 0.0.3

**🧼 Clean Code Generation & 🛡️ Bulletproof Exporting**
*   **Native RKWard Integration**: Completely refactored the JavaScript generation engine. The plugin now perfectly hooks into RKWard's native step-by-step execution (`## Prepare`, `## Compute`) and dependency management, eliminating duplicated `require()` calls and redundant headers.
*   **Stable Exporter Logic**: Redesigned the "Save as" mechanism in the Render tool. Instead of forcing fragile GUI logic, the plugin now safely delegates directory pathing and auto-extension calculations directly to the Quarto engine and the RKWard output window, ensuring 100% stability without crashes.

## What's New in Version 0.0.2

**📦 New Component: The Quarto Renderer (Exporter)**
*   **GUI-Driven Compilation:** You can now compile your `.qmd` files into their final formats (Word, PDF, HTML, RevealJS, PowerPoint, etc.) directly from the RKWard interface without typing `quarto render` in the console.
*   **Smart Auto-fill UX:** When you select a source `.qmd` file and pick a target format from the dropdown, the plugin's interface reacts instantly, auto-calculating the destination path and swapping the extension (e.g., `.qmd` to `.docx`) in real-time.

## What's New in Version 0.0.1

**🚀 Initial Release: The Quarto Suite**

*   **Standard Document Builder:** A robust GUI to generate error-free YAML headers supporting HTML (with native Bootswatch themes), PDF, and Word formats.
*   **Modern Chunk Syntax:** Fully adopts the Quarto Hash-pipe (`#|`) chunk options rather than legacy RMarkdown chunk headers.
*   **Native Cheat Sheet:** Quickly generate syntax for Quarto-exclusive features like `callouts`, `panel-tabsets`, HTML columns, and automated cross-referencing.
*   **Journal Extensions Support:** Integrated support for academic writing without relying on heavy R packages. Generates boilerplates for APA 7th Edition, Elsevier, IEEE, and PLOS using the official Quarto Journal formats.

    
## 🌍 Internationalization

The interface is fully localized to match your RKWard language settings:

*   🇺🇸 **English** (Default)
*   🇪🇸 **Spanish** (`es`)
*   🇫🇷 **French** (`fr`)
*   🇩🇪 **German** (`de`)
*   🇧🇷 **Portuguese** (Brazil) (`pt_BR`)    

## Installation

You can install this plugin directly from GitHub using `remotes` within RKWard:

```r
require(remotes)
install_github("AlfCano/rk.quarto")
```


Once installed, restart RKWard to ensure the new menu items appear correctly.

## Usage

The plugin is located in the main menu under:
**File -> Quarto Generators**

It consists of three main tools:

### 1. Document Builder
Use this tool to generate a standard Quarto document header. The interface is divided into two main areas:

*   **Metadata**: Define the core details of your document (Title, Author, and dynamic Date).
*   **Format & Options**: 
    *   Select your primary export format (HTML, PDF, or Word).
    *   Apply visual themes (if HTML is selected).
    *   Toggle global settings like Table of Contents (`toc: true`) and section numbering (`number-sections: true`).

### 2. Quarto Cheat Sheet
Use this tool as an integrated reference guide to inject modern Quarto syntax directly into your script.
*   **Chunks & Code**: Generate R chunks using the modern Hash-pipe (`#|`) options for figures, tables, and hidden code.
*   **Cross-References**: Learn how to automatically link text to figures using `@fig-label`.
*   **Layouts**: Instantly generate the syntax for `callout` boxes, interactive HTML `tabsets`, and multi-column document designs.

### 3. Journal Templates
Use this tool to write academic papers using official Quarto extensions.
*   **Metadata**: Input your manuscript title, abstract, and formatting preferences.
*   **Journal Selection**: Choose between APA 7th Edition (`apaquarto`), Elsevier, IEEE, or PLOS formats.
*   **CLI Instructions**: The plugin will generate the YAML header *and* provide you with the exact terminal command required to download the journal template to your local machine.

### 4. Render Document (Exporter)
Use this tool to compile an existing `.qmd` file into its final document format.
*   **Input**: Browse and select your Quarto source file.
*   **Format**: Choose from an extensive list of targets (HTML, PDF, Word, RevealJS, PowerPoint, Markdown, ODT, ePub, etc.).
*   **Smart Save**: The plugin will automatically calculate the output path and extension based on your format selection. You can leave it as is, or edit it to save the output in a custom directory.

---

## Requirements

*   **RKWard**: 0.7.5 or higher.
*   **System**: [Quarto CLI](https://quarto.org/docs/get-started/) must be installed on your computer.
*   **R Packages**:
    *   `yaml`
    *   `quarto` (Required for the Render Document tool)

## Author

**Alfonso Cano Robles**
*   Email: alfonso.cano@correo.buap.mx

Assisted by Gemini, a large language model from Google.

## License

This project is licensed under the **GPL (>= 3)**.
