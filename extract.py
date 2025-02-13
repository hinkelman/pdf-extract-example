import pdfplumber
import polars as pl

gf_file = pdfplumber.open("good-file.pdf")

gf_pg1 = gf_file.pages[0]

gf_pg1_tbl = gf_pg1.extract_table()

gf_pg1_df = pl.DataFrame(gf_pg1_tbl[1:],
                         schema=gf_pg1_tbl[0],
                         orient="row")


def extract_tables(file, pages="all"):
    pdf = pdfplumber.open(file)
    if pages == "all":
        indices = range(len(pdf.pages))
    else:
        indices = [x - 1 for x in pages]
    out = []
    for i in indices:
        table = pdf.pages[i].extract_table()
        out.append(pl.DataFrame(table[1:],
                                schema=table[0],
                                orient="row"))
    return out


gf_list = extract_tables("good-file.pdf")
gf = pl.concat(gf_list, how="vertical")

pf1_gp_list = extract_tables("problem-file-1.pdf",
                                 [4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15])
pf1_gp = pl.concat(pf1_gp_list, how="vertical")

# decided not to further pursue Python alternative
