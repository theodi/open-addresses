module Upload
  
  require 'csv'
  require 'open-uri'
  
  class PricePaid
    
    def self.historic
      # Get "http://www.landregistry.gov.uk/professional/market-trend-data/public-data/price-paid-data"
      doc = Nokogiri::HTML(open("http://www.landregistry.gov.uk/professional/market-trend-data/public-data/price-paid-data"))
      # Get Xpath //*[@id="content_div_1439"]/ul[3]/li
      items = doc.search('//*[@id="content_div_1439"]/ul[3]/li/a')
      # Load each page
      items.each do |item|
        doc = Nokogiri::HTML(open(item[:href]))
        # Get Xpath //*[@id="Land Registry Price Paid Data"]/tr
        rows = doc.search('//*[@id="Land Registry Price Paid Data"]/tbody/tr')
        rows.each do |row|
          link = row.search('td[3]/a')[0][:href] rescue nil
          unless row.nil?
            csv = open(link).read
            self.insert(csv)
          end
        end
      end
    end
    
    def self.this_year
      doc = Nokogiri::HTML(open("http://www.landregistry.gov.uk/professional/market-trend-data/public-data/price-paid-data"))
      rows = doc.search('//*[@id="Land Registry Price Paid Data"]/tbody/tr')
      rows.each do |row|
        link = row.search('td[2]/a')[0][:href] rescue nil
        unless row.nil?
           csv = open(link).read
           self.insert(csv)
        end
      end
    end
    
    def self.latest
      doc = Nokogiri::HTML(open("http://www.landregistry.gov.uk/professional/market-trend-data/public-data/price-paid-data"))
      link = doc.search('//*[@id="Land Registry Price Paid Data"]/tbody/tr[1]/td[2]/a')[0][:href]
      csv = open(link).read
      self.insert(csv)
    end
    
    def self.insert(csv)
      CSV.parse(csv) do |row|
      
        address1 = [row[8], row[7], row[9]].reject(&:blank?).join(" ")
      
        a = Address.new(
           :address1 => address1,
           :area     => row[10],
           :town     => row[12],
           :county   => row[13],
           :postcode => row[3]
         )
       
        a.save
      end
    end
  end
  
  class CompaniesHouse
    
    def self.all
      doc = Nokogiri::HTML(open("http://download.companieshouse.gov.uk/en_output.html"))
      lis = doc.search('//*[@id="mainContent"]/div[2]/ul/li')
      lis.each do |li|
        zip = open("http://download.companieshouse.gov.uk/" + li.search('a[1]')[0][:href]).read
        Zip::Archive.open_buffer(zip) do |zf|
           zf.fopen(zf.get_name(0)) do |f|
             csv = f.read
             self.insert(csv)
           end
        end
      end
    end
    
    def self.insert(csv)
      CSV.parse(csv) do |row|      
        unless row[9].blank?      
          a = Address.new(
             :address1 => row[4],
             :area     => row[5],
             :town     => row[6],
             :county   => row[7],
             :postcode => row[9]
           )
     
          a.save
        end
      end
    end    
  end
  
  class Nrosh
    
    def self.all
      
    end
    
    def self.insert(csv)
      
    end
    
  end
end