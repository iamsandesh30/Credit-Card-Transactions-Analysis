create table credit_card_transactions
(Transaction_Timestamp timestamp default null,	User_ID int, 	Transaction_ID varchar(50),	Transaction_Amount real);

select * from credit_card_transactions;

-- a) Calculate: total_transactions, unique_users and total_transaction_amount for every date and hour combination.

select user_id, date(Transaction_Timestamp) as dt, hour(Transaction_Timestamp) as hr, 
count(Transaction_ID) over(partition by user_id order by date(Transaction_Timestamp ),hour(Transaction_Timestamp) ) as count_transactions,
sum(Transaction_amount) over(partition by user_id order by date(Transaction_Timestamp ),hour(Transaction_Timestamp) ) as sum_transactions
from credit_card_transactions
order by count_transactions desc;

-- b) Calculate hour with highest transaction_amount for every date

with cte as (
select date(Transaction_Timestamp) as dt, hour(Transaction_Timestamp) as hr,
sum(Transaction_Amount) as total 
from credit_card_transactions
group by dt, hr
order by hr),
 cte2 as (
select *,
row_number() over(partition by  hr order by total desc) as rn 
from cte
)
select * from cte2
where rn = 1;