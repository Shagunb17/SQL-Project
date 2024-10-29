alter table dim_repondents
add constraint fk_dim_respondents
foreign key(city_id) references dim_cities(city_id);


alter table fact_survey_responses
add constraint fk_fact_survey_responses
foreign key(respondent_id) references dim_repondents(respondent_id);

-- ___________________________________________________________________
-- 1. Who prefers energy drink more?

select gender,count(*) from dim_repondents
group by gender;

-- ___________________________________________________________________ 
-- 2.Which age group prefer energy drink more?

select age,count(age) from dim_repondents
group by age;

-- _________________________________________________________________________
-- 3.Which type of marketing reaches the most youth?(15-30)

select s.Marketing_channels,count(s.marketing_channels) from dim_repondents as d
join fact_survey_responses as s on d.respondent_id = s.respondent_id
where age between 15 and 30
group by s.Marketing_channels;

-- ______________________________________________________________________
-- 4.What are the prefered ingredients of energy drinks among respondents?

select fact_survey_responses.Ingredients_expected, count(fact_survey_responses.ingredients_expected) as count from fact_survey_responses
group by fact_survey_responses.Ingredients_expected
order by 2 desc;

-- ________________________________________________________________________
-- 5.What packaging preferences do respondents have for energy drinks?

select fact_survey_responses.Packaging_preference, count(fact_survey_responses.Packaging_preference) as count from fact_survey_responses
group by fact_survey_responses.Packaging_preference
order by 2 desc;

-- ________________________________________________________________________
-- 6.Who are the current market leaders?

select fact_survey_responses.Current_brands, count(fact_survey_responses.Current_brands) as count from fact_survey_responses
group by fact_survey_responses.Current_brands
order by count desc;

-- _____________________________________________________________________________
-- 7.What are the primary reasons consumer prefer those brands over ours?

select fact_survey_responses.Reasons_for_choosing_brands, count(fact_survey_responses.Reasons_for_choosing_brands) as count from fact_survey_responses
group by fact_survey_responses.Reasons_for_choosing_brands
order by 2 desc;

-- _____________________________________________________________________________
-- 8.Which marketing channel can be used to reach more customers? 
select fact_survey_responses.Marketing_channels, count(fact_survey_responses.Marketing_channels) as count from fact_survey_responses
group by fact_survey_responses.Marketing_channels
order by 2 desc;

-- _____________________________________________________________________________
-- 9.How effective are different marketing strategies and channels in reaching our customers?

select fact_survey_responses.Marketing_channels, count(fact_survey_responses.Marketing_channels) as count,
fact_survey_responses.Limited_edition_packaging,
Packaging_preference
from fact_survey_responses
group by fact_survey_responses.Marketing_channels,Limited_edition_packaging,Packaging_preference
order by 2 desc,1 desc;

-- _________________________________________________________________________________
-- 10. What do people think about our brand? (overall rating) 

select Brand_perception, count(Brand_perception) as Brand_rating
from fact_survey_responses
group by Brand_perception
order by Brand_rating desc;

-- _________________________________________________________________________________
-- 11. Which cities do we need to focus more on?

select c.city,count(r.respondent_id),c.Tier
from 
dim_cities c join dim_repondents r on c.city_id = r.city_id 
group by c.city,c.Tier
order by 2,3;

 -- ___________________________________________________________________________________
-- 12. Where do respondents prefer to purchase energy drinks?

select purchase_location , count(purchase_location) from
fact_survey_responses
group by Purchase_location; 

-- ____________________________________________________________________________________
-- 13. What are the typical consumption situations for energy drinks among respondents?

select Typical_consumption_situations, count(Typical_consumption_situations) from fact_survey_responses
group by Typical_consumption_situations;

-- _________________________________________________________________________________
-- 14. What factors influence respondents purchase decisions, such as price range and limited edition packaging? 

select fact_survey_responses.Price_range,fact_survey_responses.Limited_edition_packaging,count(*),Consume_reason
from fact_survey_responses
group by Price_range,Limited_edition_packaging,Consume_reason
order by count(*) desc;

-- _____________________________________________________________________________________
-- 15. Which area of business should we focus more on our product development? (Branding/taste/availability) 

select fact_survey_responses.Improvements_desired,count(fact_survey_responses.Improvements_desired)
from fact_survey_responses
group by Improvements_desired
order by 2 desc;

-- _______________________________________________________________________________________
-- 16. What immediate improvements can we bring to the product? 

select fact_survey_responses.Improvements_desired,count(fact_survey_responses.Improvements_desired)
from fact_survey_responses
group by Improvements_desired
order by 2 desc;

-- ________________________________________________________________________________________
-- 17.What should be the ideal price of our product?
 
select fact_survey_responses.Price_range, count(fact_survey_responses.Price_range)
from fact_survey_responses
group by Price_range
order by 2 desc;

-- ______________________________________________________________________________________
-- 18.What kind of marketing campaigns, offers, and discounts we can run? 

select fact_survey_responses.Marketing_channels,count(fact_survey_responses.marketing_channels)
from fact_survey_responses
group by fact_survey_responses.Marketing_channels
order by 2 desc;

select fact_survey_responses.Packaging_preference,count(fact_survey_responses.Packaging_preference)
from fact_survey_responses
group by Packaging_preference
order by 2 desc;

select fact_survey_responses.Improvements_desired,count(fact_survey_responses.Improvements_desired)
from fact_survey_responses
group by Improvements_desired
order by 2 desc;

-- ________________________________________________________________________________________________
-- 19.Who should be our target audience, and why? 

select dim_repondents.Age,count(dim_repondents.Age)
from dim_repondents
group by age
order by 2 desc;

-- ____________________________________________________________________________________________________






























