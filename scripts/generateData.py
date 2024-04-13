import random
import csv


def main():
    csv_writer = csv.writer(open("./data.csv", "w"))
    with open("../data.csv") as f:
        data = f.readlines()

    csv_writer.writerow(["address", "tokenId", "amount"])

    for line in data:
        csv_writer.writerow([line.strip(), random.randint(0, 3), random.randint(1e18, 10e18)])
        
main()