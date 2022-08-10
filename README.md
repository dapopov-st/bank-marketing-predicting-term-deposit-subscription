# Bank Marketing Campaign: Predicting Term Deposit Subscriptions
- RShiny app that can be used by a bank employee is deployed [here](https://dpopovvelasco.shinyapps.io/BankMarketingApp/) and a presentation is found [here](https://drive.google.com/file/d/1uv1JDQV1Ckh6hukaakFhP_SEgD5UR4Pp/view?usp=sharing)
- The data for this project is the UCI direct marketing campaigns data of a Portuguese banking institution. It can be accessed [here](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing#). The goal is to predict term deposit subscription following a sales call.  A random forest model performed best and is used to maximize recall.  To reproduce the analyses, place the data in the data directory and run the R file found in the RFs directory.

## Main Takeaways

- Adopt the ML strategy if long-term customer value and intangible costs are a significant concern and campaign resources are limited. This will allow getting 63% of all potential yeses at low cost.
   - Try to reach out to these customers in April, March, October, September, or December
   - After these customers are contacted, design a different product that would have a higher success rate with the remainder of potential contacts
- Adopt a mixed strategy of contacting clients for which the model predicts their probability of saying a yes as at least 30% if intangible costs and campaign resources are moderate. This will allow getting 80% of all potential yeses at moderate cost.
- Adopt a strategy of contacting all customers if have large campaign resources, are less concerned with intangible costs, and the cost of missing some of the yeses is particularly high. This will allow getting 100% of all potential yeses at higher cost.


## Future Work

- Call direction (inbound vs outbound) is not available in the UCI dataset and would be very helpful to have for the business.  Moro et al. had this feature and found it to be the most important feature after the Euribor 3-month rate.
- Having the dates from Euribor 3-month rate would allow one to perform separate analyses for pre- and post-financial crisis or get a more accurate overall model.  Also, could build more reliable validation and test sets (Euribor 3m rates alone cannot be used to reliably deduce dates).
- What other data can be obtained to allow us to build a better model? 
   - Could we do some quality assurance on the calls using NLP to detect the sentiment in the call and the variation in this sentiment throughout the call?
   - Could we use the data to match our ‘no’ customers with a more appropriate product?
- Use A/B Testing with profit per person metric to compare model performance in real life. 
   - Which strategy works best given the bank’s profitability and long-term customer value metrics?
   - Monitor for model drift
