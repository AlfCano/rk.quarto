// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(quarto)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function cleanStr(val) {
        if(!val) return '';
        return val.replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, '\\n');
    }
  
    var input = cleanStr(getValue('c4_input'));
    var format = getValue('c4_format');
    var output = cleanStr(getValue('c4_output'));
    var custom_path = cleanStr(getValue('c4_path'));
    var is_quiet = getValue('c4_quiet'); // Read checkbox value

    // 1. PATH ERROR SOLUTION: Cross-platform Auto-detection in RKWard
    if (custom_path !== '') {
        echo('Sys.setenv(QUARTO_PATH = \'' + custom_path + '\')\n');
    } else {
        echo('if (Sys.which("quarto") == "" && Sys.getenv("QUARTO_PATH") == "") {\n');
        // Linux & macOS fallbacks
        echo('  if (file.exists("/usr/local/bin/quarto")) Sys.setenv(QUARTO_PATH = "/usr/local/bin/quarto")\n');
        echo('  else if (file.exists("/opt/quarto/bin/quarto")) Sys.setenv(QUARTO_PATH = "/opt/quarto/bin/quarto")\n');
        echo('  else if (file.exists("/Applications/quarto/bin/quarto")) Sys.setenv(QUARTO_PATH = "/Applications/quarto/bin/quarto")\n');
        // Windows fallbacks (.exe)
        echo('  else if (file.exists("C:/Program Files/Quarto/bin/quarto.exe")) Sys.setenv(QUARTO_PATH = "C:/Program Files/Quarto/bin/quarto.exe")\n');
        echo('  else if (file.exists(file.path(Sys.getenv("LOCALAPPDATA"), "Programs/Quarto/bin/quarto.exe"))) Sys.setenv(QUARTO_PATH = file.path(Sys.getenv("LOCALAPPDATA"), "Programs/Quarto/bin/quarto.exe"))\n');
        echo('}\n');
    }

    // 2. Prepare files (Avoids the 'paths are not allowed' error)
    echo('input_file <- \'' + input + '\'\n');
    if (output !== '' && format !== 'all') {
        echo('output_target <- \'' + output + '\'\n');
        echo('out_name <- basename(output_target)\n');
    }

    // 3. Execute Quarto
    echo('quarto::quarto_render(\n');
    echo('  input = input_file');

    if (format !== '') {
      echo(',\n  output_format = \'' + format + '\'');
    }

    if (output !== '' && format !== 'all') {
      echo(',\n  output_file = out_name');
    }

    // Use quiet mode based on user selection (TRUE or FALSE)
    echo(',\n  quiet = ' + is_quiet + '\n');
    echo(')\n');

    // 4. Move the file to the user-defined destination path
    if (output !== '' && format !== 'all') {
        echo('generated_file <- file.path(dirname(input_file), out_name)\n');
        echo('if (normalizePath(generated_file, mustWork=FALSE) != normalizePath(output_target, mustWork=FALSE)) {\n');
        echo('  file.copy(from = generated_file, to = output_target, overwrite = TRUE)\n');
        echo('  file.remove(generated_file)\n');
        echo('}\n');
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("4. Render Document results")).print();

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
           final_output = input.replace(/\\.[^/.]+$/, "") + ext;
       } else {
           final_output = "Same directory as original (.qmd)";
       }
    }

    echo('rk.header("Export Quarto Document", parameters = list(\n');
    echo('  "Quarto File" = \'' + input + '\',\n');
    echo('  "Target Format" = \'' + format_lbl + '\',\n');
    echo('  "Save as" = \'' + final_output + '\'\n');
    echo('))\n');
  

}

