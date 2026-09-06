// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var type = getValue('c2_type');
    echo('snippet <- c(\n');
    if (type == 'chunk_basic') {
      echo('  "```{r}",\n  "#| label: basic-code",\n  "",\n  "summary(cars)",\n  "```"\n');
    } else if (type == 'chunk_plot_ref') {
      echo('  "```{r}",\n  "#| label: fig-cars",\n  "#| fig-cap: \'This is a plot of the cars dataset.\'",\n  "",\n  "plot(cars)",\n  "```",\n  "",\n  "As seen in @fig-cars."\n');
    } else if (type == 'lay_callout') {
      echo('  "::: {.callout-note}",\n  "This is a note callout.",\n  ":::"\n');
    } else if (type == 'lay_tabs') {
      echo('  "::: {.panel-tabset}",\n  "## Data",\n  "Data here",\n  "## Plot",\n  "Plot here",\n  ":::"\n');
    } else if (type == 'lay_cols') {
      echo('  "::: {.columns}",\n  "::: {.column width=\'50%\'}",\n  "Left",\n  ":::",\n  "::: {.column width=\'50%\'}",\n  "Right",\n  ":::",\n  ":::"\n');
    }
    echo(')\n');
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("2. Quarto Cheat Sheet results")).print();

    echo('rk.header("Quarto Snippet", level=2)\n');
    echo('cat(paste(snippet, collapse="\\n"))\n');
  

}

