-- banking transaction & business analysis
-- mysql project

-- 1. create database
create database banking_analysis;
use banking_analysis;

-- 2. create table
create table banking_transactions (
    transaction_id varchar(50) primary key,
    sender_account_id varchar(50),
    receiver_account_id varchar(50),
    transaction_amount decimal(15,2),
    transaction_type varchar(20),
    transaction_timestamp datetime,
    transaction_status varchar(20),
    fraud_flag tinyint,
    latitude decimal(10,6),
    longitude decimal(10,6),
    device_used varchar(20),
    network_slice_id varchar(50),
    latency decimal(10,2),
    slice_bandwidth decimal(10,2),
    pin_code varchar(20)
);

select count(*) as total_records
from banking_transactions;

-- 3. enable local csv import
set global local_infile = 1;
show global variables like 'local_infile';

-- 4. import the csv file
load data local infile 'D:/New folder/banking_analysis.csv'
into table banking_transactions
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- 5. check total records
select count(*) as total_records
from banking_transactions;

-- 6. view some data
select *
from banking_transactions
limit 10;

-- 7. check for duplicate transaction ids
select
transaction_id, count(*) as duplicate_count
from banking_transactions
group by transaction_id
having count(*) > 1;

-- 8. check for missing values
select
    sum(transaction_id is null) as missing_transaction_id,
    sum(sender_account_id is null) as missing_sender,
    sum(receiver_account_id is null) as missing_receiver,
    sum(transaction_amount is null) as missing_amount,
    sum(transaction_type is null) as missing_type,
    sum(transaction_timestamp is null) as missing_timestamp,
    sum(transaction_status is null) as missing_status,
    sum(fraud_flag is null) as missing_fraud_flag,
    sum(latitude is null) as missing_latitude,
    sum(longitude is null) as missing_longitude,
    sum(device_used is null) as missing_device,
    sum(network_slice_id is null) as missing_network,
    sum(latency is null) as missing_latency,
    sum(slice_bandwidth is null) as missing_bandwidth,
    sum(pin_code is null) as missing_pin
from banking_transactions;

-- 9. check transaction types
select transaction_type, 
count(*) as transaction_count
from banking_transactions
group by transaction_type
order by transaction_count desc;

-- 10. check transaction status
select transaction_status,
count(*) as transaction_count
from banking_transactions
group by transaction_status;

-- 11. calculate success and failure rate
select
count(*) as total_transactions,
round(sum(transaction_status = 'Success') / count(*) * 100, 2) as success_rate,
round(sum(transaction_status = 'Failed') / count(*) * 100, 2) as failure_rate
from banking_transactions;

-- 12. check failure rate by transaction type
select transaction_type,
count(*) as total_transactions,
sum(transaction_status = 'Failed') as failed_transactions,
round(sum(transaction_status = 'Failed') / count(*) * 100, 2) as failure_rate
from banking_transactions
group by transaction_type
order by failure_rate desc;

-- 13. check overall transaction amounts
select
count(*) as total_transactions,
round(sum(transaction_amount), 2) as total_transaction_value,
round(avg(transaction_amount), 2) as average_transaction_amount,
min(transaction_amount) as minimum_transaction_amount,
max(transaction_amount) as maximum_transaction_amount
from banking_transactions;

-- 14. check transaction value by type
select transaction_type,
count(*) as total_transactions,
round(sum(transaction_amount), 2) as total_transaction_value,
round(avg(transaction_amount), 2) as average_transaction_amount
from banking_transactions
group by transaction_type
order by total_transaction_value desc;

-- 15. compare success and failure by transaction type
select transaction_type,
sum(transaction_status = 'Success') as successful_transactions,
sum(transaction_status = 'Failed') as failed_transactions,
count(*) as total_transactions
from banking_transactions
group by transaction_type
order by failed_transactions desc;

-- 16. compare transaction value by status
select transaction_status,
count(*) as transaction_count,
round(sum(transaction_amount), 2) as total_transaction_value,
round(avg(transaction_amount), 2) as average_transaction_amount
from banking_transactions
group by transaction_status
order by total_transaction_value desc;

-- 17. count transactions by device
select device_used,
count(*) as transaction_count
from banking_transactions
group by device_used
order by transaction_count desc;

-- 18. check failure rate by device
select device_used,
count(*) as total_transactions,
sum(transaction_status = 'Failed') as failed_transactions,
sum(transaction_status = 'Success') as successful_transactions,
round(sum(transaction_status = 'Failed') / count(*) * 100, 2) as failure_rate
from banking_transactions
group by device_used
order by failure_rate desc;

-- 19. check transaction performance by network slice
select network_slice_id,
count(*) as total_transactions,
sum(transaction_status = 'Failed') as failed_transactions,
sum(transaction_status = 'Success') as successful_transactions,
round(sum(transaction_status = 'Failed') / count(*) * 100, 2) as failure_rate
from banking_transactions
group by network_slice_id
order by failure_rate desc;

-- 20. check fraud rate
select
count(*) as total_transactions,
sum(fraud_flag = 1) as fraudulent_transactions,
round(sum(fraud_flag = 1) / count(*) * 100, 2) as fraud_rate
from banking_transactions;

-- 21. compare transaction value by device
select device_used,
count(*) as total_transactions,
round(sum(transaction_amount), 2) as total_transaction_value,
round(avg(transaction_amount), 2) as average_transaction_value
from banking_transactions
group by device_used
order by total_transaction_value desc;

-- 22. check latency by network slice
select network_slice_id,
count(*) as total_transactions,
round(avg(latency), 2) as average_latency,
min(latency) as minimum_latency,
max(latency) as maximum_latency
from banking_transactions
group by network_slice_id
order by average_latency desc;
