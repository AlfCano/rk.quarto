// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(yaml)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function cleanStr(val) {
        if(!val) return '';
        return val.replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, '\\n');
    }
  
    var title = cleanStr(getValue('c3_title'));
    var abstract = cleanStr(getValue('c3_abstract'));
    var keywords = cleanStr(getValue('c3_keywords'));
    var journal = getValue('c3_journal');
    var format = getValue('c3_format');
    var keeptex = getValue('c3_keeptex') == 'TRUE';
    var hasbib = getValue('c3_bib') == 'TRUE';

    // Build the Quarto format syntax (e.g., apaquarto-pdf)
    var final_format = journal + '-' + format;

    echo('j_meta <- list()\n');
    echo('j_meta$title <- \'' + title + '\'\n');
    if (abstract != '') echo('j_meta$abstract <- \'' + abstract + '\'\n');

    // Process comma-separated keywords into a YAML list
    if (keywords != '') {
        echo('j_meta$keywords <- trimws(unlist(strsplit("' + keywords + '", ",")))\n');
    }

    // Standard authorship for Quarto 1.2+
    echo('j_meta$author <- list(list(name = "John Doe", affiliations = list(list(name = "University of Excellence"))))\n');

    if (hasbib) echo('j_meta$bibliography <- "references.bib"\n');

    // Add format options (like keep-tex) dynamically
    echo('j_fmt_opts <- list()\n');
    if (keeptex && format == 'pdf') echo('j_fmt_opts[["keep-tex"]] <- TRUE\n');

    echo('j_meta$format <- list()\n');
    echo('if(length(j_fmt_opts) > 0) { j_meta$format[[\'' + final_format + '\']] <- j_fmt_opts } else { j_meta$format <- \'' + final_format + '\' }\n');

    // FIX FOR QUARTO STRICT BOOLEANS: Apply the handlers to guarantee YAML 1.2 compliance
    echo('custom_handlers <- list(logical = function(x) { res <- ifelse(x, "true", "false"); class(res) <- "verbatim"; return(res) })\n');
    echo('yaml_str <- yaml::as.yaml(j_meta, handlers = custom_handlers)\n');

    // Determine the required terminal command
    echo('cli_cmd <- ""\n');
    echo('if ("' + journal + '" == "apaquarto") { cli_cmd <- "quarto add wviechtb/apaquarto" } else { cli_cmd <- paste0("quarto use template quarto-journals/", "' + journal + '") }\n');

    echo('full_journal <- paste0("---\\n", yaml_str, "---\\n\\n## Introduction\\n")\n');
    if (hasbib) echo('full_journal <- paste0(full_journal, "\\n\\n## References\\n\\n::: {#refs}\\n:::\\n")\n');
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("3. Journal Templates results")).print();

    echo('rk.header("Quarto Journal Template", level=2)\n');
    echo('rk.print("<b>IMPORTANT:</b> Before rendering this document, open your terminal (in the folder where your .qmd file is) and run the following command to install the required Quarto extension:")\n');
    echo('cat("\\n> ", cli_cmd, "\\n\\n")\n');
    echo('cat("============================================================\\n")\n');
    echo('cat(full_journal)\n');
    echo('cat("============================================================\\n\\n")\n');
  

}

