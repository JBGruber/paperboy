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
#>   [5] "ad.nl"                          "aktualne.cz"                   
#>   [7] "anotherangryvoice.blogspot.com" "augsburger.allgemeine.de"      
#>   [9] "badische.zeitung.de"            "bbc.co.uk"                     
#>  [11] "berliner.kurier.de"             "berliner.zeitung.de"           
#>  [13] "bild.de"                        "blesk.cz"                      
#>  [15] "blogs.faz.net"                  "bnn.de"                        
#>  [17] "br.de"                          "breakingnews.ie"               
#>  [19] "breitbart.com"                  "businessinsider.de"            
#>  [21] "buzzfeed.com"                   "cbsnews.com"                   
#>  [23] "ceskatelevize.cz"               "cnet.com"                      
#>  [25] "cnn.com"                        "dailymail.co.uk"               
#>  [27] "decider.com"                    "democratandchronicle.com"      
#>  [29] "denikn.cz"                      "denverpost.com"                
#>  [31] "der.postillon.com"              "derstandard.at"                
#>  [33] "derwesten.de"                   "deutschlandfunk.de"            
#>  [35] "deutschlandfunkkultur.de"       "dnn.de"                        
#>  [37] "echo24.de"                      "edition.cnn.com"               
#>  [39] "epochtimes.de"                  "eu.courier.journal.com"        
#>  [41] "eu.democratandchronicle.com"    "eu.tennessean.com"             
#>  [43] "eu.usatoday.com"                "evolvepolitics.com"            
#>  [45] "express.de"                     "faz.net"                       
#>  [47] "finanzen.net"                   "fnp.de"                        
#>  [49] "focus.de"                       "forbes.com"                    
#>  [51] "foxbusiness.com"                "foxnews.com"                   
#>  [53] "fr.de"                          "frankenpost.de"                
#>  [55] "freiepresse.de"                 "ftw.usatoday.com"              
#>  [57] "geenstijl.nl"                   "golfweek.usatoday.com"         
#>  [59] "handelsblatt.com"               "haz.de"                        
#>  [61] "heidelberg24.de"                "heise.de"                      
#>  [63] "hn.cz"                          "hna.de"                        
#>  [65] "huffingtonpost.co.uk"           "huffingtonpost.com"            
#>  [67] "huffpost.com"                   "idnes.cz"                      
#>  [69] "independent.co.uk"              "independent.ie"                
#>  [71] "infranken.de"                   "irishexaminer.com"             
#>  [73] "irishmirror.ie"                 "irishtimes.com"                
#>  [75] "irozhlas.cz"                    "joe.ie"                        
#>  [77] "jungefreiheit.de"               "kabeleins.de"                  
#>  [79] "karlsruhe.insider.de"           "kreiszeitung.de"               
#>  [81] "ksta.de"                        "kurier.at"                     
#>  [83] "latimes.com"                    "lidovky.cz"                    
#>  [85] "lvz.de"                         "manager.magazin.de"            
#>  [87] "marketwatch.com"                "maz.online.de"                 
#>  [89] "mdr.de"                         "mediacourant.nl"               
#>  [91] "merkur.de"                      "metronieuws.nl"                
#>  [93] "mmajunkie.usatoday.com"         "mopo.de"                       
#>  [95] "morgenpost.de"                  "n.tv.de"                       
#>  [97] "ndr.de"                         "news.de"                       
#>  [99] "news.und.nachrichten.de"        "newsflash24.de"                
#> [101] "newstatesman.com"               "newsweek.com"                  
#> [103] "nordkurier.de"                  "nos.nl"                        
#> [105] "novinky.cz"                     "noz.de"                        
#> [107] "nrc.nl"                         "nu.nl"                         
#> [109] "nw.de"                          "nypost.com"                    
#> [111] "nytimes.com"                    "nzz.ch"                        
#> [113] "orf.at"                         "ostsee.zeitung.de"             
#> [115] "pagesix.com"                    "parlamentnilisty.cz"           
#> [117] "presseportal.de"                "prosieben.de"                  
#> [119] "rbb24.de"                       "rnd.de"                        
#> [121] "rollingstone.de"                "rp.online.de"                  
#> [123] "rte.ie"                         "rtl.de"                        
#> [125] "rtl.nl"                         "rtlnieuws.nl"                  
#> [127] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [129] "saechsische.de"                 "schwaebische.de"               
#> [131] "seznamzpravy.cz"                "sfgate.com"                    
#> [133] "shz.de"                         "skwawkbox.org"                 
#> [135] "sky.com"                        "spiegel.de"                    
#> [137] "srf.ch"                         "stern.de"                      
#> [139] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [141] "suedkurier.de"                  "swp.de"                        
#> [143] "swr3.de"                        "swr.de"                        
#> [145] "swrfernsehen.de"                "t3n.de"                        
#> [147] "t.online.de"                    "tag24.de"                      
#> [149] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [151] "tagesspiegel.de"                "taz.de"                        
#> [153] "techrepublic.com"               "telegraaf.nl"                  
#> [155] "telegraph.co.uk"                "thecanary.co"                  
#> [157] "theguardian.com"                "thejournal.ie"                 
#> [159] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [161] "tz.de"                          "us.cnn.com"                    
#> [163] "usatoday.com"                   "vice.com"                      
#> [165] "volkskrant.nl"                  "volksstimme.de"                
#> [167] "vox.de"                         "wa.de"                         
#> [169] "washingtonpost.com"             "watson.ch"                     
#> [171] "watson.de"                      "waz.de"                        
#> [173] "wdr.de"                         "welt.de"                       
#> [175] "wiwo.de"                        "wsj.com"                       
#> [177] "wz.de"                          "yahoo.com"                     
#> [179] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
