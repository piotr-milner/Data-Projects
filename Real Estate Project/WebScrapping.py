# =============================================================================================
# Web scrapping scrypt for real estate data analysis project, based on a BeautifulSoup library
# Current site: Domiporta.pl
# As a future plan the project will expand for additional data from other sources
# thus functions has been implemented
# =============================================================================================

import re
import csv
import requests
from bs4 import BeautifulSoup

final_data = []
count = 0  # Variable used in loop to correctly updating final dict with scrapped data

# Searching for all pages currently available on site
req = requests.get('https://www.domiporta.pl/mieszkanie/sprzedam?Rynek=Wtorny')
parse = BeautifulSoup(req.text, 'html.parser').select('.pagination')
all_pages = max([int(num) for num in re.split("[^0-9]", str(parse)) if num != '']) + 1

# Selecting and assigning price, square meters, location and rooms from HTML
for p in range(1, all_pages + 1):
    req_main = requests.get(
        f'https://www.domiporta.pl/mieszkanie/sprzedam?Rynek=Wtorny&PageNumber={p}')
    soup = BeautifulSoup(req_main.text, 'html.parser')
    price = soup.select('.sneakpeak__price_value')
    sqm = soup.select('.sneakpeak__details_item.sneakpeak__details_item--area')
    loc = soup.select('.sneakpeak__title--inblock')
    r = soup.select('.sneakpeak__details_item.sneakpeak__details_item--room')

    # Extracting a single price and adding to final list
    def extract_price(price):
        for idx, item in enumerate(price):
            if idx % 2 == 0:
                raw_str = price[idx].getText()
                sub1 = '">'
                sub2 = '</'
                idx1 = raw_str.find(sub1)
                idx2 = raw_str.find(sub2)
                res = raw_str[idx1 + 1: idx2 - 2].__repr__()
                final_data.append({'Source': 'Domiporta', 'Price': res.replace(r'\xa0', ' ')})
        return final_data
    extract_price(price)

    # Extracting a single name of location and adding to final dict
    def extract_loc(loc, count):
        for idx, item in enumerate(loc):
            raw_str = loc[idx].getText()
            sub1 = 'mieszkanie '
            sub2 = ','
            idx1 = raw_str.find(sub1)
            idx2 = raw_str.find(sub2)
            res = raw_str[idx1 + len(sub1): idx2]
            final_data[count].update({'Location': res})
            count += 1
        return final_data
    extract_loc(loc, count)

    # Extracting a single number of square meters and adding to final dict
    def extract_sqm(sqm, count):
        for idx, item in enumerate(sqm):
            if idx % 2 == 0:
                raw_str = sqm[idx].getText()
                sub1 = 'Powierzchnia">'
                sub2 = '<abbr'
                idx1 = raw_str.find(sub1)
                idx2 = raw_str.find(sub2)
                res = raw_str[idx1 + len(sub1) + 1: idx2 - 3].strip()
                final_data[count].update({'Sqm': res.replace(',', '.')})
                count += 1
        return final_data
    extract_sqm(sqm, count)

    # Extracting a single rooms number  and adding to final dict
    def extract_r(r, count):
        for idx, item in enumerate(r):
            if idx % 2 == 0:
                raw_str = r[idx].getText()
                sub1 = '>'
                sub2 = '<'
                idx1 = raw_str.find(sub1)
                idx2 = raw_str.find(sub2)
                res = raw_str[idx1 + len(sub1) + 1: idx2 - 5].strip()
                final_data[count].update({'Rooms': res})
                count += 1
        return final_data, count

    final_data, count = extract_r(r, count)

# Exporting dictionary to CSV file
csv_file = "final_data_sell.csv"
csv_columns = ['Source', 'Price', 'Location', 'Sqm', 'Rooms']
try:
    with open(csv_file, 'w') as csv_file:
        wrt = csv.DictWriter(csv_file, fieldnames=csv_columns)
        wrt.writeheader()
        for data in final_data:
            wrt.writerow(data)
except IOError:
    print("I/O error")
