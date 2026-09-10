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
  
    var title = cleanStr(getValue('q1_title')); var author = cleanStr(getValue('q1_author'));
    var format = getValue('q1_format'); var theme = getValue('q1_theme');
    var hasTOC = getValue('q1_toc') == 'TRUE'; var hasNum = getValue('q1_number') == 'TRUE'; var doDate = getValue('q1_date') == 'TRUE';

    echo('qmd_meta <- list()\n');
    echo('qmd_meta$title <- \'' + title + '\'\n');
    if (author != '') echo('qmd_meta$author <- \'' + author + '\'\n');
    if (doDate) echo('qmd_meta$date <- format(Sys.Date(), \'%Y-%m-%d\')\n');

    echo('fmt_opts <- list()\n');
    if (hasTOC) echo('fmt_opts$toc <- TRUE\n');
    if (hasNum) echo('fmt_opts[[\'number-sections\']] <- TRUE\n');
    if (format == 'html' && theme != 'default') echo('fmt_opts$theme <- \'' + theme + '\'\n');

    echo('qmd_meta$format <- list()\n');
    echo('if(length(fmt_opts) > 0) { qmd_meta$format[[\'' + format + '\']] <- fmt_opts } else { qmd_meta$format <- \'' + format + '\' }\n');

    // FIX FOR QUARTO STRICT BOOLEANS: Force 'true'/'false' instead of 'yes'/'no'
    echo('custom_handlers <- list(logical = function(x) { res <- ifelse(x, "true", "false"); class(res) <- "verbatim"; return(res) })\n');
    echo('yaml_str <- yaml::as.yaml(qmd_meta, handlers = custom_handlers)\n');

    echo('full_qmd <- paste0("---\\n", yaml_str, "---\\n\\n## Introducción\\n")\n');
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("1. Document Builder results")).print();

    echo('rk.header("Generated Quarto Boilerplate", level=2)\n');
    echo('cat("\\n============================================================\\n")\n');
    echo('cat(full_qmd)\n');
    echo('cat("============================================================\\n\\n")\n');
  

}

