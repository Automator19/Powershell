- #### View all databases with ID and create date
    ```
    SELECT name, database_id, create_date  
    FROM sys.databases;  
    GO
    ```

- #### View all tables of the database , Note: right click on database and slect new query
    ```
    SELECT *
    FROM information_schema.tables;
    ```

- #### View all columns of a table
    ```
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tablename'
    ```

- #### Select top 10 rows from a table
    `SELECT * TOP 10 FROM tablename`

- #### How do I see active SQL server connections ?
    ```
    SELECT 
        DB_NAME(dbid) as DBName, 
        COUNT(dbid) as NumberOfConnections,
        loginame as LoginName
    FROM
        sys.sysprocesses
    WHERE 
        dbid > 0
    GROUP BY 
        dbid, loginame
    ;
    ```