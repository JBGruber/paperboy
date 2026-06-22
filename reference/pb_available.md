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
#>  [15] "bild.de"                        "blesk.cz"                      
#>  [17] "blogs.faz.net"                  "bnn.de"                        
#>  [19] "br.de"                          "breakingnews.ie"               
#>  [21] "breitbart.com"                  "businessinsider.de"            
#>  [23] "buzzfeed.com"                   "capetownetc.com"               
#>  [25] "cbsnews.com"                    "ceskatelevize.cz"              
#>  [27] "cnet.com"                       "cnn.com"                       
#>  [29] "dailymail.co.uk"                "dailymail.com"                 
#>  [31] "decider.com"                    "democratandchronicle.com"      
#>  [33] "denikn.cz"                      "denverpost.com"                
#>  [35] "der.postillon.com"              "derstandard.at"                
#>  [37] "derwesten.de"                   "deutschlandfunk.de"            
#>  [39] "deutschlandfunkkultur.de"       "dnn.de"                        
#>  [41] "echo24.de"                      "edition.cnn.com"               
#>  [43] "epochtimes.de"                  "eu.courier.journal.com"        
#>  [45] "eu.democratandchronicle.com"    "eu.tennessean.com"             
#>  [47] "eu.usatoday.com"                "evolvepolitics.com"            
#>  [49] "express.de"                     "faz.net"                       
#>  [51] "finanzen.net"                   "fnp.de"                        
#>  [53] "focus.de"                       "forbes.com"                    
#>  [55] "foxbusiness.com"                "foxnews.com"                   
#>  [57] "fr.de"                          "frankenpost.de"                
#>  [59] "freiepresse.de"                 "ftw.usatoday.com"              
#>  [61] "geenstijl.nl"                   "golfweek.usatoday.com"         
#>  [63] "handelsblatt.com"               "haz.de"                        
#>  [65] "heidelberg24.de"                "heise.de"                      
#>  [67] "hn.cz"                          "hna.de"                        
#>  [69] "huffingtonpost.co.uk"           "huffingtonpost.com"            
#>  [71] "huffpost.com"                   "idnes.cz"                      
#>  [73] "independent.co.uk"              "independent.ie"                
#>  [75] "infranken.de"                   "irishexaminer.com"             
#>  [77] "irishmirror.ie"                 "irishtimes.com"                
#>  [79] "irozhlas.cz"                    "joe.ie"                        
#>  [81] "jungefreiheit.de"               "kabeleins.de"                  
#>  [83] "karlsruhe.insider.de"           "kreiszeitung.de"               
#>  [85] "ksta.de"                        "kurier.at"                     
#>  [87] "latimes.com"                    "lidovky.cz"                    
#>  [89] "lvz.de"                         "manager.magazin.de"            
#>  [91] "marketwatch.com"                "maz.online.de"                 
#>  [93] "mdr.de"                         "mediacourant.nl"               
#>  [95] "merkur.de"                      "metronieuws.nl"                
#>  [97] "mmajunkie.usatoday.com"         "mopo.de"                       
#>  [99] "morgenpost.de"                  "n.tv.de"                       
#> [101] "ndr.de"                         "news.de"                       
#> [103] "news.und.nachrichten.de"        "newsflash24.de"                
#> [105] "newstatesman.com"               "newsweek.com"                  
#> [107] "nordkurier.de"                  "nos.nl"                        
#> [109] "novinky.cz"                     "noz.de"                        
#> [111] "nrc.nl"                         "nu.nl"                         
#> [113] "nw.de"                          "nypost.com"                    
#> [115] "nytimes.com"                    "nzz.ch"                        
#> [117] "orf.at"                         "ostsee.zeitung.de"             
#> [119] "pagesix.com"                    "parlamentnilisty.cz"           
#> [121] "presseportal.de"                "prosieben.de"                  
#> [123] "rbb24.de"                       "rnd.de"                        
#> [125] "rollingstone.de"                "rp.online.de"                  
#> [127] "rte.ie"                         "rtl.de"                        
#> [129] "rtl.nl"                         "rtlnieuws.nl"                  
#> [131] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [133] "saechsische.de"                 "schwaebische.de"               
#> [135] "seznamzpravy.cz"                "sfgate.com"                    
#> [137] "shz.de"                         "skwawkbox.org"                 
#> [139] "sky.com"                        "spiegel.de"                    
#> [141] "srf.ch"                         "stern.de"                      
#> [143] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [145] "suedkurier.de"                  "swp.de"                        
#> [147] "swr3.de"                        "swr.de"                        
#> [149] "swrfernsehen.de"                "t3n.de"                        
#> [151] "t.online.de"                    "tag24.de"                      
#> [153] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [155] "tagesspiegel.de"                "taz.de"                        
#> [157] "techrepublic.com"               "telegraaf.nl"                  
#> [159] "telegraph.co.uk"                "thecanary.co"                  
#> [161] "theguardian.com"                "thejournal.ie"                 
#> [163] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [165] "tz.de"                          "us.cnn.com"                    
#> [167] "usatoday.com"                   "vice.com"                      
#> [169] "volkskrant.nl"                  "volksstimme.de"                
#> [171] "vox.de"                         "wa.de"                         
#> [173] "washingtonpost.com"             "watson.ch"                     
#> [175] "watson.de"                      "waz.de"                        
#> [177] "wdr.de"                         "welt.de"                       
#> [179] "wiwo.de"                        "wsj.com"                       
#> [181] "wz.de"                          "yahoo.com"                     
#> [183] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
