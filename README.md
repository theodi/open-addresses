# OpenAddresses

The [Postcode Address File](http://en.wikipedia.org/wiki/Postcode_Address_File) is a database which contains all known addresses in the UK. It's a potential goldmine for startups, civic hackers and just developers keen to wrangle with public data.

Unfortunately, despite the great strides the UK has made with open data, this data is still under lock and key, and with the impending [privatisation of the Post Office](http://www.bbc.co.uk/news/business-23253370), looks to remain that way.

However, all is not lost. There's is a wealth of data out there that is open that contains addresses. This project aims to gather all these addresses and provide a free, open database for startups and developers to use. 

So far, the sources we use are:

* [Land Registry Price Paid Data](http://www.landregistry.gov.uk/professional/market-trend-data/public-data/price-paid-data)
* [Companies House Free Public Data Product](http://www.companieshouse.gov.uk/toolsToHelp/freePublicDataProduct.shtml)
* [National Register of Social Housing (NROSH)](http://data.gov.uk/dataset/national-register-of-social-housing-nrosh)
* [Openstreetmap](http://www.openstreetmap.org/) © OpenStreetMap contributors

If you maintain a database of addresses you are willing to donate to the project, or know of a large open dataset that contains addresses, we'd love to hear from you!

Using this data, we should get roughly 17 million+ addresses, which, while is still 10 million short of the total addresses in the UK, it's a start.

## Licence

This code is open source under the MIT license. See the LICENSE.md file for full details.

## Usage

The repo itself is a [Padrino](http://www.padrinorb.com/) project, with a [MongoDB](http://www.mongodb.org/) backend. If you want to import the data, enter the console using:

	padrino c
	
And then enter one of the two import commands (we currently have importers for the Price Paid and Companies House data):

	Upload::PricePaid.historic
	
Or

	Upload::CompaniesHouse.all
	
Although, please bare in mind that this will take **ages** (like days), so you may want to run it for a couple of minutes just to get a small subset of data.