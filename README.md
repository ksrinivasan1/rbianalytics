# rbianalytics
Analytics on RBI Electronic Payment Data

# Goals
* Analyze trends of growth in electronic payment over the last 7 years
* Do comparitive study across 
 * Public Vs Private Sector
 * Indian Banks vs Foreign Banks
 * Top 5 banks (leading in number of electronic transactions)
 * Top 5 banks (leading in value of electronic transactions)
 * Bottom 5 banks (lowest in number of electronic transactions)
 * Bottom 5 banks (lowest in value of electronic transactions)

# File Formats 
## NEFT Sheet format
Bank	OutwardTransactions	OutwardValueMillions	InwardTransactions	InwardValueMillions	Month	Year

(make sure while copying that the data is in millions only. Some sheets may have data in crores, others in millions)

## RTGS Sheet format
Bank	InwardInterbankVolume	InwardCustomerVoAlume	InwardTotalCustomerVolume	InwardPctVolume	InwardInterbankValue	InwardCustomerValue	InwardTotalCustomerValue	InwardPctValue	OutwardInterbankVolume	OutwardCustomerVolume	OutwardTotalCustomerVolume	OutwardPctVolume	OutwardInterbankValue	OutwardCustomerValue	OutwardTotalCustomerValue	OutwardPctValue	Month	Year

## Mobile Banking format
Bank	Transactions	ValueInThousands	Month	Year


# Pre-Requisites
* Install git command line client (https://git-scm.com/download/win) 
* Alternatively, github desktop (desktop.github.com) or tortoise git (https://tortoisegit.org/download/)
