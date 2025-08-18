## This is a program script that renders the Palmer Penguin reports

# This outputs the PDF to the reports folder
rmarkdown::render("Rmarkdown/scripts/penguins_pdf.Rmd",
                  output_file = "penguin_report_static.pdf", 
                  output_dir = "Rmarkdown/reports")

# This outputs the HTML to the reports folder
rmarkdown::render("Rmarkdown/scripts/penguins_html.Rmd",
                  output_file = "penguin_report_interactive.html", 
                  output_dir = "Rmarkdown/reports")
