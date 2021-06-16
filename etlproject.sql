/* Created a number of views so that we could run the queries we were interested in*/

--reduces down so there are only unique states and creates a new view with only the unique states

CREATE OR REPLACE VIEW locations AS 
SELECT DISTINCT state_alpha, country_name, country_code, state_name, state_fips_code  
FROM LOCATION
ORDER BY state_alpha; 

--creates a new view that adds the region based on what state they're in using CASE. Each state is separated into its appropriate category while anything that is not a state
-- is classified as 'undefined'. 

CREATE OR REPLACE VIEW region AS
SELECT country_name, country_code, state_name, state_alpha, state_fips_code,  
CASE 
WHEN state_alpha IN ('DE', 'MD', 'VA', 'WV', 'KY', 'NC', 'SC', 'TN' , 'GA', 'FL', 'AL', 'MS', 'AR', 'LA' ) THEN 'South'
WHEN state_alpha IN ('ID',  'AZ', 'UT', 'NV', 'CA', 'OR', 'WA', 'AK', 'HI') THEN 'Pacific'
WHEN state_alpha IN ('MA', 'NH', 'VT', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA', 'ME') THEN 'Northeast'
WHEN state_alpha IN ('MT', 'ND', 'SD', 'WY',  'NE', 'KS' , 'CO',  'TX', 'OK', 'NM') THEN 'Plains'
WHEN state_alpha IN ('OH', 'MI', 'IN', 'WI', 'IL', 'MN', 'IA', 'MO') THEN 'Midwest'
ELSE 'undefined' END AS region
FROM locations;

/* What are the percentages of bee colonies effected by colony collapse disorder for the year 2020? */

SELECT l.state_alpha, p.marketing_id, p.year, ((ccd.value::float/i.value::float)*100) AS ccd_percentage 
FROM colony_collapse_disorder ccd
INNER JOIN inventory_max i
ON ccd.marketing_id = i.marketing_id
INNER JOIN location l
ON ccd.marketing_id = l.marketing_id
INNER JOIN period p
ON ccd.marketing_id = p.marketing_id
WHERE p.year = 2020
GROUP BY 1,2,3,4
ORDER BY 1, 2 desc 

/* Compare all of the bee colony disorders for the year 2020 by survey.*/

SELECT l.state_alpha, p.marketing_id, p.year, ((ccd.value::float/i.value::float)*100) AS ccd_perc, d.value AS disease_perc, vm.value AS varroa_mites_perc, pe.value AS pests_perc, pds.value AS pesticides_perc, oc.value AS other_causes_perc, uc.value AS unknown_causes_perc 
FROM colony_collapse_disorder ccd
FULL OUTER JOIN inventory_max i
ON ccd.marketing_id = i.marketing_id
FULL OUTER JOIN location l
ON ccd.marketing_id = l.marketing_id
FULL OUTER JOIN period p
ON ccd.marketing_id = p.marketing_id
FULL OUTER JOIN disease d
ON ccd.marketing_id = d.marketing_id
FULL OUTER JOIN varroa_mites vm
ON ccd.marketing_id = vm.marketing_id
FULL OUTER JOIN pests pe
ON ccd.marketing_id = pe.marketing_id
FULL OUTER JOIN pesticides pds
ON ccd.marketing_id = pds.marketing_id
FULL OUTER JOIN other_causes oc
ON ccd.marketing_id = oc.marketing_id
FULL OUTER JOIN unknown_causes uc
ON ccd.marketing_id = uc.marketing_id
WHERE p.year = 2020
GROUP BY 1,2,3,4, 5, 6, 7, 8, 9, 10
ORDER BY 1, 2 desc 

/* What are the top three issues facing MO? */

SELECT l.state_alpha, p.marketing_id, p.year, ((ccd.value::float/i.value::float)*100) AS ccd_perc, d.value AS disease_perc, vm.value AS varroa_mites_perc, pe.value AS pests_perc, pds.value AS pesticides_perc, oc.value AS other_causes_perc, uc.value AS unknown_causes_perc 
FROM colony_collapse_disorder ccd
FULL OUTER JOIN inventory_max i
ON ccd.marketing_id = i.marketing_id
JOIN location l
ON ccd.marketing_id = l.marketing_id
JOIN period p
ON ccd.marketing_id = p.marketing_id
FULL OUTER JOIN disease d
ON ccd.marketing_id = d.marketing_id
FULL OUTER JOIN varroa_mites vm
ON ccd.marketing_id = vm.marketing_id
FULL OUTER JOIN pests pe
ON ccd.marketing_id = pe.marketing_id
FULL OUTER JOIN pesticides pds
ON ccd.marketing_id = pds.marketing_id
FULL OUTER JOIN other_causes oc
ON ccd.marketing_id = oc.marketing_id
FULL OUTER JOIN unknown_causes uc
ON ccd.marketing_id = uc.marketing_id
WHERE p.year = 2020 AND l.state_alpha = 'MO'
GROUP BY 1,2,3,4, 5, 6, 7, 8, 9, 10
ORDER BY 1, 2 desc 

-- For survey Jan-March the top three were: varroa mites, pests, and unknown causes.  For the survey April - June the top three were: varroa mites, other causes and disease.
 
/* What region has the highest rates of varroa mites?*/
--The values are in percentages so we are taking the average percentages of the regions using the avg aggregate function. We join region and period on the state name and 
-- join varroa mites to period based on the marketing id. We isolate it to only year 2020 and use group by since we did an aggregate function. 

SELECT round(avg(vm.value)::numeric,2) AS avg_percent, vm.unit_desc, vm.short_desc,  r.region
FROM region r
LEFT JOIN period pd
ON r.state_name = pd.state_name
JOIN varroa_mites vm
ON pd.marketing_id = vm.marketing_id
WHERE pd.year = 2020
GROUP BY vm.unit_desc, vm.short_desc, r.region
ORDER BY 1 desc

30.28	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"Pacific"
29.48	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"South"
20.06	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"Midwest"
18.69	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"Plains"
13.79	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"Northeast"
11.15	"PCT OF COLONIES"	"HONEY, BEE COLONIES, AFFECTED BY VARROA MITES - INVENTORY, MEASURED IN PCT OF COLONIES"	"undefined"
 
/*What are the top five states with colony collapse disorder overall in 2019 and 2020?*/ 

/*2020*/

SELECT SUM(ccd.value) AS total_value, ccd.unit_desc, pd.state_name 
FROM colony_collapse_disorder AS ccd
INNER JOIN period AS pd
ON ccd.marketing_id = pd.marketing_id
WHERE pd.year = 2020
GROUP BY ccd.unit_desc, pd.state_name
ORDER BY 1 desc
LIMIT 5

403000	"COLONIES"	"FLORIDA"
288600	"COLONIES"	"CALIFORNIA"
255000	"COLONIES"	"NORTH DAKOTA"
153400	"COLONIES"	"GEORGIA"
107900	"COLONIES"	"TEXAS"

/*2019*/

SELECT SUM(ccd.value) AS total_value, ccd.unit_desc, pd.state_name 
FROM colony_collapse_disorder AS ccd
INNER JOIN period AS pd
ON ccd.marketing_id = pd.marketing_id
WHERE pd.year = 2019
GROUP BY ccd.unit_desc, pd.state_name
ORDER BY 1 desc
LIMIT 5

578500	"COLONIES"	"CALIFORNIA"
283400	"COLONIES"	"GEORGIA"
258700	"COLONIES"	"FLORIDA"
221000	"COLONIES"	"WASHINGTON"
136500	"COLONIES"	"NORTH DAKOTA"

/*6) Compare pests with varroa mites, do higher mites mean less pests?*/

SELECT p.marketing_id, p.year, r.state_name, vm.value AS Varroa_mites, pe.value AS pests, 
CASE
WHEN vm.value > pe.value THEN 'More Varroa Mites'
WHEN pe.value > vm.value THEN 'More Pests'
ELSE 'equal Pests and Varroa Mites' END AS most_pest
FROM period p 
JOIN region r
ON p.state_name = r.state_name
JOIN varroa_mites vm
ON p.marketing_id = vm.marketing_id
JOIN pests pe
ON p.marketing_id = pe.marketing_id
WHERE year = 2020
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY 3, 1 desc