# 📊Cyclistic Case Study Data Analysis
## 👋Introduction
Cyclistic is a fictional bike-share company and dataset created for the capstone project in the Google Data Analytics course on Coursera.
## 🧭Background
Cyclistic introduced its bike-share program in 2016, which quickly became a success. Over the years, the system has expanded to include 5,824 GPS-equipped bikes distributed across 692 docking stations throughout Chicago. Riders can check out a bike from any station and return it to another within the network at their convenience.
Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a solid opportunity to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.
Lily Moreno, the director of marketing has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members.
## 🧩Deliverables
### 1. (ASK) A clear statement of the business task 
The business task is to analyze Cyclistic’s historical bike trip data to identify and explain the key differences in how annual members and casual riders use Cyclistic bikes. This analysis focuses on uncovering behavioral patterns, usage trends, and location preferences that distinguish the two rider groups. The insights gained from this analysis provide a data-driven foundation for developing targeted marketing strategies that aim to convert casual riders into annual members, supporting Cyclistic’s ongoing goal of increasing long-term profitability and customer retention.

### 2. (Prepare) A description of all data sources used 
The data source can be found here: [divvy-tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html) <br> 
The twelve files downloaded were: <br>
    &nbsp;&nbsp;&nbsp;&nbsp;202410-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202411-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202412-divvy-tripdata.zip <br>
    &nbsp;&nbsp;&nbsp;&nbsp;202501-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202502-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202503-divvy-tripdata.zip <br>
    &nbsp;&nbsp;&nbsp;&nbsp;202504-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202505-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202506-divvy-tripdata.zip <br>
    &nbsp;&nbsp;&nbsp;&nbsp;202507-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202508-divvy-tripdata.zip  &nbsp;&nbsp;&nbsp;&nbsp;202509-divvy-tripdata.zip <br>

[Note that the data has been made available by Motivate International Inc. under this [<ins>license</ins>](https://www.divvybikes.com/data-license-agreement).]
### 3.	(Process) Documentation of any cleaning or manipulation of data 
>•	Data was downloaded, manipulated, and cleaned using Microsoft Excel.<br>
>&nbsp;&nbsp;&nbsp;&nbsp;o	Calculations were made to add two columns to the data sets<br>
>&nbsp;&nbsp;&nbsp;&nbsp;o	Only one file, 202411-divvy-tripdata.zip, had corrupt data and 600 records were deleted from the file.<br>
>•	 Files were uploaded to Microsoft SQL Server and combined into one Table with a total of 5M records.<br>

### 4.	(Analyze) A summary of analysis  
>•	R Studio was used to establishing a link between SQL server and R, query SQL, analyse data, and create graphs. <br>
>&nbsp;&nbsp;&nbsp;&nbsp; o	Queries were run to identify the bike preference of both casual riders and annual members and findings plotted in a pie chart. A knitted mark down file showing steps and results can be accessed here:<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Rider bike preference](https://raw.githack.com/FernandoCantu72/Google-Data-Analytics-Cyclistic-Case-Study/refs/heads/main/Rider_Preferences_SideBySide.html)<br>
>&nbsp;&nbsp;&nbsp;&nbsp; o	Queries were run to identify the different usage by rider type and by day of the week and the results plotted in a bar chart.<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Rides by day of week](https://raw.githack.com/FernandoCantu72/Google-Data-Analytics-Cyclistic-Case-Study/refs/heads/main/Cyclistic_Rides_by_Weekday_markdown.html)<br>

>•	MS SQL and Python were used to create a map. <br>
>&nbsp;&nbsp;&nbsp;&nbsp; o	Query was run in MS SQL to identify the top twenty stations used by Members and the top twenty stations used by Casual riders. <br>
>&nbsp;&nbsp;&nbsp;&nbsp; o	Python was used to generate a map that plots the findings.

### 5.	(Share) Supporting visualizations and key findings  
>•	To visualize the findings, an ESRI Story Map was used to showcase the results: [<ins>Case Study</ins>](https://arcg.is/1mH4KW0)

### 6.	(Act) Top three recommendations based on data analysis results
>•	Expand Electric Bike Availability: Increasing the number of electric bikes, especially in the Bay Area and at the top 20 stations with the highest rental activity would make membership more appealing and convenient for >frequent users. <br>

>•	Introduce Flexible Pass Options: Offering monthly or seasonal passes at price points between single-ride and annual memberships would give casual riders a gradual, cost-effective path toward full membership. <br>

>•	Launch a Referral Program: Creating a referral incentive program for groups, families, or friends could motivate current riders to upgrade from short-term passes to annual memberships while attracting new users through >word-of-mouth. <br>



## 🎯 Conclusion
The analysis indicate a strong alignment between Cyclistic’s marketing objectives and the data-driven insights obtained from the study. The results reveal significant opportunities to convert casual riders into annual members by utilizing observed ride patterns, spatial trends, and digital engagement behaviors. Incorporating these insights into targeted digital media strategies is expected to enhance customer engagement and foster sustainable organizational growth.
