# Customers and Products Analysis with SQL and Python
## Introduction 
In this project, I conducted customers and products analysis by querying a scale model car database with DB browser SQLite first, and then querying from Python to interact with the database and summerise the results with Jupyter Notebook.

The analysis aims to answer three questions:
* What are the priority products that we should order more?
* How should we match marketing and communication strategies to customer behaviors?
* How Much Can We Spend on Acquiring New Customers?
## The database
The database [Download stores.db] (stores.db) contains eight tables:

|table_name  |number_of_attributes|number_of_row| note_on_the_table                   |
|------------|--------------------|-------------|-------------------------------------|
|Customers   |13                  |122          |customer data                        |
|Products    |9                   |110          |a list of scale model cars           |
|Productlines|4                   |7            |a list of product line categories    |
|Orders      |7                   |326          |customers' sales orders              |
|OrderDetails|5                   |2996         |sales order line for each sales order|
|Payments    |4                   |273          |customers' payment records           |
|Employees   |8                   |23           |all employee information             |
|Offices     |9                   |7            |sales office information             | 


The database schema is as follows:

![database schema](./db_schema.png)

## SQL file
The SQL file [Download Customers_and_Products.sql] (Customers_and_Products.sql) contains the SQLite queries I used to explore the dataset with [DB Browser] (https://sqlitebrowser.org/dl/), which is a commonly used tool to handle SQLite databases. 

## Jupyter Notebook file
I exectued the queries with Python in the Jupyter Notebook file (./CustomerAndProductAnalysis_QueryingSQLiteFromPyton) and summeried the results. 


## Summary results 

The results reveal the priority products for restocking based on their potential revenue contribution. Among low stock products, '1968 Ford Mustang' has the highest projected revenue and a low stock index of 13.72, indicating strong demand relative to available stock. '1960 BSA Gold Star DBD34' is the product with the highest low stock index (67.67), highlighting a significant stock gap. However, its potential revenue is comparatively modest(<1000,000).

The results hightlights VIP customers and the least-enaged customers and we should consider marketing and communication Strategies targeted for the two different group customers.

Lastly, the results show that the new customer acquisition rate has dropped below 50% since 2004. Given a LTV of 39039.59, recommendations on how much can be spent on acquiring new customers are given. We can spend up to $ 13013.20 on acquiring each new customer to maintain a healty LTV-to-CAC ratio of 3:1.
