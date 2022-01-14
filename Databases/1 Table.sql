use SnapDB
go

drop table if exists Family
go
create table dbo.Family(
    FamilyId int not null identity primary key,
    FamilyName varchar(100) not null constraint ck_Family_FamilyName_cannot_be_blank check (FamilyName <> ''),
    PhoneNumber char(10) not null constraint ck_Family_PhoneNumber_does_not_include_spaces check(PhoneNumber not like '% %'),
                                constraint ck_Family_PhoneNumber_only_includes_numbers check(isnumeric(PhoneNumber) = 1),
    Address varchar(100) not null constraint ck_Family_Address_cannot_be_blank check (Address <> ''),
    FamilySize int not null constraint ck_Family_FamilySize_between_1_and_17 check(FamilySize between 1 and 17),
    EarnedIncome int not null constraint ck_Family_EarnedIncome_between_0_and_25000 check(EarnedIncome between 0 and 25000),
    UnEarnedIncome int not null constraint ck_Family_UnEarnedIncome_Not_Negative check(UnEarnedIncome >= 0),
    DaycareExpenses int not null constraint ck_Family_DaycareExpenses_Not_Negative check(DaycareExpenses >= 0),
    ShelterExpenses int not null constraint ck_Family_ShelterExpenses_Not_Negative check(ShelterExpenses >= 0),
    StandardisedUtilityExpenses int not null constraint ck_Family_StandardisedUtilityExpenses_Not_Negative check(StandardisedUtilityExpenses >= 0),
    MonthlyIncomeLimit as case FamilySize 
                            when 1 then 1986  
                            when 2 then 2686  
                            when 3 then 3386  
                            when 4 then 4086  
                            when 5 then 4786  
                            when 6 then 5486  
                            when 7 then 6186  
                            when 8 then 6886  
                            when 9 then 7586  
                            when 10 then 8286  
                            when 11 then 8986  
                            when 12 then 9686  
                            when 13 then 10386 
                            when 14 then 11086 
                            when 15 then 11786 
                            when 16 then 12486 
                            when 17 then 13186 end persisted,
    MaximumBenefit as case FamilySize 
                            when 1 then 250  
                            when 2   then 459  
                            when 3   then 658  
                            when 4   then 835  
                            when 5   then 992  
                            when 6   then 119  
                            when 7   then 131  
                            when 8   then 150  
                            when 9   then 169  
                            when 10  then 188  
                            when 11  then 206  
                            when 12  then 225  
                            when 13  then 244  
                            when 14  then 263  
                            when 15  then 282  
                            when 16  then 281  
                            when 17  then 299  end persisted,
    StandardDeduction as case 
                    when FamilySize between 1 and 3 then 177
                    when FamilySize = 4 then 184
                    when FamilySize  = 5 then 215
                    else 246 end persisted,
    TotalIncomeExcludeExpenses as EarnedIncome + UnEarnedIncome persisted,
    GrossIncome as (EarnedIncome * 0.8) + UnEarnedIncome  persisted,
    NetIncomeBeforeShelter as case when ((EarnedIncome * 0.8) + UnEarnedIncome) -  case 
                    when FamilySize between 1 and 3 then 177
                    when FamilySize = 4 then 184
                    when FamilySize  = 5 then 215
                    else 246 end - DaycareExpenses > 0 then 
                    ((EarnedIncome * 0.8) + UnEarnedIncome) -  case 
                    when FamilySize between 1 and 3 then 177
                    when FamilySize = 4 then 184
                    when FamilySize  = 5 then 215
                    else 246 end - DaycareExpenses
                    else 0 end persisted,
    NetIncomeAfterShelter decimal(7,2) not null default 0,
    ThirtyPercentNetIncomeAfterShelter decimal(7,2) not null default 0,
    BenefitAmount decimal(5,2) not null default 0,
    Eligible bit not null default 0,
    constraint ck_Family_NetIncomeBeforeShelter_more_than_equal_NetIncomeAfterShelter check(NetIncomeBeforeShelter >= NetIncomeAfterShelter),
    constraint ck_Family_GrossIncome_more_than_equal_NetIncomeBeforeShelter check(GrossIncome >= NetIncomeBeforeShelter)

)
go
