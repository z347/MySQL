-- 1.
SELECT * FROM client WHERE LENGTH(FirstName) < 6;

-- 2.
SELECT * FROM department WHERE DepartmentCity = 'Lviv';

SELECT * FROM department WHERE idDepartment = 2 OR idDepartment = 5;

-- 3.
SELECT * FROM client WHERE Education = 'high' ORDER BY LastName;

-- 4.
SELECT * FROM application ORDER BY Sum DESC LIMIT 5;

-- 5.
SELECT * FROM client WHERE LastName LIKE '%OV' OR '%OVA';

-- 6.
SELECT * FROM client WHERE Department_idDepartment = 1 OR Department_idDepartment = 4;

-- 7.
SELECT FirstName, Passport FROM client ORDER BY FirstName;

-- 8.
SELECT * FROM client
		JOIN application a ON client.idClient = a.Client_idClient
			WHERE Sum > 5000 AND Currency = 'Gryvnia';

-- 9.
SELECT
	    (SELECT COUNT(idClient) FROM client) AS table_1,
	    (SELECT COUNT(idClient) FROM client WHERE Department_idDepartment = 2 OR Department_idDepartment = 5) AS table_2;

-- 10.
SELECT Client_idClient, MAX(Sum) FROM application GROUP BY Client_idClient;

-- 11.
SELECT FirstName, LastName, COUNT(Client_idClient) AS total_credits FROM application
		JOIN client a ON application.Client_idClient = a.idClient
			GROUP BY Client_idClient;

-- 12.
SELECT MAX(Sum), MIN(Sum) FROM application;

-- 13.
SELECT idClient, FirstName, LastName, COUNT(Client_idClient) AS total_credits FROM application
		JOIN client a ON application.Client_idClient = a.idClient
			WHERE Education = 'high' GROUP BY client_idClient;

-- 14.
SELECT idClient, FirstName, LastName, AVG(Sum) AS max FROM client
   		JOIN application a on client.idClient = a.Client_idClient
        	GROUP BY idClient ORDER BY max DESC LIMIT 1;

-- 15.
SELECT idDepartment, SUM(Sum) AS SUM FROM department
    	JOIN client c on department.idDepartment = c.Department_idDepartment
   		JOIN application a on c.idClient = a.Client_idClient
      	  GROUP BY idDepartment ORDER BY SUM DESC LIMIT 1;

-- 16.
SELECT idDepartment, MAX(Sum) FROM department
   		 JOIN client c on department.idDepartment = c.Department_idDepartment
	     JOIN application a on c.idClient = a.Client_idClient;

-- 17.
UPDATE application
	JOIN client c on application.Client_idClient = c.idClient
	SET Sum = 6000, Currency = 'Gryvnia'
	WHERE Education = 'high';

-- 18.
UPDATE client SET City = 'Kyiv'
		WHERE Department_idDepartment = 1 OR Department_idDepartment = 4;

-- 19.
DELETE FROM application WHERE CreditState = 'Returned';

-- 20.


-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment, SUM(Sum) AS sum FROM department
    JOIN client c on department.idDepartment = c.Department_idDepartment
    	JOIN application a on c.idClient = a.Client_idClient
        	WHERE DepartmentCity = 'Lviv' GROUP BY idDepartment HAVING sum > 5000;


-- Знайти максимальний неповернений кредит
SELECT MAX(Sum) FROM application WHERE CreditState = 'Not returned';


-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT * FROM client JOIN application ON client.idClient = application.Client_idClient WHERE Sum > 5000 AND CreditState = 'Returned';


-- Знайти клієнта, сума кредиту якого найменша
SELECT idClient, SUM(Sum) AS sum FROM application
   	JOIN client c on application.Client_idClient = c.idClient
    	JOIN department d on c.Department_idDepartment = d.idDepartment
       	GROUP BY idClient ORDER BY sum limit 1;


-- місто чувака який набрав найбільше кредитів
SELECT City, COUNT(Client_idClient) AS amount FROM client
	JOIN application a on client.idClient = a.Client_idClient
		GROUP BY Client_idClient ORDER BY amount DESC LIMIT 1;

Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT idApplication, Sum, CreditState FROM application
  WHERE Sum > (SELECT AVG(Sum) FROM application);

-- Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
SELECT * FROM client
  WHERE City = (
    SELECT c.City AS id
      FROM application a
        JOIN client c on a.Client_idClient = c.idClient
          GROUP BY Client_idClient
            ORDER BY COUNT(idApplication)
              DESC LIMIT 1);