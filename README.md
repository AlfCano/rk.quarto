# rk.quarto

> **Quarto Document Generation Suite for RKWard**

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![RKWard](https://img.shields.io/badge/Platform-RKWard-green)
[![R Linter](https://github.com/AlfCano/rk.quarto/actions/workflows/lintr.yml/badge.svg)](https://github.com/AlfCano/rk.quarto/actions/workflows/lintr.yml)
![AI Gemini](https://img.shields.io/badge/AI-Gemini-4285F4?logo=googlegemini&logoColor=white)

**rk.quarto** is an RKWard plugin that provides a graphical interface for generating boilerplates, YAML headers, and syntax snippets for [Quarto](https://quarto.org/) (`.qmd`) documents. It allows users to easily set up complex metadata, insert native Quarto features (like callouts and multi-column layouts), and configure academic journal extensions without needing to memorize syntax rules.

## What's New in Version 0.0.1

**🚀 Initial Release: The Quarto Suite**

*   **Standard Document Builder:** A robust GUI to generate error-free YAML headers supporting HTML (with native Bootswatch themes), PDF, and Word formats.
*   **Modern Chunk Syntax:** Fully adopts the Quarto Hash-pipe (`#|`) chunk options rather than legacy RMarkdown chunk headers.
*   **Native Cheat Sheet:** Quickly generate syntax for Quarto-exclusive features like `callouts`, `panel-tabsets`, HTML columns, and automated cross-referencing.
*   **Journal Extensions Support:** Integrated support for academic writing without relying on heavy R packages. Generates boilerplates for APA 7th Edition, Elsevier, IEEE, and PLOS using the official Quarto Journal formats.

## Features

*   **GUI-Driven YAML Generation**: Configure complex nested YAML metadata (formats, tables of contents, section numbering) with simple checkboxes and dropdowns.
*   **One-Click Themes**: Instantly apply professional Bootswatch themes for HTML outputs (Cosmo, Flatly, Darkly, Sketchy, Journal).
*   **Quarto Syntax Helpers**: 
    *   **Chunks**: Insert pre-configured R chunks with cross-reference labels (`@fig-label`).
    *   **Layouts**: Generate Quarto HTML `:::` div containers for notes, tabs, and columns.
*   **Academic Ready**: Bypass LaTeX headaches by using Quarto's native extension system for academic journals.
*   **Terminal Helpers**: Automatically generates the exact `quarto add` or `quarto use template` CLI commands you need to paste into your terminal for journal templates to work.
    
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

---

## Requirements

*   **RKWard**: 0.7.5 or higher.
*   **System**: [Quarto CLI](https://quarto.org/docs/get-started/) must be installed on your computer.
*   **R Packages**:
    *   `yaml`

## Author

**Alfonso Cano Robles**
*   Email: alfonso.cano@correo.buap.mx

Assisted by Gemini, a large language model from Google.

## License

This project is licensed under the **GPL (>= 3)**.
