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
    var journal = getValue('c3_journal');
    var format = getValue('c3_format');

    // Construir la sintaxis de formato de Quarto (ej. apaquarto-pdf)
    var final_format = journal + '-' + format;

    echo('j_meta <- list()\n');
    echo('j_meta$title <- \'' + title + '\'\n');
    if (abstract != '') echo('j_meta$abstract <- \'' + abstract + '\'\n');

    // Autoría estándar básica para Quarto 1.2+
    echo('j_meta$author <- list(list(name = "John Doe", affiliations = list(list(name = "University of Excellence"))))\n');

    echo('j_meta$format <- \'' + final_format + '\'\n');
    echo('yaml_str <- yaml::as.yaml(j_meta)\n');

    // Determinar el comando de terminal requerido
    echo('cli_cmd <- ""\n');
    echo('if ("' + journal + '" == "apaquarto") { cli_cmd <- "quarto add wviechtb/apaquarto" } else { cli_cmd <- paste0("quarto use template quarto-journals/", "' + journal + '") }\n');

    echo('full_journal <- paste0("---\\n", yaml_str, "---\\n\\n## Introduction\\n")\n');
  
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

