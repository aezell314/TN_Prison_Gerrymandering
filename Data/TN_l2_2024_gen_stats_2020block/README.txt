
L2 Voter File 2024 General Elections Turnout Statistics for Tennessee, aggregated to the 2020 Census block (GEOID20)

## Sources
- The Redistricting Data Hub purchased this Voter File from L2, a national Voter File vendor: https://l2-data.com/
- L2 voter file snapshot (Tennessee): L2 retrieved this voter file data from the state on 2025-02-25.
  This data includes counts of registered voters as of that snapshot and their turnout in the November 05, 2024 general election.
- RDH block assignment to aggregate individuals to 2020 Census blocks

## What this file contains
Aggregates of individual-level L2 records to blocks (GEOID20), reporting **counts** and **turnout rates** by:
- Gender (Male, Female, Unknown)
- Age groups (10 categories)
- Party (Democratic, Republican, Independent/Non-Partisan, other parties)
- Race/ethnicity (L2 modeled EthnicGroups_EthnicGroup1Desc plus self-reported African or African-American category when available)
- Race × Party 

Turnout metrics:
- `voted_*`: number of people who voted in the 2024-11-05 general election
- `reg_*`: number of people who are registered in that subgroup on the L2 file (denominator)
- `pct_voted_*`: `voted / reg` (rounded to 4 decimals)

**Important:** L2 ethnicity categories use modeling techniques to infer an individual's ethnicity. Self-reported fields come directly from voter-provided descriptions when present.


## Fields

Field Name                              Description
geoid20                                 15-digit Census Block GEOID20 (2020)
voted_all                               Number of people who voted (all registered voters)
reg_all                                 Number of people who registered (all registered voters)
pct_voted_all                           Turnout rate (voted / registered, all)
voted_gender_male                       Number of people who voted (gender = Male)
reg_gender_male                         Number of people who registered (gender = Male)
pct_voted_gender_male                   Turnout rate (gender = Male)
voted_gender_female                     Number of people who voted (gender = Female)
reg_gender_female                       Number of people who registered (gender = Female)
pct_voted_gender_female                 Turnout rate (gender = Female)
voted_gender_unknown                    Number of people who voted (gender = Unknown)
reg_gender_unknown                      Number of people who registered (gender = Unknown)
pct_voted_gender_unknown                Turnout rate (gender = Unknown)
voted_age_18_19                         Number of people who voted (between the ages of 18 and 19)
reg_age_18_19                           Number of people who registered (between the ages of 18 and 19)
pct_voted_age_18_19                     Turnout rate (between the ages of 18 and 19)
voted_age_20_24                         Number of people who voted (between the ages of 20 and 24)
reg_age_20_24                           Number of people who registered (between the ages of 20 and 24)
pct_voted_age_20_24                     Turnout rate (between the ages of 20 and 24)
voted_age_25_29                         Number of people who voted (between the ages of 25 and 29)
reg_age_25_29                           Number of people who registered (between the ages of 25 and 29)
pct_voted_age_25_29                     Turnout rate (between the ages of 25 and 29)
voted_age_30_34                         Number of people who voted (between the ages of 30 and 34)
reg_age_30_34                           Number of people who registered (between the ages of 30 and 34)
pct_voted_age_30_34                     Turnout rate (between the ages of 30 and 34)
voted_age_35_44                         Number of people who voted (between the ages of 35 and 44)
reg_age_35_44                           Number of people who registered (between the ages of 35 and 44)
pct_voted_age_35_44                     Turnout rate (between the ages of 35 and 44)
voted_age_45_54                         Number of people who voted (between the ages of 45 and 54)
reg_age_45_54                           Number of people who registered (between the ages of 45 and 54)
pct_voted_age_45_54                     Turnout rate (between the ages of 45 and 54)
voted_age_55_64                         Number of people who voted (between the ages of 55 and 64)
reg_age_55_64                           Number of people who registered (between the ages of 55 and 64)
pct_voted_age_55_64                     Turnout rate (between the ages of 55 and 64)
voted_age_65_74                         Number of people who voted (between the ages of 65 and 74)
reg_age_65_74                           Number of people who registered (between the ages of 65 and 74)
pct_voted_age_65_74                     Turnout rate (between the ages of 65 and 74)
voted_age_75_84                         Number of people who voted (between the ages of 75 and 84)
reg_age_75_84                           Number of people who registered (between the ages of 75 and 84)
pct_voted_age_75_84                     Turnout rate (between the ages of 75 and 84)
voted_age_85over                        Number of people who voted (age 85 or older)
reg_age_85over                          Number of people who registered (age 85 or older)
pct_voted_age_85over                    Turnout rate (age 85 or older)
voted_party_democratic                  Number of people who voted (party = Democratic)
reg_party_democratic                    Number of people who registered (party = Democratic)
pct_voted_party_democratic              Turnout rate (party = Democratic)
voted_party_republican                  Number of people who voted (party = Republican)
reg_party_republican                    Number of people who registered (party = Republican)
pct_voted_party_republican              Turnout rate (party = Republican)
voted_party_ind_npp                     Number of people who voted (party = Independent or Non-Partisan)
reg_party_ind_npp                       Number of people who registered (party = Independent or Non-Partisan)
pct_voted_party_ind_npp                 Turnout rate (party = Independent or Non-Partisan)
voted_party_others                      Number of people who voted (party = other parties)
reg_party_others                        Number of people who registered (party = other parties)
pct_voted_party_others                  Turnout rate (party = other parties)
voted_eur                               Number of people who voted (race = European)
reg_eur                                 Number of people who registered (race = European)
pct_voted_eur                           Turnout rate (race = European)
voted_hisp                              Number of people who voted (race = Hispanic & Portuguese)
reg_hisp                                Number of people who registered (race = Hispanic & Portuguese)
pct_voted_hisp                          Turnout rate (race = Hispanic & Portuguese)
voted_aa                                Number of people who voted (race = Likely African-American)
reg_aa                                  Number of people who registered (race = Likely African-American)
pct_voted_aa                            Turnout rate (race = Likely African-American)
voted_esa                               Number of people who voted (race = East & South Asian)
reg_esa                                 Number of people who registered (race = East & South Asian)
pct_voted_esa                           Turnout rate (race = East & South Asian)
voted_oth                               Number of people who voted (race = Other)
reg_oth                                 Number of people who registered (race = Other)
pct_voted_oth                           Turnout rate (race = Other)
voted_unk                               Number of people who voted (race = Unknown)
reg_unk                                 Number of people who registered (race = Unknown)
pct_voted_unk                           Turnout rate (race = Unknown)
voted_self_afam                         Number of people who voted (race = Self-reported African-American)
reg_self_afam                           Number of people who registered (race = Self-reported African-American)
pct_voted_self_afam                     Turnout rate (race = Self-reported African-American)
voted_self_afam_party_democratic        Number of people who voted (self-reported African-American, party = Democratic)
reg_self_afam_party_democratic          Number of people who registered (self-reported African-American, party = Democratic)
pct_voted_self_afam_party_democratic    Turnout rate (self-reported African-American, party = Democratic)
voted_self_afam_party_republican        Number of people who voted (self-reported African-American, party = Republican)
reg_self_afam_party_republican          Number of people who registered (self-reported African-American, party = Republican)
pct_voted_self_afam_party_republican    Turnout rate (self-reported African-American, party = Republican)
voted_self_afam_party_ind_npp           Number of people who voted (self-reported African-American, party = Independent or Non-Partisan)
reg_self_afam_party_ind_npp             Number of people who registered (self-reported African-American, party = Independent or Non-Partisan)
pct_voted_self_afam_party_ind_npp       Turnout rate (self-reported African-American, party = Independent or Non-Partisan)
voted_self_afam_party_others            Number of people who voted (self-reported African-American, party = other parties)
reg_self_afam_party_others              Number of people who registered (self-reported African-American, party = other parties)
pct_voted_self_afam_party_others        Turnout rate (self-reported African-American, party = other parties)

## Processing Notes
- L2 provides individual address data for every voter on their voter file. 
- Many of the voters contain latitude/longitude data. The RDH assigns 2020 Census blocks to voters containing latitude/longitude data by spatially joining the points with Census block files. 
- The individual data is aggregated to the block-level by grouping by block assignments. Individuals who could not be assigned a Census block because of missing latitude/longitude were assigned NO ASSIGNMENT - [county fips code assignment]" and therefore reported as county aggregates in the geoid20 column.

## Additional Notes 
The fields in this file correspond to those voters registered to vote on the L2 voter file at their residence as of the date above. 
The vote history fields are tied to individual voters, then aggregated up but not tied to geographies as a whole. As such, the aggregated data show whether or not voters in the geography voted anywhere on the election date, not necessarily specifically in that area. 
This can be used to approximate how the population in the geography voted historically as a distributed group, but cannot be used to track how individuals in that geography voted at the time of previous elections. 
For snapshots from previous voter files, please reference previous voter files hosted by the RDH. 

The RDH cannot certify the accuracy of any of the information contained within this file.

**Ethnicity fields:** L2 modeled ethnicity uses modeling techniques to infer an individual's ethnicity. Self-reported categories come directly from voter-provided descriptions when available.
Please see the attached PDF for more information about L2's ethnicity fields. 

Please contact info@redistrictingdatahub.org for more information. 
