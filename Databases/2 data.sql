use SnapDB 
go
delete Family
go
insert Family(FamilyName, PhoneNumber, Address, FamilySize, EarnedIncome, UnEarnedIncome, DaycareExpenses, ShelterExpenses, StandardisedUtilityExpenses)
 select 'Smith', '7329011234', '1 Happy Lane', 4, 2500, 500, 180, 900, 548 
union select 'Adams', '7329420987', '2 Joyous Drive', 8, 5400, 1200, 360, 1750, 548
union select 'Jackson', '8482268765', '3 Momentous Place', 2, 1500, 1000, 0, 1000, 29
union select 'Tyler', '7328866543', '4 Drake Road', 3, 3000, 1200, 400, 1800, 548
union select 'Buchanan', '7329942345', '5 Hickory Drive', 15, 10000, 0, 810, 2250, 548
union select 'Arthur', '8482109843',  '6 Misory Lane', 1, 9870, 0, 0, 670, 29
union select 'Wilson', '7322908764', '7 Smoke Lane', 3, 1500, 301, 230, 1000, 369
union select 'Hoover', '7325432109', '8 Justice Place', 7, 3434, 3434, 343, 1343, 548
union select 'Truman', '7329942210', '9 Yorktown Blvd', 5, 4500, 1200, 400, 1800, 548
union select 'Johnsohn', '7329987654', '10 Branchtown Road', 10, 10000, 500, 510, 1200, 548
union select 'Nixon', '7328864325', '11 Letsgo Place', 5, 400, 600, 300, 1150, 369
union select 'Carter', '7329909990', '12 Bored Town Road', 2, 2000, 500, 0, 1150, 369
union select 'Biden', '8489989876', '13 Icantthink Lane', 13, 9950, 100, 0, 1800, 548
union select 'Cohen', '7327654321', '14 Winya Place', 9, 6000, 1300, 400, 275, 369
go

update Family set NetIncomeAfterShelter = case when NetIncomeBeforeShelter -((StandardisedUtilityExpenses  + ShelterExpenses) - (NetIncomeBeforeShelter/2)) > 0 or  NetIncomeBeforeShelter - StandardisedUtilityExpenses - ShelterExpenses > 0
                                            then case
                                                when  (StandardisedUtilityExpenses + ShelterExpenses)/ NetIncomeBeforeShelter > 0.5
                                                then  NetIncomeBeforeShelter -((StandardisedUtilityExpenses  + ShelterExpenses) - (NetIncomeBeforeShelter/2))
                                                else  NetIncomeBeforeShelter - StandardisedUtilityExpenses - ShelterExpenses  
                                                end
                                            else 0 
                                        end
GO

update Family set ThirtyPercentNetIncomeAfterShelter = NetIncomeAfterShelter * 0.3

update Family set BenefitAmount = case when MaximumBenefit - ThirtyPercentNetIncomeAfterShelter > 0 then MaximumBenefit - ThirtyPercentNetIncomeAfterShelter else 0 end
   
update Family set Eligible = case when TotalIncome  < MonthlyIncomeLimit and BenefitAmount > 0 then 1 else 0 end

select *
from Family