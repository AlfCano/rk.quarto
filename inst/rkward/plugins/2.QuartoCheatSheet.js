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

    // CODE & CROSS-REFERENCES
    if (type == 'chunk_basic') {
      echo('  "```{r}",\n  "#| label: basic-code",\n  "",\n  "summary(cars)",\n  "```"\n');
    } else if (type == 'chunk_plot_ref') {
      echo('  "```{r}",\n  "#| label: fig-cars",\n  "#| fig-cap: \'This is a plot of the cars dataset.\'",\n  "",\n  "plot(cars)",\n  "```",\n  "",\n  "As seen in @fig-cars."\n');
    } else if (type == 'chunk_tbl_ref') {
      echo('  "```{r}",\n  "#| label: tbl-summary",\n  "#| tbl-cap: \'Summary of cars dataset\'",\n  "",\n  "knitr::kable(head(cars))",\n  "```",\n  "",\n  "As shown in @tbl-summary..."\n');
    } else if (type == 'chunk_hide') {
      echo('  "```{r}",\n  "#| label: hidden-code",\n  "#| echo: false",\n  "#| warning: false",\n  "#| message: false",\n  "",\n  "plot(cars)",\n  "```"\n');
    } else if (type == 'chunk_annotate') {
      echo('  "```r",\n  "library(dplyr)",\n  "mtcars %>% ",\n  "  select(mpg, cyl) # <1>",\n  "```",\n  "1. Select only mpg and cyl columns."\n');
    } else if (type == 'chunk_asis') {
      echo('  "```{r}",\n  "#| output: asis",\n  "",\n  "cat(\'**Bold text** generated directly from R.\')",\n  "```"\n');

    // LAYOUT & DESIGN
    } else if (type == 'lay_callout') {
      echo('  "::: {.callout-note}",\n  "This is a note callout. Change \'note\' to \'warning\' or \'tip\'.",\n  ":::"\n');
    } else if (type == 'lay_tabs') {
      echo('  "::: {.panel-tabset}",\n  "## Data",\n  "Data here",\n  "## Plot",\n  "Plot here",\n  ":::"\n');
    } else if (type == 'lay_cols') {
      echo('  "::: {.columns}",\n  "::: {.column width=\'50%\'}",\n  "Left",\n  ":::",\n  "::: {.column width=\'50%\'}",\n  "Right",\n  ":::",\n  ":::"\n');
    } else if (type == 'lay_2col_fig') {
      echo('  "```{r}",\n  "#| label: fig-2cols",\n  "#| fig-cap: \'Two figures side-by-side\'",\n  "#| layout-ncol: 2",\n  "",\n  "plot(cars)",\n  "plot(pressure)",\n  "```"\n');
    } else if (type == 'lay_subcap') {
      echo('  "```{r}",\n  "#| label: fig-subcaps",\n  "#| fig-cap: \'Main Figure Title\'",\n  "#| fig-subcap:",\n  "#|   - \'Subplot A\'",\n  "#|   - \'Subplot B\'",\n  "#| layout-ncol: 2",\n  "",\n  "plot(cars)",\n  "plot(pressure)",\n  "```"\n');
    } else if (type == 'lay_grid') {
      echo('  "```{r}",\n  "#| label: fig-complex",\n  "#| fig-cap: \'Complex 3-plot grid\'",\n  "#| layout: \"[[1, 1], [1]]\"",\n  "",\n  "plot(cars)",\n  "plot(pressure)",\n  "hist(mtcars$mpg)",\n  "```"\n');
    } else if (type == 'lay_screen') {
      echo('  "```{r}",\n  "#| column: screen",\n  "",\n  "plot(cars)",\n  "```"\n');
    } else if (type == 'lay_margin') {
      echo('  "::: {.column-margin}",\n  "This text or image will appear in the right margin.",\n  ":::"\n');
    } else if (type == 'lay_margin_fig') {
      echo('  "```{r}",\n  "#| label: fig-margin",\n  "#| fig-cap: \'Figure in margin\'",\n  "#| column: margin",\n  "",\n  "plot(cars)",\n  "```"\n');

    // ACADEMIC TEXT
    } else if (type == 'text_eq') {
      echo('  "$$",\n  "y = \\beta_0 + \\beta_1 x + \\epsilon",\n  "$$ {#eq-model}",\n  "",\n  "As seen in @eq-model..."\n');
    } else if (type == 'text_cite') {
      echo('  "This is a statement with a footnote^[This is the footnote text].",\n  "",\n  "According to recent studies [@smith2026]..."\n');

    // SHORTCODES
    } else if (type == 'short_pagebreak') {
      echo('  "{{< pagebreak >}}"\n');
    } else if (type == 'short_video') {
      echo('  "{{< video https://www.youtube.com/watch?v=dQw4w9WgXcQ >}}"\n');
    } else if (type == 'short_include') {
      echo('  "{{< include _chapter_1.qmd >}}"\n');
    }

    echo(')\n');
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("2. Quarto Cheat Sheet results")).print();

    echo('rk.header("Quarto Snippet", level=2)\n');
    echo('cat(paste(snippet, collapse="\\n"))\n');
  

}

