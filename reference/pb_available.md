# Show available parsers

Show available parsers

## Usage

``` r
pb_available(...)
```

## Arguments

- ...:

  optionally pass URLs to check if respective parser(s) is/are
  available.

## Value

A character vector of supported domains.

## Examples

``` r
pb_available()
#>   [1] "3sat.de"                        "abendblatt.de"                 
#>   [3] "abendzeitung.muenchen.de"       "ac24.cz"                       
#>   [5] "ad.nl"                          "aftenposten.no"                
#>   [7] "aktualne.cz"                    "anotherangryvoice.blogspot.com"
#>   [9] "augsburger.allgemeine.de"       "badische.zeitung.de"           
#>  [11] "bbc.co.uk"                      "bbc.com"                       
#>  [13] "berliner.kurier.de"             "berliner.zeitung.de"           
#>  [15] "bernama.com"                    "bild.de"                       
#>  [17] "blesk.cz"                       "blogs.faz.net"                 
#>  [19] "bnn.de"                         "br.de"                         
#>  [21] "breakingnews.ie"                "breitbart.com"                 
#>  [23] "businessinsider.de"             "buzzfeed.com"                  
#>  [25] "capetownetc.com"                "cbsnews.com"                   
#>  [27] "ceskatelevize.cz"               "cnet.com"                      
#>  [29] "cnn.com"                        "dailymail.co.uk"               
#>  [31] "dailymail.com"                  "decider.com"                   
#>  [33] "democratandchronicle.com"       "denikn.cz"                     
#>  [35] "denverpost.com"                 "der.postillon.com"             
#>  [37] "derstandard.at"                 "derwesten.de"                  
#>  [39] "deutschlandfunk.de"             "deutschlandfunkkultur.de"      
#>  [41] "dnn.de"                         "echo24.de"                     
#>  [43] "edition.cnn.com"                "epochtimes.de"                 
#>  [45] "eu.courier.journal.com"         "eu.democratandchronicle.com"   
#>  [47] "eu.tennessean.com"              "eu.usatoday.com"               
#>  [49] "evolvepolitics.com"             "express.de"                    
#>  [51] "faz.net"                        "finanzen.net"                  
#>  [53] "fnp.de"                         "focus.de"                      
#>  [55] "forbes.com"                     "foxbusiness.com"               
#>  [57] "foxnews.com"                    "fr.de"                         
#>  [59] "frankenpost.de"                 "freiepresse.de"                
#>  [61] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [63] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [65] "haz.de"                         "heidelberg24.de"               
#>  [67] "heise.de"                       "hn.cz"                         
#>  [69] "hna.de"                         "huffingtonpost.co.uk"          
#>  [71] "huffingtonpost.com"             "huffpost.com"                  
#>  [73] "idnes.cz"                       "independent.co.uk"             
#>  [75] "independent.ie"                 "infranken.de"                  
#>  [77] "irishexaminer.com"              "irishmirror.ie"                
#>  [79] "irishtimes.com"                 "irozhlas.cz"                   
#>  [81] "joe.ie"                         "jungefreiheit.de"              
#>  [83] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [85] "kreiszeitung.de"                "ksta.de"                       
#>  [87] "kurier.at"                      "latimes.com"                   
#>  [89] "lidovky.cz"                     "lvz.de"                        
#>  [91] "malaymail.com"                  "manager.magazin.de"            
#>  [93] "marketwatch.com"                "maz.online.de"                 
#>  [95] "mdr.de"                         "mediacourant.nl"               
#>  [97] "merkur.de"                      "metronieuws.nl"                
#>  [99] "mmajunkie.usatoday.com"         "mopo.de"                       
#> [101] "morgenpost.de"                  "n.tv.de"                       
#> [103] "ndr.de"                         "news.de"                       
#> [105] "news.und.nachrichten.de"        "newsflash24.de"                
#> [107] "newstatesman.com"               "newsweek.com"                  
#> [109] "nordkurier.de"                  "nos.nl"                        
#> [111] "novinky.cz"                     "noz.de"                        
#> [113] "nrc.nl"                         "nu.nl"                         
#> [115] "nw.de"                          "nypost.com"                    
#> [117] "nytimes.com"                    "nzz.ch"                        
#> [119] "orf.at"                         "ostsee.zeitung.de"             
#> [121] "pagesix.com"                    "parlamentnilisty.cz"           
#> [123] "presseportal.de"                "prosieben.de"                  
#> [125] "rbb24.de"                       "rnd.de"                        
#> [127] "rollingstone.de"                "rp.online.de"                  
#> [129] "rte.ie"                         "rtl.de"                        
#> [131] "rtl.nl"                         "rtlnieuws.nl"                  
#> [133] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [135] "saechsische.de"                 "schwaebische.de"               
#> [137] "seznamzpravy.cz"                "sfgate.com"                    
#> [139] "shz.de"                         "skwawkbox.org"                 
#> [141] "sky.com"                        "spiegel.de"                    
#> [143] "srf.ch"                         "stern.de"                      
#> [145] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [147] "suedkurier.de"                  "swp.de"                        
#> [149] "swr3.de"                        "swr.de"                        
#> [151] "swrfernsehen.de"                "t3n.de"                        
#> [153] "t.online.de"                    "tag24.de"                      
#> [155] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [157] "tagesspiegel.de"                "taz.de"                        
#> [159] "techrepublic.com"               "telegraaf.nl"                  
#> [161] "telegraph.co.uk"                "thecanary.co"                  
#> [163] "theguardian.com"                "thejournal.ie"                 
#> [165] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [167] "tz.de"                          "us.cnn.com"                    
#> [169] "usatoday.com"                   "vice.com"                      
#> [171] "volkskrant.nl"                  "volksstimme.de"                
#> [173] "vox.de"                         "wa.de"                         
#> [175] "washingtonpost.com"             "watson.ch"                     
#> [177] "watson.de"                      "waz.de"                        
#> [179] "wdr.de"                         "welt.de"                       
#> [181] "wiwo.de"                        "wsj.com"                       
#> [183] "wz.de"                          "yahoo.com"                     
#> [185] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
