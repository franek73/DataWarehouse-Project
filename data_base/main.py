from datetime import date, timedelta

from faker import Faker
import random
import string
import csv
import pandas as pd

fake = Faker()

# T1 -> date 01.01.2020 - 31.12.2023
# T2 -> date 02.01.2024 - 31.12.2024
start_date = date(2024, 1, 2)
end_date = date(2024, 12, 31)

names = [
    ['Iron',
     'Coal',
     'Copper',
     'Gold',
     'Silver'],
    ['Grain',
     'Wheat',
     'Corn',
     'Rice'],
    ['Car',
     'VIP Car'],
    ['Container'],
    ['Petrol',
     'Gas',
     'Oil'],
    ['Steel',
     'Aluminium',
     'Cement',
     'Concrete'],
    ['Food'],
    ['Logs',
     'Planks'
     'Sawdust'],
    ['AGD'],
    ['Metals'],
    ['Goods',
     'Clothes',
     'Furniture'],
    ['Pigs',
     'Cows'],
    ['Electronics'],
    ['Chemicals',
     'Fertilizers',
     'Pesticides']
]
categories = ['Raw Minerals', 'Agricultural', 'Automobiles',
              'Intermodal Containers', 'Oil',
              'Building Materials', 'Food', 'Forestry',
              'Machinery', 'Metals', 'Goods',
              'Livestock', 'Electronics', 'Chemicals'
              ]
t1_transports_count = 800000
t2_transports_count = 200000


def generate_fake_data(table_name, num_rows=0, file_number=1):
    if table_name == 'Locomotive':
        with open(f'locomotive_{file_number}.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["SerialNumber", "Type", "Model", "TowingCapacity"])
            for _ in range(num_rows):
                sn = 0
                if file_number == 1:
                    sn = fake.unique.random_int(min=10000, max=50000)
                else:
                    sn = fake.unique.random_int(min=50001, max=100000)
                row = [
                    sn,
                    fake.random_element(elements=('Electric', 'Diesel', 'Hybrid')),
                    random.choice(string.ascii_uppercase[:-10]) + '-' + str(fake.random_int(min=10, max=20)),
                    fake.random_int(min=10, max=100)
                ]
                writer.writerow(row)

    elif table_name == 'Contract':
        com = ''
        with open(f'contract_{file_number}.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["Company"])
            for _ in range(num_rows):
                while com == '' or com.count(',') > 0:
                    com = fake.company()
                writer.writerow([com])
                com = ''

    elif table_name == 'Transport':
        contract_id_t1 = 40000
        contract_id_t2 = 10000
        with open(f'transport_{file_number}.csv', 'w', newline='') as file:
            past_locos = {}
            writer = csv.writer(file)
            writer.writerow(["StartDate", "EndDate", "StartCity", "EndCity", "ContractID", "LocomotiveSN"])

            with open(f'locomotive_{file_number}.csv', mode='r') as file_loco:
                reader = csv.DictReader(file_loco)
                locosSNs = [row['SerialNumber'] for row in reader]

                for _ in range(num_rows):
                    start = fake.date_between(start_date=start_date, end_date=end_date)
                    end = start + timedelta(days=random.randint(1, 60))
                    locoSN = ''
                    finish = False

                    while not finish:
                        locoSN = random.choice(locosSNs)
                        if locoSN in past_locos:
                            for ranges in past_locos[locoSN]:
                                if ranges[0] <= start <= ranges[1] or ranges[0] <= end <= ranges[1] or (
                                        start <= ranges[0] and end >= ranges[1]):
                                    break
                            finish = True
                        else:
                            finish = True

                    cid = 0
                    if file_number == 1:
                        cid = fake.random_int(min=1, max=contract_id_t1)
                    else:
                        cid = fake.random_int(min=contract_id_t1 + 1, max=contract_id_t1 + contract_id_t2)
                    row = [
                        start,
                        end,
                        fake.city(),
                        fake.city(),
                        cid,
                        locoSN
                    ]
                    if locoSN not in past_locos:
                        past_locos[locoSN] = [[start, end]]
                    else:
                        past_locos[locoSN].append([start, end])
                    writer.writerow(row)


    elif table_name == 'Cargo':
        with open(f'cargo_{file_number}.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["Name", "CargoGroup"])
            category = ''
            for cat_index in range(len(categories)):
                category = categories[cat_index]
                for name in names[cat_index]:
                    writer.writerow([name, category])

    elif table_name == 'Load':
        with open(f'load_{file_number}.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["CargoName", "TransportIndex", "Weight"])
            if file_number == 1:
                for transport_index in range(1, t1_transports_count+1, 1):
                    last_cat_index = -1
                    for _ in range(2):
                        random_cat_index = random.randint(0, len(categories) - 1)
                        while random_cat_index == last_cat_index:
                            random_cat_index = random.randint(0, len(categories) - 1)

                        cargo = random.choice(names[random_cat_index])

                        writer.writerow([
                            cargo,
                            transport_index,
                            random.randint(10, 1000)
                        ])
                        last_cat_index = random_cat_index

            else:
                for transport_index in range(t1_transports_count + 1, t1_transports_count + t2_transports_count+1, 1):
                    last_cat_index = -1
                    for _ in range(2):
                        random_cat_index = random.randint(0, len(categories) - 1)
                        while random_cat_index == last_cat_index:
                            random_cat_index = random.randint(0, len(categories) - 1)

                        cargo = random.choice(names[random_cat_index])

                        writer.writerow([
                            cargo,
                            transport_index,
                            random.randint(10, 1000)
                        ])
                        last_cat_index = random_cat_index

    elif table_name == 'Freight_Car':
        with open(f'freight_car_{file_number}.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["SerialNumber", "Model", "Capacity", "CargoGroup"])
            for _ in range(num_rows):
                sn = 0
                if file_number == 1:
                    sn = fake.unique.random_int(min=10000, max=50000)
                else:
                    sn = fake.unique.random_int(min=50001, max=100000)
                row = [
                    sn,
                    random.choice(string.ascii_uppercase[:-10]) + '-' + str(fake.random_int(min=10, max=20)),
                    fake.random_int(min=1000, max=10000),
                    random.choice(categories)
                ]
                writer.writerow(row)

    elif table_name == 'Freight_Car_Assignment':
        freight_cars = []  # [SN, CargoGroup]
        groups = {}
        transport_groups = []  # [TransportID, CargoGroup]

        with open(f'freight_car_2_{file_number}.csv', mode='r') as file:
            reader = csv.DictReader(file)
            freight_cars = [[row['SerialNumber'], row['CargoGroup']] for row in reader]

        for car in freight_cars:
            if groups.get(car[1]) is None:
                groups[car[1]] = [car[0]]
            else:
                groups[car[1]].append(car[0])

        df = pd.read_csv(f"transport_groups_temp_{file_number}.txt", delimiter='\t', header=None)
        transport_groups = df.values.tolist()

        with open(f'freight_car_assignment_{file_number}.txt', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["TransportID", "FreightCarSN"])

            for entry in transport_groups:
                if entry[1] is None:
                    print(f'Written data for {entry[0]} transports')
                    break
                count = random.randint(2, 10)
                SNs = set()
                for i in range(count):
                    SNs.add(groups[entry[1]][random.randint(0, len(groups[entry[1]]) - 1)])
                for sn in SNs:
                    to_write = [entry[0], sn]
                    writer.writerow(to_write)


def create_data_t1():
    generate_fake_data('Locomotive', 2500, 1)
    generate_fake_data('Contract', 40000, 1)
    generate_fake_data('Transport', t1_transports_count, 1)
    generate_fake_data('Cargo', 0, 1)
    generate_fake_data('Load', 0, 1)
    generate_fake_data('Freight_Car', 20000, 1)


def create_data_t2():
    generate_fake_data('Locomotive', 300, 2)
    generate_fake_data('Contract', 10000, 2)
    generate_fake_data('Transport', t2_transports_count, 2)
    generate_fake_data('Load', 0, 2)
    generate_fake_data('Freight_Car', 4000, 2)


def main():
    #create_data_t1()
    #generate_fake_data('Freight_Car_Assignment', 0, 1)
    #  ZMIENIC DATY
    #create_data_t2()
    generate_fake_data('Freight_Car_Assignment', 0,2)


if __name__ == '__main__':
    main()
