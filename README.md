#Bank Marketing Campaign: Predicting Term Deposit Subscriptions
- RShiny app that can be used by a bank employee is deployed [here](https://dpopovvelasco.shinyapps.io/BankMarketingApp/) and a presentation is found [here](https://drive.google.com/file/d/1uv1JDQV1Ckh6hukaakFhP_SEgD5UR4Pp/view?usp=sharing)
- The data for this project is the UCI direct marketing campaigns data of a Portuguese banking institution. It can be accessed [here](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing#). The goal is to predict term deposit subscription following a sales call.  A random forest model is used to maximize recall.

## Main Takeaways

- Adopt the ML strategy if long-term customer value and intangible costs are a significant concern and campaign resources are limited. This will allow getting 63% of all potential yeses at low cost.
 - Try to reach out to these customers in April, March, October, September, or December
- After these customers are contacted, design a different product that would have a higher success rate with the remainder of potential contacts
 - Adopt a mixed strategy of contacting clients for which the model predicts their probability of saying a yes as at least 30% if intangible costs and campaign resources are moderate. This will allow getting 80% of all potential yeses at moderate cost.
- Adopt a strategy of contacting all customers if have large campaign resources, are less concerned with intangible costs, and the cost of missing some of the yeses is particularly high. This will allow getting 100% of all potential yeses at higher cost.

