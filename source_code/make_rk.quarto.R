local({
  # =========================================================================================
  # 0. Metadata and Setup
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.10-3")

  package_about <- rk.XML.about(
    name = "rk.quarto",
    author = person(
      given = "Alfonso",
      family = "Cano Robles",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "RKWard Plugin Suite for Quarto Document generation.",
      version = "0.0.5",
      url = "https://github.com/AlfCano/rk.quarto",
      license = "GPL (>= 3)"
    )
  )

  common_hierarchy <- list("file", "Quarto Generators")

  js_sanitize_input <- "
    function cleanStr(val) {
        if(!val) return '';
        return val.replace(/'/g, \"\\\\'\").replace(/\"/g, '\\\\\"').replace(/\\n/g, '\\\\n');
    }
  "

  # =========================================================================================
  # MAIN PLUGIN (1): Quarto Document Builder (Standard)
  # =========================================================================================
  help_qmd <- rk.rkh.doc(title = rk.rkh.title("1. Quarto Document Builder"), summary = rk.rkh.summary("Generates a Quarto (.qmd) YAML header."))

  q1_title  <- rk.XML.input("Document Title", initial = "Análisis en Quarto", required = TRUE, id.name = "q1_title")
  q1_author <- rk.XML.input("Author Name(s)", initial = "Jane Doe", required = FALSE, id.name = "q1_author")
  q1_date   <- rk.XML.cbox("Use Current Date", value = "TRUE", chk = TRUE, id.name = "q1_date")

  q1_format <- rk.XML.dropdown("Output Format", options = list("HTML Document" = list(val = "html", chk = TRUE), "PDF Document" = list(val = "pdf"), "Word Document" = list(val = "docx")), id.name = "q1_format")
  q1_theme  <- rk.XML.dropdown("HTML Theme (HTML only)", options = list("Default (Cosmo)" = list(val = "default", chk = TRUE), "Flatly" = list(val = "flatly"), "Darkly" = list(val = "darkly"), "Journal" = list(val = "journal")), id.name = "q1_theme")

  q1_toc    <- rk.XML.cbox("Include Table of Contents", value = "TRUE", chk = TRUE, id.name = "q1_toc")
  q1_number <- rk.XML.cbox("Number Sections", value = "TRUE", chk = FALSE, id.name = "q1_number")

  tab_q1_meta <- rk.XML.col(q1_title, q1_author, q1_date)
  tab_q1_opts <- rk.XML.col(rk.XML.frame(q1_format, label="Export Format"), rk.XML.frame(q1_theme, q1_toc, q1_number, label="Options"))

  dialog_qmd <- rk.XML.dialog(label = "1. Document Builder", child = rk.XML.tabbook(tabs = list("Metadata" = tab_q1_meta, "Format" = tab_q1_opts)))

  js_calc_qmd <- paste0(js_sanitize_input, "
    var title = cleanStr(getValue('q1_title')); var author = cleanStr(getValue('q1_author'));
    var format = getValue('q1_format'); var theme = getValue('q1_theme');
    var hasTOC = getValue('q1_toc') == 'TRUE'; var hasNum = getValue('q1_number') == 'TRUE'; var doDate = getValue('q1_date') == 'TRUE';

    echo('qmd_meta <- list()\\n');
    echo('qmd_meta$title <- \\'' + title + '\\'\\n');
    if (author != '') echo('qmd_meta$author <- \\'' + author + '\\'\\n');
    if (doDate) echo('qmd_meta$date <- format(Sys.Date(), \\'%Y-%m-%d\\')\\n');

    echo('fmt_opts <- list()\\n');
    if (hasTOC) echo('fmt_opts$toc <- TRUE\\n');
    if (hasNum) echo('fmt_opts[[\\'number-sections\\']] <- TRUE\\n');
    if (format == 'html' && theme != 'default') echo('fmt_opts$theme <- \\'' + theme + '\\'\\n');

    echo('qmd_meta$format <- list()\\n');
    echo('if(length(fmt_opts) > 0) { qmd_meta$format[[\\'' + format + '\\']] <- fmt_opts } else { qmd_meta$format <- \\'' + format + '\\' }\\n');

    // FIX FOR QUARTO STRICT BOOLEANS: Force 'true'/'false' instead of 'yes'/'no'
    echo('custom_handlers <- list(logical = function(x) { res <- ifelse(x, \"true\", \"false\"); class(res) <- \"verbatim\"; return(res) })\\n');
    echo('yaml_str <- yaml::as.yaml(qmd_meta, handlers = custom_handlers)\\n');

    echo('full_qmd <- paste0(\"---\\\\n\", yaml_str, \"---\\\\n\\\\n## Introducción\\\\n\")\\n');
  ")

  js_print_qmd <- "
    echo('rk.header(\"Generated Quarto Boilerplate\", level=2)\\n');
    echo('cat(\"\\\\n============================================================\\\\n\")\\n');
    echo('cat(full_qmd)\\n');
    echo('cat(\"============================================================\\\\n\\\\n\")\\n');
  "

  # =========================================================================================
  # SUB-COMPONENT (2): Quarto Cheat Sheet Snippets
  # =========================================================================================
  help_snip <- rk.rkh.doc(title = rk.rkh.title("2. Quarto Cheat Sheet"), summary = rk.rkh.summary("Native Quarto elements."))

  c2_type <- rk.XML.dropdown("Select Quarto element to generate:", options = list(
    "[Code] Basic R Chunk"              = list(val = "chunk_basic", chk = TRUE),
    "[Code] Plot & Cross-reference"     = list(val = "chunk_plot_ref"),
    "[Layout] Callouts (Notes)"         = list(val = "lay_callout"),
    "[Layout] Tabsets (HTML Tabs)"      = list(val = "lay_tabs"),
    "[Layout] Multiple Columns"         = list(val = "lay_cols")
  ), id.name = "c2_type")

  dialog_snip <- rk.XML.dialog(label = "2. Quarto Cheat Sheet", child = rk.XML.col(rk.XML.text("Generates syntax for Quarto features."), c2_type, rk.XML.stretch()))

  js_calc_snip <- "
    var type = getValue('c2_type');
    echo('snippet <- c(\\n');
    if (type == 'chunk_basic') {
      echo('  \"```{r}\",\\n  \"#| label: basic-code\",\\n  \"\",\\n  \"summary(cars)\",\\n  \"```\"\\n');
    } else if (type == 'chunk_plot_ref') {
      echo('  \"```{r}\",\\n  \"#| label: fig-cars\",\\n  \"#| fig-cap: \\'This is a plot of the cars dataset.\\'\",\\n  \"\",\\n  \"plot(cars)\",\\n  \"```\",\\n  \"\",\\n  \"As seen in @fig-cars.\"\\n');
    } else if (type == 'lay_callout') {
      echo('  \"::: {.callout-note}\",\\n  \"This is a note callout.\",\\n  \":::\"\\n');
    } else if (type == 'lay_tabs') {
      echo('  \"::: {.panel-tabset}\",\\n  \"## Data\",\\n  \"Data here\",\\n  \"## Plot\",\\n  \"Plot here\",\\n  \":::\"\\n');
    } else if (type == 'lay_cols') {
      echo('  \"::: {.columns}\",\\n  \"::: {.column width=\\'50%\\'}\",\\n  \"Left\",\\n  \":::\",\\n  \"::: {.column width=\\'50%\\'}\",\\n  \"Right\",\\n  \":::\",\\n  \":::\"\\n');
    }
    echo(')\\n');
  "

  js_print_snip <- "
    echo('rk.header(\"Quarto Snippet\", level=2)\\n');
    echo('cat(paste(snippet, collapse=\"\\\\n\"))\\n');
  "

  comp_snip <- rk.plugin.component("2. Quarto Cheat Sheet", xml = list(dialog = dialog_snip), js = list(calculate = js_calc_snip, printout = js_print_snip), hierarchy = common_hierarchy, rkh = list(help = help_snip))

  # =========================================================================================
  # SUB-COMPONENT (3): Quarto Journal Templates
  # =========================================================================================
  help_journal <- rk.rkh.doc(title = rk.rkh.title("3. Journal Templates"), summary = rk.rkh.summary("Boilerplates for academic journals in Quarto."))

  c3_title    <- rk.XML.input("Manuscript Title", initial = "Academic Paper Title", required = TRUE, id.name = "c3_title")
  c3_abstract <- rk.XML.input("Abstract (Optional)", initial = "Enter abstract...", size = "large", id.name = "c3_abstract")

  c3_journal <- rk.XML.dropdown("Academic Journal Extension", options = list(
    "APA 7th Edition (apaquarto)" = list(val = "apaquarto", chk = TRUE),
    "Elsevier (quarto-journals)"  = list(val = "elsevier"),
    "IEEE (quarto-journals)"      = list(val = "ieee"),
    "PLOS (quarto-journals)"      = list(val = "plos")
  ), id.name = "c3_journal")

  c3_format <- rk.XML.dropdown("Output Document Type", options = list(
    "PDF (Recommended)" = list(val = "pdf", chk = TRUE),
    "Word Document (.docx)" = list(val = "docx"),
    "HTML Document" = list(val = "html")
  ), id.name = "c3_format")

  dialog_journal <- rk.XML.dialog(label = "3. Journal Templates", child = rk.XML.col(rk.XML.text("Note: Quarto Journals require extensions installed via Terminal."), c3_title, c3_abstract, c3_journal, c3_format))

  # -----------------------------------------------------------------------------------------
  # R CODE GENERATION LOGIC (For COMPONENT 3: Journal Templates)
  # -----------------------------------------------------------------------------------------
  js_calc_journal <- paste0(js_sanitize_input, "
    var title = cleanStr(getValue('c3_title'));
    var abstract = cleanStr(getValue('c3_abstract'));
    var journal = getValue('c3_journal');
    var format = getValue('c3_format');

    // Build the Quarto format syntax (e.g., apaquarto-pdf)
    var final_format = journal + '-' + format;

    echo('j_meta <- list()\\n');
    echo('j_meta$title <- \\'' + title + '\\'\\n');
    if (abstract != '') echo('j_meta$abstract <- \\'' + abstract + '\\'\\n');

    // Standard authorship for Quarto 1.2+
    echo('j_meta$author <- list(list(name = \"John Doe\", affiliations = list(list(name = \"University of Excellence\"))))\\n');
    echo('j_meta$format <- \\'' + final_format + '\\'\\n');

    // FIX FOR QUARTO STRICT BOOLEANS: Apply the same handlers here just to be safe for future updates!
    echo('custom_handlers <- list(logical = function(x) { res <- ifelse(x, \"true\", \"false\"); class(res) <- \"verbatim\"; return(res) })\\n');
    echo('yaml_str <- yaml::as.yaml(j_meta, handlers = custom_handlers)\\n');

    // Determine the required terminal command
    echo('cli_cmd <- \"\"\\n');
    echo('if (\"' + journal + '\" == \"apaquarto\") { cli_cmd <- \"quarto add wviechtb/apaquarto\" } else { cli_cmd <- paste0(\"quarto use template quarto-journals/\", \"' + journal + '\") }\\n');

    echo('full_journal <- paste0(\"---\\\\n\", yaml_str, \"---\\\\n\\\\n## Introduction\\\\n\")\\n');
  ")

  js_print_journal <- "
    echo('rk.header(\"Quarto Journal Template\", level=2)\\n');
    echo('rk.print(\"<b>IMPORTANT:</b> Before rendering this document, open your terminal (in the folder where your .qmd file is) and run the following command to install the required Quarto extension:\")\\n');
    echo('cat(\"\\\\n> \", cli_cmd, \"\\\\n\\\\n\")\\n');
    echo('cat(\"============================================================\\\\n\")\\n');
    echo('cat(full_journal)\\n');
    echo('cat(\"============================================================\\\\n\\\\n\")\\n');
  "

  comp_journal <- rk.plugin.component("3. Journal Templates", xml = list(dialog = dialog_journal), js = list(require = c("yaml"), calculate = js_calc_journal, printout = js_print_journal), hierarchy = common_hierarchy, rkh = list(help = help_journal))

  # =========================================================================================
  # SUB-COMPONENT (4): Quarto Renderer (Exporter)
  # =========================================================================================
  help_render <- rk.rkh.doc(
    title = rk.rkh.title("4. Render Document"),
    summary = rk.rkh.summary("Compiles a Quarto (.qmd) file to its final format.")
  )

  c4_input <- rk.XML.browser("Quarto File (.qmd)", type = "file", required = TRUE, id.name = "c4_input")

  c4_format <- rk.XML.dropdown("Target Output Format", options = list(
    "The first format defined in the document" = list(val = "", chk = TRUE),
    "All formats defined in the document" = list(val = "all"),
    "HTML Document" = list(val = "html"),
    "PDF Document" = list(val = "pdf"),
    "Word Document (.docx)" = list(val = "docx"),
    "RevealJS Presentation (HTML)" = list(val = "revealjs"),
    "Beamer Presentation (PDF)" = list(val = "beamer"),
    "PowerPoint Presentation (.pptx)" = list(val = "pptx"),
    "ODT Document" = list(val = "odt"),
    "RTF Document" = list(val = "rtf"),
    "Markdown (GitHub Flavored)" = list(val = "gfm"),
    "MediaWiki" = list(val = "mediawiki"),
    "DokuWiki" = list(val = "dokuwiki"),
    "eBook (ePub)" = list(val = "epub")
  ), id.name = "c4_format")

  c4_output <- rk.XML.browser("Save as (Leave blank to use source directory and auto-extension)", type = "savefile", required = FALSE, id.name = "c4_output")

  # NEW CONTROL OPTIONS (Bug fix: Removed initial="" to prevent parsing error)
  c4_quiet <- rk.XML.cbox("Quiet mode (Hide compilation log)", value = "TRUE", chk = TRUE, id.name = "c4_quiet")
  c4_path <- rk.XML.input("Quarto CLI Path (Only if auto-detect fails, e.g., /usr/local/bin/quarto)", id.name = "c4_path")

  dialog_render <- rk.XML.dialog(label = "4. Export Quarto Document", child = rk.XML.col(
    rk.XML.text("Select a .qmd file to compile it into the final output format."),
    c4_input,
    c4_format,
    c4_output,
    rk.XML.frame(label="Advanced Options", child=rk.XML.col(c4_quiet, c4_path))
  ))

  # -----------------------------------------------------------------------------------------
  # R CODE GENERATION LOGIC
  # -----------------------------------------------------------------------------------------
  js_calc_render <- paste0(js_sanitize_input, "
    var input = cleanStr(getValue('c4_input'));
    var format = getValue('c4_format');
    var output = cleanStr(getValue('c4_output'));
    var custom_path = cleanStr(getValue('c4_path'));
    var is_quiet = getValue('c4_quiet'); // Read checkbox value

    // 1. PATH ERROR SOLUTION: Cross-platform Auto-detection in RKWard
    if (custom_path !== '') {
        echo('Sys.setenv(QUARTO_PATH = \\'' + custom_path + '\\')\\n');
    } else {
        echo('if (Sys.which(\"quarto\") == \"\" && Sys.getenv(\"QUARTO_PATH\") == \"\") {\\n');
        // Linux & macOS fallbacks
        echo('  if (file.exists(\"/usr/local/bin/quarto\")) Sys.setenv(QUARTO_PATH = \"/usr/local/bin/quarto\")\\n');
        echo('  else if (file.exists(\"/opt/quarto/bin/quarto\")) Sys.setenv(QUARTO_PATH = \"/opt/quarto/bin/quarto\")\\n');
        echo('  else if (file.exists(\"/Applications/quarto/bin/quarto\")) Sys.setenv(QUARTO_PATH = \"/Applications/quarto/bin/quarto\")\\n');
        // Windows fallbacks (.exe)
        echo('  else if (file.exists(\"C:/Program Files/Quarto/bin/quarto.exe\")) Sys.setenv(QUARTO_PATH = \"C:/Program Files/Quarto/bin/quarto.exe\")\\n');
        echo('  else if (file.exists(file.path(Sys.getenv(\"LOCALAPPDATA\"), \"Programs/Quarto/bin/quarto.exe\"))) Sys.setenv(QUARTO_PATH = file.path(Sys.getenv(\"LOCALAPPDATA\"), \"Programs/Quarto/bin/quarto.exe\"))\\n');
        echo('}\\n');
    }

    // 2. Prepare files (Avoids the 'paths are not allowed' error)
    echo('input_file <- \\'' + input + '\\'\\n');
    if (output !== '' && format !== 'all') {
        echo('output_target <- \\'' + output + '\\'\\n');
        echo('out_name <- basename(output_target)\\n');
    }

    // 3. Execute Quarto
    echo('quarto::quarto_render(\\n');
    echo('  input = input_file');

    if (format !== '') {
      echo(',\\n  output_format = \\'' + format + '\\'');
    }

    if (output !== '' && format !== 'all') {
      echo(',\\n  output_file = out_name');
    }

    // Use quiet mode based on user selection (TRUE or FALSE)
    echo(',\\n  quiet = ' + is_quiet + '\\n');
    echo(')\\n');

    // 4. Move the file to the user-defined destination path
    if (output !== '' && format !== 'all') {
        echo('generated_file <- file.path(dirname(input_file), out_name)\\n');
        echo('if (normalizePath(generated_file, mustWork=FALSE) != normalizePath(output_target, mustWork=FALSE)) {\\n');
        echo('  file.copy(from = generated_file, to = output_target, overwrite = TRUE)\\n');
        echo('  file.remove(generated_file)\\n');
        echo('}\\n');
    }
  ")

  js_print_render <- "
    var input = getValue('c4_input');
    var format = getValue('c4_format');
    var output = getValue('c4_output');

    var format_lbl = 'The first format defined in the document';
    var ext = '';

    if (format === 'all') { format_lbl = 'All formats defined in the document'; }
    else if (format === 'html' || format === 'revealjs') { format_lbl = format; ext = '.html'; }
    else if (format === 'pdf' || format === 'beamer') { format_lbl = format; ext = '.pdf'; }
    else if (format === 'docx') { format_lbl = 'Word'; ext = '.docx'; }
    else if (format === 'pptx') { format_lbl = 'PowerPoint'; ext = '.pptx'; }
    else if (format === 'odt') { format_lbl = 'ODT'; ext = '.odt'; }
    else if (format === 'rtf') { format_lbl = 'RTF'; ext = '.rtf'; }
    else if (format === 'gfm') { format_lbl = 'Markdown (GitHub)'; ext = '.md'; }
    else if (format === 'epub') { format_lbl = 'ePub'; ext = '.epub'; }
    else if (format !== '') { format_lbl = format; }

    var final_output = output;
    if (output === '') {
       if (ext !== '') {
           final_output = input.replace(/\\\\.[^/.]+$/, \"\") + ext;
       } else {
           final_output = \"Same directory as original (.qmd)\";
       }
    }

    echo('rk.header(\"Export Quarto Document\", parameters = list(\\n');
    echo('  \"Quarto File\" = \\'' + input + '\\',\\n');
    echo('  \"Target Format\" = \\'' + format_lbl + '\\',\\n');
    echo('  \"Save as\" = \\'' + final_output + '\\'\\n');
    echo('))\\n');
  "

  comp_render <- rk.plugin.component(
    "4. Render Document",
    xml = list(dialog = dialog_render),
    js = list(require = c("quarto"), calculate = js_calc_render, printout = js_print_render),
    hierarchy = common_hierarchy,
    rkh = list(help = help_render)
  )

  # =========================================================================================
  # ASSEMBLE SKELETON
  # =========================================================================================

    rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dialog_qmd),
    js = list(require = c("yaml"), calculate = js_calc_qmd, printout = js_print_qmd),
    rkh = list(help = help_qmd),
    components = list(comp_snip, comp_journal, comp_render),
    pluginmap = list(name = "1. Document Builder", hierarchy = common_hierarchy),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nQuarto Plugin Suite (4 Components) successfully generated and corrected.\n")
})
