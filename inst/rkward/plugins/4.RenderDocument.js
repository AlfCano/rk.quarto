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

    echo('quarto::quarto_render(\n');
    echo('  input = \'' + input + '\'');

    if (format !== '') {
      echo(',\n  output_format = \'' + format + '\'');
    }

    if (output !== '' && format !== 'all') {
      echo(',\n  output_file = \'' + output + '\'');
    }

    echo(',\n  quiet = TRUE\n');
    echo(')\n');
  
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

