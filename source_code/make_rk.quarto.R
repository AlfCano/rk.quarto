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
      version = "0.0.1",
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

    echo('yaml_str <- yaml::as.yaml(qmd_meta)\\n');
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

  js_calc_journal <- paste0(js_sanitize_input, "
    var title = cleanStr(getValue('c3_title'));
    var abstract = cleanStr(getValue('c3_abstract'));
    var journal = getValue('c3_journal');
    var format = getValue('c3_format');

    // Construir la sintaxis de formato de Quarto (ej. apaquarto-pdf)
    var final_format = journal + '-' + format;

    echo('j_meta <- list()\\n');
    echo('j_meta$title <- \\'' + title + '\\'\\n');
    if (abstract != '') echo('j_meta$abstract <- \\'' + abstract + '\\'\\n');

    // Autoría estándar básica para Quarto 1.2+
    echo('j_meta$author <- list(list(name = \"John Doe\", affiliations = list(list(name = \"University of Excellence\"))))\\n');

    echo('j_meta$format <- \\'' + final_format + '\\'\\n');
    echo('yaml_str <- yaml::as.yaml(j_meta)\\n');

    // Determinar el comando de terminal requerido
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
  # ASSEMBLE SKELETON (CORRECTED)
  # =========================================================================================
  # Ahora sí: El plugin principal va en los argumentos raíz, y SOLO los extras van en 'components'
  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dialog_qmd),
    js = list(require = c("yaml"), calculate = js_calc_qmd, printout = js_print_qmd),
    rkh = list(help = help_qmd),
    components = list(comp_snip, comp_journal), # <--- AQUÍ SOLO ESTÁN EL 2 Y EL 3
    pluginmap = list(name = "1. Document Builder", hierarchy = common_hierarchy),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  # -----------------------------------------------------------------------------------------
  # TRANSLATION GENERATOR
  # -----------------------------------------------------------------------------------------
  tryCatch({
    rk.updatePluginMessages("rk.quarto", c("es", "de", "fr", "pt_BR"))
    cat("\nSUCCESS: Translation (.po) files generated.\n")
  }, error = function(e) {
    message("\nWARNING: Could not extract .po files automatically.")
  })

  cat("\nQuarto Plugin Suite (3 Components) successfully generated and corrected.\n")
})
