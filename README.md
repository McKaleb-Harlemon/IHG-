# IHG Marketing Email Click Prediction

Overview
This project focuses on analyzing marketing email interactions for IHG (InterContinental Hotels Group) to predict customer engagement through email clicks. The insights derived from this analysis allow IHG to better tailor their email marketing strategies, leading to more effective campaigns and improved cost-benefit analysis.

Problem Statement
IHG sends marketing emails to customers but lacks visibility into whether recipients click on offer links within the emails. This analysis aims to solve that problem by identifying the factors that influence whether a customer clicks on an email link. These insights help IHG improve their marketing strategies and optimize their marketing budget.

Dataset
The dataset provided by IHG contained three unjoined tables:

Member Details: 1.3 million records, 11 variables.
Stay History: 4.8 million records, 17 variables.
Email History: 192,000 records, 8 variables.
Data Challenges:
Data anomalies, such as enrollment dates before the program’s inception.
A significant imbalance in the target variable (whether a link was clicked), with only 0.9% of emails showing clicks.
Approach
The project had three main goals:

Recency: How recently a customer clicked or received an email.
Frequency: How many emails a customer received versus how many were clicked.
Monetary Value: How much revenue or time the customer spent as a result of the emails.
Feature Engineering
Using the provided data, I created 298 new variables. These variables were grouped into categories, including time, frequency, and monetization, with the aim of improving model accuracy.

Models Used
Several models were tested and evaluated based on key performance metrics:

Decision Tree
Naïve Bayes
Logistic Regression
Gradient-Boosted Trees (XGBoost)
Model Evaluation Metrics:
Precision: Logistic Regression performed best.
Recall: XGBoost performed best.
F1-Score: Decision Tree performed best.
AUC: XGBoost performed best for distinguishing between clicks and non-clicks.
Key Insights
The most important features for predicting whether a customer would click on an email were:

Days Since Last Click
Member Click Rate
Member Age Group
Member Lifecycle
Member Tier
Campaign Category
Email Send Date
The XGBoost model identified additional important variables such as Member Income Group and Member Enroll Channel.

Recommendations
Model Selection: Based on performance, the XGBoost Decision Tree is recommended for predicting email clicks, as it provides valuable insights into customer behavior that can be used to enhance email marketing campaigns.
Targeting Strategy: IHG can optimize email campaigns by targeting customers who meet specific criteria, such as those who clicked within the last 43 days and received a campaign email on a weekday.
Conclusion
This analysis provides actionable insights for IHG, enabling them to tailor their marketing emails more effectively and optimize their marketing spend. By using the XGBoost model, IHG can predict email click behavior and target customers more accurately, leading to improved engagement and higher returns.
