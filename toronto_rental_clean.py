import pandas as pd

df = pd.read_excel("toronto_rental_clean.xlsx")

#print(df.head()) # Check whether successfully read
#print(df.info()) # Check value type

# Cleaning Data 2025

df["avg_rent_2br_2024"] = (
    df["avg_rent_2br_2024"]
    .str.replace(",", "")
    .astype(int)
) # Change str to float since raw data include comma

df["avg_rent_2br_2025"] = (
    df["avg_rent_2br_2025"]
    .str.replace(",", "")
    .astype(int)
) # Same as above

#print(df.info())

# Cleaning Completed

rent_change = df["avg_rent_2br_2025"] - df["avg_rent_2br_2024"]

print(rent_change)

rent_growth = (
    (df["avg_rent_2br_2025"] - df["avg_rent_2br_2024"])
    / df["avg_rent_2br_2024"]
    * 100
)

print(rent_growth) # 2025 rent_growth completed

file_2024 = pd.ExcelFile("Raw data/rmr-canada-2024-en.xlsx")

df_2024 = pd.read_excel(
    "Raw data/rmr-canada-2024-en.xlsx",
    sheet_name="Table 1.0"
)

print(df_2024.head(15))

toronto_2024 = df_2024[df_2024["Unnamed: 0"] == "Toronto CMA"]

print(toronto_2024) # find out2024 toronto data

clean_2024 = {
    "year": 2024,
    "city": toronto_2024.iloc[0]["Unnamed: 0"],
    "vacancy_rate": toronto_2024.iloc[0]["Unnamed: 3"],
    "turnover_rate": toronto_2024.iloc[0]["Unnamed: 8"],
    "avg_rent_2br": toronto_2024.iloc[0]["Unnamed: 13"],
    "rent_growth": toronto_2024.iloc[0]["Unnamed: 17"]
}

clean_2024["avg_rent_2br"] = int(
    clean_2024["avg_rent_2br"].replace(",", "")
)

print(clean_2024) # Cleaning data 2024 toronto rental, change readable name title

# Write a function to clean all 2021-2025 Toronto Rental data from table 1.0 from each excel

def clean_toronto_rental(file_path, year):
    df = pd.read_excel(file_path, sheet_name="Table 1.0")

    toronto = df[df["Unnamed: 0"] == "Toronto CMA"]

    clean_data = {
        "year": year,
        "city": toronto.iloc[0]["Unnamed: 0"],
        "vacancy_rate": toronto.iloc[0]["Unnamed: 3"],
        "turnover_rate": toronto.iloc[0]["Unnamed: 8"],
        "avg_rent_2br": int(
            toronto.iloc[0]["Unnamed: 13"].replace(",", "")
        ),
        "rent_growth": toronto.iloc[0]["Unnamed: 17"]
    }

    return clean_data

data = []

for year in range(2021, 2026):
    file_path = f"Raw data/rmr-canada-{year}-en.xlsx"

    cleaned = clean_toronto_rental(file_path, year)

    data.append(cleaned)

df_all = pd.DataFrame(data) # Create a table that can extract information

print(df_all)

df_all.to_csv("toronto_rental_2021-2025.csv", index=False) # Convert table to csv