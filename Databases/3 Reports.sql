
--   1) We need a list of eligible families showing their Name, Address and Benefit amount.
select f.FamilyName, f.Address, f.BenefitAmount
from Family F 
where f.Eligible = 1

--    2) We need a list of all ineligible families showing their Name, Address and Benefit amount.
select f.FamilyName, f.Address, f.BenefitAmount
from Family F 
where f.Eligible = 0

--    3) We need a count of all applicants who were under the income limit for their familys size but found not eligible for benefits.
select count = count(*)
from Family f 
where f.Eligible = 0 and f.MonthlyIncomeLimit > f.TotalIncomeExcludeExpenses

--    4) We need a count of the number of applicants whose unearned income is greater than their earned income.
select count = count(*)
from Family F 
where f.EarnedIncome < f.UnEarnedIncome

--    5) During Covid eligible families are being given the maximum benefit for their family size every month regardless of their actual benefit amount as long as they are eligible for $1 or more. 
--      Can you give us a list of all eligible families, including their real benefit amount, the maximun benefit for their family size and the amount of extra benefits they recieve each month due to covid.
select f.FamilyName, f.BenefitAmount, f.MaximumBenefit, ExtraBenefitReceive = f.MaximumBenefit - f.BenefitAmount
from Family F 
where f.Eligible = 1 
