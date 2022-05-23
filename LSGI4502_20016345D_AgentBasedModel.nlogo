; 2021-2022 LSGI4502 Final Year Project (Part A and B)
; Tang Justin Hayse Chi Wing G.  20016345D
; BSc(Hons) in Land Surveying and Geo-informatics (34478)
; Supervisor: Dr. Zhuge Cheng-xiang, Tony
; NetLogo Programming for Simulating The Adoption of Smart Mobility Technologies in Beijing
; Two main adoptions: (1.1) Purchasing either AV, EV, AEV or CV
;                     (1.2) For EV and VEV user, whether adopt Vehicle-to-Grid (V2G)
;                     (2.1) Interested in Mobility-as-a-Service (MaaS)?
;                     (2.2) Pay-as-you-go, Monthly Subscription, Season Subscription, Yearly Subscription
;                     (3)   The Adoption of AV/EV/AEV/CV + MaaS

extensions [gis] ; GIS extension provides GIS support

globals [; global variables
  agent-dataset ; the shapefile of the agents (in point feature)
  beijing-dataset ; the shapefile of the Beijing, divided by 16 administrative regions
  number
  m
  n
  year
  year1 ; the simulation year
]

patches-own [; The Patches on the NetLogo Environment
  random-n
  centroid
  ID
]

; Setting the attributes of the agents
turtles-own [ ; The attributes of the agents
  gender ; if female then 0; if male then 1
  age ;if <18, then 1 ; if 18-24 then 2, if 25-34, then 3; if 35-44 then 4; if 45-54 then 5; if 55-65 then 6; if >65 then 7
  income ;if xxxx
  Education ; if xxxx
  License ; if no driving license then 0; if have a driving license then 1
  expendiure ; xxxx
  household
  vehicle ;if no car then 0; if own a car then 1
  mfriends ;an agent will adopt MaaS when his/her friend(s) using MaaS, then 1; if not, then 0
  mneighbour ;an agent will adopt MaaS when his/her neighbour(s) using MaaS then 1; if not, then 0
  mAdv ;an agent will adopt MaaS when he/she is influenced by MaaS adverstisment, then 1; if not, then 0
  MaaS-familiarity ;if not familar, then 1; if know a little bit, then 2, if familiar with MaaS, then 3
  MaaS ;MaaS Interest; if not interested, then 1; if not very interest, then 2; if interested, then 3; if very interested, then 4
  MaaS-payment ;Characteristics of MaaS; if concerned about one-off payment, then 1
  MaaS-interface ;Characteristics of MaaS; if concerned about single interface, then 1
  MaaS-personalization ;Characteristics of MaaS; if concerned about personalization, then 1
  MaaS-subscription ;Characteristics of MaaS; if concerned about subscription plan, then 1
  MaaS-traffic ;Characteristics of MaaS; if concerned about MaaS traffic improvement, then 1
  MaaS-environment ;Characteristics of MaaS; if concerned about environmental benefits, then 1
  MaaS-privacy ;Characteristics of MaaS; if concerned about privacy concerns, then 1
  MaaS-influence ;qualifying the social influence (friends, neighbours and advertisment)
  MaaS-friends ;if an agent's friend(s) using MaaS, then 1
  MaaS-neighbour ;if an agent's neighbour(s)using MaaS then 1
  MaaS-advertisment ;if an agents is influenced by MaaS advertisment, then 1
  MaaS-Payasyougo ;the preferred discount for MaaS Pay-as-you-go
  adopt-maas-payasyougo ;if the preferred discount >= provided discount, then 1
  MaaS-Monthly ;the preferred discount for MaaS Monthly Subscription Plan
  adopt-maas-monthly1 ;if the preferred discount >= provided discount, then 1
  MaaS-Seasonal ;the preferred discount for MaaS Season Subscription Plan
  adopt-maas-seasonal1 ;if the preferred discount >= provided discount, then 1
  MaaS-Yearly ;the preferred discount for MaaS Yearly Subscription Plan
  adopt-maas-yearly1 ;if the preferred discount >= provided discount, then 1
  SAV-Fam ; Familiarity of Shared Autonomous Vehicle; if familar SAV, then 1
  UseSAV ; SAV interest; ; if not interested, then 1; if not very interest, then 2; if interested, then 3; if very interested, then 4
  AVfriend ;an agent will adopt V2G when his/her friend(s) using PAV, then 1; if not, then 0
  AVneigh ;an agent will adopt V2G when his/her neighbour(s) using PAV then 1; if not, then 0
  AVAdv ;an agent will adopt MaaS when he/she is influenced by V2G adverstisment, then 1; if not, then 0
  AV-friends ;if an agent's friend(s) using PAV, then 1
  AV-neighbour ; if an agent's neighbour(s) have a PAV, then 1
  AV-advertisment ;if an agent is influenced by PAV advertisment
  PAV-influence ;qualifying the social influence (friends, neighbours and advertisment)
  CV ; if an agent has a CV, then 1; if not, then 0
  BEV ;if an agent has a BEV, then 1; if not, then 0
  PHEV ;if an agent has a PHEV, then 1; if not, then 0
  PAV ;if an agent has a PAV, then 1; if not, then 0
  AEV ; Assumed as zero (not yet commercially existed)
  V2G ; if an agent adopt V2G, then 1; if not, then 0
  BuyBEV ;the degree of buying a BEV; if an agent will not buy, then 1; may not buy, then 2; may buy, then 3; will buy, then 4
  BuyPHEV ;the degree of buying a PHEV; if an agent will not buy, then 1; may not buy, then 2; may buy, then 3; will buy, then 4
  BuyPAV ;the degree of buying a PAV; if an agent will not buy, then 1; may not buy, then 2; may buy, then 3; will buy, then 4
  BEVV2G ;willingness to adopt V2G with BEV; will not adopt, then 1; may not adopt, then 2; may adopt, then 3; will adopt, then 4
  p-bevv2g ;
  PHEVV2G ;willingness to adopt V2G with PHEV; will not adopt, then 1; may not adopt, then 2; may adopt, then 3; will adopt, then 4
  p-phevv2g
  bev-friend ;if an agent's friend(s) have a BEV, then 1
  bev-neighbor ; if an agent's neighbour(s) have a BEV, then 1
  bev-adv ;if an agent is influenced by BEV advertisment
  bev-influence ;qualifying the social influence (friends, neighbours and advertisment)
  v2g-friend ;if an agent's friend(s) using V2G, then 1
  v2g-neighbor ;if an agent's neighbours(s) using V2G, then 1
  v2g-adv  ;if an agent is influenced by V2G advertisment
  v2g-influence ;qualifying the social influence (friends, neighbours and advertisment)
  lottery_CV ;setting CV lottery plate
  lottery_AV ;setting AV lottery plate
  cost ;Characteristics of V2G; if concerned about cost reduction, then 1
  Environment ;Characteristics of V2G; if concerned about environmental benefits, then 1
  Grid ;Characteristics of V2G; if concerned about grid protection, then 1
  Battery ;Characteristics of V2G; if concerned about bettery degradation, then 1
  Driving ;Characteristics of V2G; if concerned about difficulty in driving range estimation, then 1
  Vfriend ;an agent will adopt V2G when his/her friend(s) using MaaS, then 1; if not, then 0
  Vneighbor ;an agent will adopt V2G when his/her neighbour(s) using MaaS then 1; if not, then 0
  Vadv ;;an agent will adopt MaaS when he/she is influenced by V2G adverstisment, then 1; if not, then 0
  eprice ;setting the preferred V2G Price
  Aprice ;setting the preferred AV Price
  line1 ;the social networks regarding buying an BEV
  line2 ;the social networks regarding buying an PAV
  line ;the spare socail network
  Afriends ;if an agent's friend(s) have an AV, then 1
  Aneighbour ;if an agent's neighbour(s) have an AV, then 1
  aadv ;if an agent is influenced by PAV advertisment
]

; Add the Beijing shapefile on NetLogo
to setup-map
  show "Loading Beijing Map......"
  set beijing-dataset gis:load-dataset "Beijing.shp"
  gis:set-world-envelope (gis:envelope-of beijing-dataset)
  let i 1
  foreach gis:feature-list-of beijing-dataset [ feature ->
    ask patches gis:intersecting feature [
      set centroid gis:location-of gis:centroid-of feature
      ask patch item 0 centroid item 1 centroid [
        set ID 1
      ]
     ]
      set i i + 1
  ]

;  gis:apply-coverage beijing-dataset "FID_2" ID
  gis:set-drawing-color magenta
  gis:draw beijing-dataset 1

; ask patches [
;    ifelse (ID > 0)
;      [ set pcolor pink ]
;      [ set pcolor blue ]
;  ]
end

to setup-rasterbackground
 ask patches
 [ set pcolor white ]
end

 to setup
  ; Exceuate the setup the following steps
  clear-all
  reset-ticks
  set year 2022
  set year1 2022
  setup-map
  setup-agents
  change-color
  setup-spatially-clustered-network
  ask links [hide-link]
end

to set-baseyear
  count-BEV-influence
  BEVLine
  count-MaaS-influence
  count-PAV-influence
  MaaSLine
  CV-Lottery
  PAV-Lottery
  AEVLine
end

to count-maas-influence ; compute the social influence of MaaS
 ask turtles [set maas-friends 0 set maas-neighbour 0 set maas-advertisment 0] ; intitially set agents' social circsumstance

  ask turtles[
    let n1 count in-link-neighbors with [MaaS >= 3] ; friendship effect
 if n1 > 0
 [set maas-friends 1]
    let n2 sum [count turtles-here with [MaaS >= 3] ] of neighbors in-radius 2; neighborhood effect
 if n2 > 0
 [set maas-neighbour 1]
  ]
 let n3 global-influence-advertising-MaaS * 21536  ; MaaS advertisement
 ask n-of n3 turtles [set MaaS-advertisment 1]
 ask turtles [set MaaS-influence (Mfriends * 2 * maas-friends + Mneighbour * 1 * maas-neighbour + MAdv * 1 * maas-advertisment)]
end

to count-PAV-influence ;the social influence and adoption intension of PAV
 ask turtles [set AV-friends 0 set AV-neighbour 0 set AV-advertisment 0]
  ask turtles [
    let n1 count in-link-neighbors with [BuyPAV >= 3] ; friendship effect
 if n1 > 0
 [set AV-friends 1]
    let n2 sum [count turtles-here with [BuyPAV >= 3] ] of neighbors in-radius 2 ; neighborhood effect
 if n2 > 0
 [set AV-neighbour 1]
  ]
 let n3 global-influence-advertising-AV * 21536 ; global influence: Advertisement
 ask n-of n3 turtles [set AV-advertisment 1]
 ; quantify the social influences
 ask turtles [set PAV-influence ( Afriends * 2 * AV-friends +  Aneighbour * 1 * AV-neighbour +  AAdv * 1 * AV-advertisment)]
end

to count-bev-influence ;HAVE
  ask turtles [ set bev-friend 0 set bev-neighbor 0 set bev-adv 0]
  ask turtles [
    let n1 count in-link-neighbors with [Bev = 1]
    if n1 > 0
    [set bev-friend 1]
    let n2 sum [ count turtles-here with [ BEV = 1 ] ] of neighbors in-radius 2
    if n2 > 0
    [ set bev-neighbor 1]
  ]
  let n3 advertising-bev * 21536
  ask n-of n3 turtles [ set bev-adv 1 ]
  ask turtles [ set bev-influence (Vfriend * 2 * bev-friend + Vneighbor * 1 * bev-neighbor + Vadv * 1 * bev-adv ) ]
end

to count-v2g-influence ;HAVE
  ask turtles [ set v2g-influence (Vfriend * 2 * V2G-Friend + Vneighbor * 1 * v2g-neighbor + Vadv * 1 * v2g-adv)]
end

to setup-agents
  set agent-dataset gis:load-dataset "LSGI4502_ALL_Data_UPDATED.shp"
  foreach gis:feature-list-of agent-dataset [
    vector-feature ->
    let coord-tuple gis:location-of (first (first (gis:vertex-lists-of vector-feature)))
    let gender1 gis:property-value vector-feature "Gender"
    let age1 gis:property-value vector-feature "Age"
    let income1 gis:property-value vector-feature "Income"
    let education1 gis:property-value vector-feature "EducationL"
    let drivinglicense1 gis:property-value vector-feature "Drivinglic"
    let expenditure1 gis:property-value vector-feature "Travelexpe"
    let MaaS-interest1 gis:property-value vector-feature "MInterest"
    let MaaS-familiarity1 gis:property-value vector-feature "MFam"
    let MaaS-payment1 gis:property-value vector-feature "Benefit_1"
    let MaaS-interface1 gis:property-value vector-feature "Benefit_2"
    let MaaS-personalization1 gis:property-value vector-feature "Benefit_3"
    let MaaS-subscription1 gis:property-value vector-feature "Benefit_4"
    let MaaS-traffic1 gis:property-value vector-feature "Benefit_5"
    let MaaS-environment1 gis:property-value vector-feature "Benefit_6"
    let MaaS-privacy1 gis:property-value vector-feature "Benefit_7"
    let mfriends1 gis:property-value vector-feature "MFriends"
    let mneighbour1 gis:property-value vector-feature "MNeigh"
    let madvertisment1 gis:property-value vector-feature "MAdv"
    let MaaS-payasyougo1 gis:property-value vector-feature "Sub_1"
    let MaaS-monthly1 gis:property-value vector-feature "Sub_2"
    let MaaS-seasonal1 gis:property-value vector-feature "Sub_3"
    let MaaS-yearly1 gis:property-value vector-feature "Sub_4"
    let SAVFam1 gis:property-value vector-feature "AFam"
    let useSAV1 gis:property-value vector-feature "UseSAV"
    let buyPAV1 gis:property-value vector-feature "BuyPAV"
    let buybev1 gis:property-value vector-feature "BuyBEV"
    let buyphev1 gis:property-value vector-feature "BuyPHEV"
    let cv1 gis:property-value vector-feature "CV"
    let bev1 gis:property-value vector-feature "BEV"
    let phev1 gis:property-value vector-feature "PHEV"
    let pav1 gis:property-value vector-feature "PAV"
    let aev1 gis:property-value vector-feature "AEV"
    let aprice1 gis:property-value vector-feature "Aprice"
    let afriend1 gis:property-value vector-feature "AFriend"
    let aneighbor1 gis:property-value vector-feature "ANeigh"
    let aadv1 gis:property-value vector-feature "AAdv"
    let cost1 gis:property-value vector-feature "Cost"
    let environment1 gis:property-value vector-feature "Environmen"
    let grid1 gis:property-value vector-feature "Grid"
    let battery1 gis:property-value vector-feature "Battery"
    let driving1 gis:property-value vector-feature "Driving"
    let bevv2g1 gis:property-value vector-feature "BEVV2G"
    let phevv2g1 gis:property-value vector-feature "PHEVV2G"
    let vfriend1 gis:property-value vector-feature "VFriend"
    let vneighbor1 gis:property-value vector-feature "VNeighbor"
    let vadv1 gis:property-value vector-feature "VAdv"
    let eprice1 gis:property-value vector-feature "EPrice"
    let household1 gis:property-value vector-feature "Househol"
    let long-coord item 0 coord-tuple
    let lat-coord item 1 coord-tuple

 set-default-shape turtles "person"
    create-turtles 1 [
    setxy long-coord lat-coord
    set Age age1
    set Gender gender1
    set Income income1
    set Education education1
    set License drivinglicense1
    set expendiure expenditure1
    set maas MaaS-interest1
    set MaaS-payment MaaS-payment1
    set MaaS-interface MaaS-interface1
    set MaaS-personalization MaaS-personalization1
    set MaaS-subscription MaaS-subscription1
    set MaaS-traffic MaaS-traffic1
    set MaaS-environment MaaS-environment1
    set MaaS-privacy MaaS-privacy1
    set MFriends mfriends1
    set Mneighbour mneighbour1
    set Madv madvertisment1
    set MaaS-payasyougo MaaS-payasyougo1
    set MaaS-monthly MaaS-monthly1
    set MaaS-seasonal MaaS-seasonal1
    set MaaS-yearly MaaS-yearly1
    set SAV-fam SAVFam1
    set UseSAV usesav1
    set BuyPAV buypav1
    set BuyBEV buybev1
    set BuyPHEV buyphev1
    set BEV bev1
    set PHEV phev1
    set PAV pav1
    set Aprice aprice1
    set Cost cost1
    set Environment environment1
    set Grid grid1
    set Battery battery1
    set Driving driving1
    set EPrice eprice1
    set BEVV2G bevv2g1
    set PHEVV2G phevv2g1
    set vFriend vfriend1
    set vNeighbor vneighbor1
    set vAdv vadv1
    set CV cv1 ;have
    set Afriends afriend1
    set Aneighbour aneighbor1
    set AAdv aadv1
    set household household1
    set line1 9999
    set line2 9999
  ]
]
  ask turtles [set size 0.5
    set color white]
end

to setup-spatially-clustered-network
  let num-links ( 12 * 21536) / 2
  while [count links < num-links ]
  [
    ask one-of turtles
    [
      let choice one-of (other turtles with [not link-neighbor? myself])

      if choice != nobody [ create-link-with choice ]
    ]
  ]
end

to go
  set year year + 1
  set year1 year1 + 1
  get-License
  count-PAV-Friends
  count-PAV-Neighbour
  count-PAV-Advertisment
  count-PAV-influence
  PAV-Lottery
  count-BEV-influence
  BEVLine
  Buy-a-BEV
  Buy-a-PAV
  AEVLine
  Buy-a-AEV
  CV-Lottery
  Buy-a-CV
  count-MaaS-Neighbour
  count-MaaS-Advertisment
  count-MaaS-influence
  MaaSLine
  adopt-MaaS-Monthly
  adopt-MaaS-Seasonal
  adopt-MaaS-Yearly
  adopt-MaaS-Onetime
 ; adopt-maas-Onetime-xmonthly
 ; adopt-maas-Onetime-xseason
 ; adopt-maas-Onetime-xyearly

  if year >= 2022
  [
    count-v2g-friend
    count-v2g-neighbor
    count-v2g-adv
    count-v2g-influence
    adopt-V2G
  ]
  change-color
  tick
end

to count-MaaS-Advertisment
  ask turtles [ set MaaS-Advertisment 0 ]
  ask n-of (21536 * global-influence-advertising-MaaS) turtles [ set MaaS-Advertisment 1 ]
end

to count-PAV-Advertisment
  ask turtles [ set AV-Advertisment 0 ]
  ask n-of (21536 * global-influence-advertising-AV) turtles [ set AV-Advertisment 1 ]
end

to count-v2g-adv ;have
  ask turtles [ set v2g-adv 0]
  ask n-of (21536 * advertising-V2G) turtles [ set v2g-adv 1 ]
end


to get-license ; allocating 300 agents (18-64) to have a driving license
  ask n-of 300 turtles with [ age >= 2 and age < 8 and License = 0]
  [ set License 1]
end

to cv-lottery ; only CV, no emerging vehicles
  ask turtles with [ BEV = 0 and CV = 0 and PHEV = 0 and PAV = 0 and License = 1 and BuyBEV = 1 and Lottery_CV = 0 and line1 = 9999]
  [set Lottery_CV 1]

  ask turtles with [ BEV = 0 and CV = 0 and PHEV = 0 and PAV = 0 and License = 1 and BuyBEV = 2 and Lottery_CV = 0 and bev-influence = 0 and line1 = 9999]
  [set Lottery_CV 1]

  let n1 count turtles with [BEV = 0 and CV = 0 and PHEV = 0 and PAV = 0 and License = 1 and BuyBEV = 2 and Lottery_CV = 0 and bev-influence = 1 and line1 = 9999]
  ask n-of ( 0.84 * n1) turtles with [BEV = 0 and CV = 0 and PHEV = 0 and PAV = 0 and License = 1 and BuyBEV = 2 and lottery_CV = 0 and bev-influence = 1 and line1 = 9999]
  [set Lottery_CV 1]
end

to Buy-a-CV
  ask n-of 20 turtles with [ Lottery_CV = 1 ]
  [set CV 1
   set Lottery_CV 0]
end

to MaaSLine
  ask turtles with [ MaaS >= 3 and MaaS-influence = 4 and line1 = 9999 ]
  [set MaaS 4]
  let n5 (count turtles with [ MaaS = 2 and MaaS-influence >= 3 and line1 = 9999 ])
  ask n-of (n5 * 0.70) turtles with [MaaS = 2 and MaaS-influence >= 3 and line1 = 9999]  ; n-of (n5 * 0.75)
  [set MaaS 3]
  let n1 (count turtles with [ MaaS = 2 and MaaS-influence = 2 and line1 = 9999 ])
    ask n-of (n1 * 0.30) turtles with [MaaS = 2 and MaaS-influence = 2 and line1 = 9999] ;n-of (n5 * 0.4)
  [set MaaS 3]
    let n2 (count turtles with [ MaaS = 2 and MaaS-influence = 1 and line1 = 9999 ])
    ask n-of (n2 * 0.10) turtles with [MaaS = 2 and MaaS-influence = 1 and line1 = 9999] ;n-of (n5 * 0.3)
  [set MaaS 3]
    let n3 (count turtles with [ MaaS = 1 and MaaS-influence = 2 and line1 = 9999 ])
    ask n-of (n3 * 0.20) turtles with [MaaS = 1 and MaaS-influence = 2 and line1 = 9999] ;n-of (n5 * 0.3)
  [set MaaS 2]
    let n4 (count turtles with [ MaaS = 1 and MaaS-influence = 1 and line1 = 9999 ])
      ask n-of (n4 * 0.20) turtles with [MaaS = 1 and MaaS-influence = 1 and line1 = 9999] ;n-of (n5 * 0.3)
  [set MaaS 2]
end

to PAV-Lottery ; only CV ; This CV Lottery includes three types of non-electrified vehicles, e.g., CV, PHEV, PAV
  ask turtles with [ Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyPAV = 4 and BuyBEV <= 2 and Lottery_AV = 0 and line2 = 9999 and aprice_given <= aprice]
  [set Lottery_AV 1]  ;

  ask turtles with [ Household >= 2 and license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyPAV = 3 and PAV-influence = 4 and BuyBEV <= 2 and Lottery_AV = 0  and line2 = 9999 and aprice_given <= aprice]
  [set Lottery_AV 1]

  let n1 (count turtles with [ Household >= 2 and license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyPAV = 3 and BuyBEV <= 2 and PAV-influence = 3 and Lottery_AV = 0 and line2 = 9999 and aprice_given <= aprice])
  ask n-of (n1 * 0.8) turtles with [Household >= 2 and license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyPAV = 3 and BuyBEV <= 2 and PAV-influence = 3 and Lottery_AV = 0 and line2 = 9999 and aprice_given <= aprice]
  [set Lottery_AV 1]
end

to Buy-a-PAV ;have
  ask n-of 15 turtles with [ Lottery_AV = 1 ]
  [set PAV 1
   set Lottery_AV 0]
end
; 1, 2, "3", 4, 5, 6, 9

to AEVLine

  ask turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyPAV = 4 and BuyBEV = 4 and line2 = 9999 and aprice_given <= aprice ] ; Ok
  [set line2 year]
  ask turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 4 and BuyPAV = 3 and PAV-influence = 4 and line2 = 9999 and aprice_given <= aprice ] ; ok
  [set line2 year]
  let n1 (count turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 4 and  BEV-influence = 4 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]) ; ok
  ask n-of (n1 * 0.90) turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 4 and  BEV-influence = 4 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]
  [set line2 year]
  let n2 (count turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 4 and PAV-influence = 4 and line2 = 9999 and aprice_given <= aprice]) ;ok
  ask n-of (n2 * 0.90) turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 4 and PAV-influence = 4 and line2 = 9999 and aprice_given <= aprice]
  [set line2 year]
  let n3 (count turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 4 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]) ;ok
  ask n-of (n3 * 0.80) turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 4 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]
  [set line2 year]
  let n4 (count turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 3 and PAV-influence = 4 and line2 = 9999 and aprice_given <= aprice]) ;ok
  ask n-of (n4 * 0.80) turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 3 and PAV-influence = 4 and line2 = 9999 and aprice_given <= aprice]
  [set line2 year]
  let n5 (count turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]) ;ok
  ask n-of (n5 * 0.80) turtles with [Household >= 2 and License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 3 and  BEV-influence = 3 and BuyPAV = 3 and PAV-influence = 3 and line2 = 9999 and aprice_given <= aprice]
  [set line2 year]
end

to Buy-a-AEV
  ask  min-n-of 30 turtles [ line2 ]
  [set AEV 1
   set line2 9999]
end

to BEVLine
  ask turtles with [ License = 1 and BEV = 0 and PHEV = 0 and CV = 0 and PAV = 0 and AEV = 0 and BuyBEV = 4  and line1 = 9999] ; Ok
  [set line1 year1 ]
  ask turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3 and PAV = 0 and AEV = 0  and BEV-influence = 4 and line1 = 9999 ] ; ok
  [set line1 year1]
  let n1 (count turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3 and BEV-influence = 3 and line1 = 9999])
  ask n-of (n1 * 0.85) turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3  and BEV-influence = 3 and line1 = 9999]
  [set line1 year1]
  let n2 (count turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3 and BEV-influence = 2 and line1 = 9999])
  ask n-of (n2 * 0.60) turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3 and BEV-influence = 2 and line1 = 9999]
  [set line1 year1]
  let n3 (count turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3  and BEV-influence = 1 and line1 = 9999])
  ask n-of (n3 * 0.30) turtles with [ license = 1 and BEV = 0 and PHEV = 0 and CV = 0 and BuyBEV = 3 and BEV-influence = 1 and line1 = 9999]
  [set line1 year1]
end

to Buy-a-BEV
  ask  min-n-of 180 turtles [ line1 ]
  [set BEV 1
   set line1 9999]
end

to change-color
  ask turtles with [ MaaS >= 3 ] [ set color yellow ]
  ask turtles with [ BEV = 1 ] [ set pcolor blue ]
  ask turtles with [ PHEV = 1 ] [ set pcolor red ]
  ask turtles with [ AEV = 1 ] [ set pcolor green ]
  ask turtles with [ BEV = 1 and V2G = 1] [ set color pink ]
  ask turtles with [ PHEV = 1 and V2G = 1] [ set color orange ]
  ask turtles with [ AEV = 1 and V2G = 1] [ set color white ]
  ask turtles with [ CV = 1 ] [set color violet]
end

to adopt-V2G ; The adoption of Vehicle-to-Grid (V2G)
  ;adopt V2G with BEV
  ask turtles with [ BEV = 1 and V2G = 0] ; The Adoption of BEV-V2G
  [
  if Eprice <= selling-price [ ; When the expected price is smaller or equal to the selling price
  if BEVV2G >= 4 ; Pass the threshold
      [ set V2G 1 ]] ; Adopt BEV-V2G
  ]

  ask turtles with [ AEV = 1 and V2G = 0] ; The Adoption of AEV-V2G, assuming the AEV = BEV + PAV
  [
  if Eprice <= selling-price [ ; When the expected price is smaller or equal to the selling price
  if BEVV2G >= 4 ; Pass the threshold
      [ set V2G 1 ]] ; Adopt BEV-V2G
  ]

  ask turtles with [PHEV = 1 and V2G = 0] ; The Adoption of PHEV-V2G
  [
  if Eprice <= selling-price [ ; When the expected price is smaller or equal to the selling price
  let p-phevv2g1 ((random-float 1) * 1000)
  if p-phevv2g1 < p-phevv2g
      [set V2G 1]]
  ]

  ask turtles with [ V2G = 1 ]
  [
  if Eprice > selling-price ; expected price is larger than the selling price
  [set V2G 0] ; Does not adopt V2G
  ]
end

to adopt-maas-Onetime
   ask turtles with [ MaaS >= 3] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo >= discount-payasyougo ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-payasyougo 1 ]
  ]
  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo <  discount-payasyougo
  [set adopt-maas-payasyougo 0]
  ]
end

to adopt-maas-monthly
   ask turtles with [ MaaS >= 3] ; if a person is very interested/ interested in MaaS
  [
  if maas-monthly >= discount-monthly ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-monthly1 1 ]
  ]
  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-monthly <  discount-monthly
  [set adopt-maas-monthly1 0]
  ]
end

to adopt-maas-seasonal
   ask turtles with [ MaaS >= 3]
  [
  if maas-seasonal >= discount-seasonal ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-seasonal1 1 ]
  ]

  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-seasonal <  discount-seasonal
  [set adopt-maas-seasonal1 0]
  ]
end

to adopt-maas-yearly
   ask turtles with [ MaaS >= 3] ; if a person is very interested/ interested in MaaS
  [
  if maas-yearly >= discount-yearly ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-yearly1 1 ]
  ]

  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-yearly <  discount-yearly
  [set adopt-maas-yearly1 0]
  ]
end



to adopt-maas-Onetime-xmonthly
  ask turtles with [adopt-maas-monthly1 = 0]  ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo >= discount-payasyougo ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-payasyougo 1 ] ; adopt maas pay-as-you-go
  ]

  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo <  discount-payasyougo
  [set adopt-maas-payasyougo 0]
  ]
end

to adopt-maas-Onetime-xseason
  ask turtles with [adopt-maas-seasonal1 = 0] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo >= discount-payasyougo ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-payasyougo 1 ] ; adopt maas pay-as-you-go
  ]

  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo <  discount-payasyougo
  [set adopt-maas-payasyougo 0]
  ]
end

to adopt-maas-Onetime-xyearly
  ask turtles with [adopt-maas-yearly1 = 0] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo >= discount-payasyougo ; if the preferred discount >= given discount (scenario)
      [ set adopt-maas-payasyougo 1 ] ; adopt maas pay-as-you-go
  ]
  ask turtles with [ MaaS >= 3 ] ; if a person is very interested/ interested in MaaS
  [
  if maas-payasyougo <  discount-payasyougo
  [set adopt-maas-payasyougo 0]
  ]
end

to count-MaaS-Neighbour
  ask turtles with [ mneighbour = 1 ] [
    let n1 sum [ count turtles-here with [ MaaS >= 3 ] ] of neighbors in-radius 2;
    if n1 >= 1
    [set MaaS-neighbour 1 ]
    ]
end

to count-MaaS-Friends
  ask turtles with [ mfriends = 1 ] [
    let n1 count in-link-neighbors with [ MaaS >= 3 ];
    if n1 >= 1
    [ set MaaS-Friends 1 ]
  ]
end

to count-PAV-Neighbour
  ask turtles with [ PAV <= 2 ] [
    let n1 sum [ count turtles-here with [ PAV >= 3 ] ] of neighbors in-radius 2;
    if n1 >= 1
    [set AV-neighbour 1 ]
    ]
end

to count-PAV-Friends
  ask turtles with [ PAV <= 2 ] [
    let n1 count in-link-neighbors with [ PAV >= 3 ];
    if n1 >= 1
    [ set AV-Friends 1 ]
  ]
end

to count-v2g-neighbor ; HAVE
  ask turtles with [Vneighbor = 1][
  let n1 sum [ count turtles-here with [ V2G = 1 ] ] of neighbors in-radius 2;;number of neighbors who have adopted V2G
  if n1 >= 1
    [ set V2G-neighbor 1 ]
  ]
end

to count-v2g-friend ;HAVE
  ask turtles with [Vfriend = 1][
    let n1 count in-link-neighbors with [ V2G = 1 ];;number of friends who have adopted V2G
    if n1 >= 1
    [ set V2G-friend 1 ]
   ]
end
@#$#@#$#@
GRAPHICS-WINDOW
412
78
901
456
-1
-1
1.0
1
10
1
1
1
0
1
1
1
-240
240
-184
184
0
0
1
ticks
30.0

BUTTON
323
40
378
73
Go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
912
40
1364
247
Clean Energy: BEV/AEV and V2G Adoption in Beijing 
Year (Time)
Citizens (n)
0.0
10.0
0.0
100000.0
true
true
"" ""
PENS
"BEV Adopter" 1.0 0 -5298144 true "" "plot count turtles with [ BEV = 1] * 1000"
"BEV-V2G Adopter" 1.0 0 -3844592 true "" "plot count turtles with [ BEV = 1 and V2G = 1]* 1000"
"AEV Adopter" 1.0 0 -1184463 true "" "plot count turtles with [ AEV = 1] * 1000"
"AEV-V2G Adopter" 1.0 0 -13840069 true "" "plot count turtles with [ AEV = 1 and V2G = 1]* 1000"
"BEV Line" 1.0 0 -11221820 true "" "plot count turtles with [line1 < 9999] * 1000"
"AEV Line" 1.0 0 -13791810 true "" "plot count turtles with [line2 < 9999] * 1000"
"PAV_Lottery" 1.0 0 -8630108 true "" "plot count turtles with [ Lottery_AV = 1] * 1000"
"CV_Lottery" 1.0 0 -7858858 true "" "plot count turtles with [ Lottery_CV = 1] * 1000"
"PAV Adopter" 1.0 0 -7500403 true "" "plot count turtles with [ PAV = 1]* 1000"
"CV Adopter" 1.0 0 -865067 true "" "plot count turtles with [ CV = 1]* 1000"

TEXTBOX
385
10
929
76
                         LSGI4502 Final Year Project \n      The Adoption of Emerging Smart Mobility Technologies in \n              Beijing, China: A Spatial Agent-based Approach
18
102.0
1

PLOT
913
253
1364
468
MaaS Adoption/Subscription in Beijing
Year (Time)
Citizens (n)
0.0
10.0
0.0
20000.0
true
true
"" ""
PENS
"Pay-as-you-go" 1.0 0 -5298144 true "" "plot count turtles with [ adopt-maas-payasyougo = 1 ] * 1000"
"Monthly" 1.0 0 -1184463 true "" "plot count turtles with [ adopt-maas-monthly1 = 1 ] * 1000"
"Season" 1.0 0 -13791810 true "" "plot count turtles with [ adopt-maas-seasonal1 = 1 ] * 1000"
"Yearly" 1.0 0 -14439633 true "" "plot count turtles with [ adopt-maas-yearly1 = 1 ] * 1000"
"MaaS Interest" 1.0 0 -7500403 true "" "plot count turtles with [ MaaS >= 3 ] * 1000"

SLIDER
5
140
393
173
global-influence-advertising-MaaS
global-influence-advertising-MaaS
0
1
0.5
0.1
1
NIL
HORIZONTAL

BUTTON
159
40
308
73
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
422
89
474
134
   Year
year
17
1
11

MONITOR
93
516
247
561
Interested in MaaS
(count turtles with [MaaS >= 3]) * 1000
17
1
11

MONITOR
252
515
382
560
Interested in MaaS (%)
count turtles with [ MaaS >= 3 ] / 215.36
17
1
11

MONITOR
709
516
800
561
BEV Adoption
(count turtles with [BEV = 1]) * 1000
17
1
11

SLIDER
10
287
211
320
discount-payasyougo
discount-payasyougo
50
100
90.0
5
1
%
HORIZONTAL

SLIDER
217
286
394
319
discount-monthly
discount-monthly
50
100
80.0
5
1
%
HORIZONTAL

SLIDER
10
336
212
369
discount-seasonal
discount-seasonal
50
100
70.0
10
1
%
HORIZONTAL

SLIDER
217
336
394
369
discount-yearly
discount-yearly
40
100
60.0
10
1
%
HORIZONTAL

SLIDER
8
381
395
414
neigbourhood-radius
neigbourhood-radius
100
1000
800.0
10
1
meter
HORIZONTAL

MONITOR
94
568
246
613
Pay-as-you-go Adoptor (%)
(count turtles with [adopt-maas-payasyougo = 1 ]) / 215.36
17
1
11

MONITOR
251
568
382
613
Monthly Adoptor(%)
(count turtles with [adopt-maas-monthly1 = 1 ]) / 215.36
17
1
11

MONITOR
93
620
246
665
Seasonal Adoptor (%)
(count turtles with [adopt-maas-seasonal1 = 1 ]) / 215.36
17
1
11

MONITOR
252
620
382
665
Yearly Adoptor (%)
(count turtles with [adopt-maas-yearly1 = 1 ]) / 215.36
17
1
11

SLIDER
215
239
393
272
selling-price
selling-price
1
2
1.3
0.1
1
NIL
HORIZONTAL

SLIDER
209
191
394
224
Advertising-V2G
Advertising-V2G
0
1
0.3
0.1
1
NIL
HORIZONTAL

SLIDER
8
191
202
224
Advertising-BEV
Advertising-BEV
0
1
0.7
0.1
1
NIL
HORIZONTAL

MONITOR
423
516
512
561
BEV-V2G
(count turtles with [BEV = 1 and V2G = 1]) * 1000
17
1
11

MONITOR
701
620
799
665
BEV-V2G (%)
(count turtles with [BEV = 1 and V2G = 1]) / 215.36
17
1
11

MONITOR
700
568
799
613
BEV Adoption (%)
(count turtles with [BEV = 1]) / 215.36
17
1
11

PLOT
914
477
1365
694
Overall AV, EV, V2G and MaaS Adoption in Beijing
Year (Time)
Citizens (n)
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"BEV" 1.0 0 -16777216 true "" "plot count turtles with [ BEV = 1] * 1000"
"BEV-V2G" 1.0 0 -7500403 true "" "plot count turtles with [ BEV = 1 and V2G = 1] * 1000"
"AEV" 1.0 0 -2674135 true "" "plot count turtles with [ AEV = 1] * 1000"
"AEV-V2G" 1.0 0 -955883 true "" "plot count turtles with [ AEV = 1 and V2G = 1] * 1000"
"PAV" 1.0 0 -6459832 true "" "plot count turtles with [ PAV = 1] * 1000"
"CV" 1.0 0 -1184463 true "" "plot count turtles with [ CV = 1] * 1000"
"Interest in MaaS" 1.0 0 -10899396 true "" "plot count turtles with [MaaS >= 3 ] * 1000"

MONITOR
486
568
592
613
CV Adoption (%)
(count turtles with [CV = 1]) / 215.36
17
1
11

MONITOR
709
465
800
510
BEV Applicants
(count turtles with [line1 < 9999]) * 1000
17
1
11

MONITOR
519
466
608
511
CV Applicants
(count turtles with [ lottery_CV = 1 ]) * 1000
17
1
11

MONITOR
422
466
512
511
AEV-V2G
(count turtles with [AEV = 1 and V2G = 1]) * 1000
17
1
11

MONITOR
597
620
696
665
AEV-V2G (%)
count turtles with [AEV = 1 and V2G = 1] / 215.36
17
1
11

MONITOR
808
619
905
664
V2G (%)
count turtles with [V2G = 1] / 215.36
20
1
11

SLIDER
8
239
206
272
global-influence-advertising-AV
global-influence-advertising-AV
0
1
0.7
0.1
1
NIL
HORIZONTAL

MONITOR
807
515
906
560
AEV Adoption
(count turtles with [ AEV = 1 ]) * 1000
17
1
11

MONITOR
614
517
705
562
PAV Adoption
(count turtles with [ PAV = 1 ]) * 1000
17
1
11

MONITOR
519
517
609
562
CV Adoption
(count turtles with [ CV = 1 ]) * 1000
17
1
11

MONITOR
806
465
905
510
AEV Applicants
(count turtles with [line2 < 9999]) * 1000
17
1
11

MONITOR
806
568
905
613
AEV Adoption (%)
(count turtles with [AEV = 1]) / 215.36
17
1
11

MONITOR
481
89
531
134
Year_1
year1
17
1
11

MONITOR
614
465
704
510
PAV Applicants
(count turtles with [ lottery_AV = 1 ]) * 1000
17
1
11

MONITOR
596
568
695
613
PAV Adoption (%)
(count turtles with [PAV = 1]) / 215.36
17
1
11

SLIDER
10
426
265
459
Aprice_given
Aprice_given
1
4
1.2
0.1
1
unit
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
