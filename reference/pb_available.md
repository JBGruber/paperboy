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
#>  [19] "bnn.de"                         "boston.com"                    
#>  [21] "bostonglobe.com"                "br.de"                         
#>  [23] "breakingnews.ie"                "breitbart.com"                 
#>  [25] "businessinsider.de"             "buzzfeed.com"                  
#>  [27] "capetownetc.com"                "cbsnews.com"                   
#>  [29] "ceskatelevize.cz"               "cnet.com"                      
#>  [31] "cnn.com"                        "courier.journal.com"           
#>  [33] "dailymail.co.uk"                "dailymail.com"                 
#>  [35] "decider.com"                    "democratandchronicle.com"      
#>  [37] "denikn.cz"                      "denverpost.com"                
#>  [39] "der.postillon.com"              "derstandard.at"                
#>  [41] "derwesten.de"                   "deutschlandfunk.de"            
#>  [43] "deutschlandfunkkultur.de"       "dnn.de"                        
#>  [45] "echo24.de"                      "edition.cnn.com"               
#>  [47] "epochtimes.de"                  "eu.courier.journal.com"        
#>  [49] "eu.democratandchronicle.com"    "eu.tennessean.com"             
#>  [51] "eu.usatoday.com"                "evolvepolitics.com"            
#>  [53] "express.de"                     "faz.net"                       
#>  [55] "finanzen.net"                   "fnp.de"                        
#>  [57] "focus.de"                       "forbes.com"                    
#>  [59] "fortune.com"                    "foxbusiness.com"               
#>  [61] "foxnews.com"                    "fr.de"                         
#>  [63] "frankenpost.de"                 "freiepresse.de"                
#>  [65] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [67] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [69] "haz.de"                         "heidelberg24.de"               
#>  [71] "heise.de"                       "hn.cz"                         
#>  [73] "hna.de"                         "huffingtonpost.co.uk"          
#>  [75] "huffingtonpost.com"             "huffpost.com"                  
#>  [77] "idnes.cz"                       "independent.co.uk"             
#>  [79] "independent.ie"                 "infranken.de"                  
#>  [81] "irishexaminer.com"              "irishmirror.ie"                
#>  [83] "irishtimes.com"                 "irozhlas.cz"                   
#>  [85] "joe.ie"                         "jungefreiheit.de"              
#>  [87] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [89] "kreiszeitung.de"                "ksta.de"                       
#>  [91] "kurier.at"                      "latimes.com"                   
#>  [93] "lidovky.cz"                     "lvz.de"                        
#>  [95] "malaymail.com"                  "malaysiakini.com"              
#>  [97] "manager.magazin.de"             "marketwatch.com"               
#>  [99] "maz.online.de"                  "mdr.de"                        
#> [101] "mediacourant.nl"                "merkur.de"                     
#> [103] "metronieuws.nl"                 "mmajunkie.usatoday.com"        
#> [105] "mopo.de"                        "morgenpost.de"                 
#> [107] "n.tv.de"                        "ndr.de"                        
#> [109] "news.de"                        "news.und.nachrichten.de"       
#> [111] "newsflash24.de"                 "newstatesman.com"              
#> [113] "newsweek.com"                   "nordkurier.de"                 
#> [115] "nos.nl"                         "novinky.cz"                    
#> [117] "noz.de"                         "nrc.nl"                        
#> [119] "nu.nl"                          "nw.de"                         
#> [121] "nypost.com"                     "nytimes.com"                   
#> [123] "nzz.ch"                         "orf.at"                        
#> [125] "ostsee.zeitung.de"              "pagesix.com"                   
#> [127] "parlamentnilisty.cz"            "presseportal.de"               
#> [129] "prosieben.de"                   "rbb24.de"                      
#> [131] "rnd.de"                         "rollingstone.de"               
#> [133] "rp.online.de"                   "rte.ie"                        
#> [135] "rtl.de"                         "rtl.nl"                        
#> [137] "rtlnieuws.nl"                   "ruhr24.de"                     
#> [139] "ruhrnachrichten.de"             "saechsische.de"                
#> [141] "schwaebische.de"                "seznamzpravy.cz"               
#> [143] "sfgate.com"                     "shz.de"                        
#> [145] "skwawkbox.org"                  "sky.com"                       
#> [147] "spiegel.de"                     "srf.ch"                        
#> [149] "stern.de"                       "stuttgarter.zeitung.de"        
#> [151] "sueddeutsche.de"                "suedkurier.de"                 
#> [153] "swp.de"                         "swr3.de"                       
#> [155] "swr.de"                         "swrfernsehen.de"               
#> [157] "t3n.de"                         "t.online.de"                   
#> [159] "tag24.de"                       "tagesanzeiger.ch"              
#> [161] "tagesschau.de"                  "tagesspiegel.de"               
#> [163] "taz.de"                         "techrepublic.com"              
#> [165] "telegraaf.nl"                   "telegraph.co.uk"               
#> [167] "tennessean.com"                 "thecanary.co"                  
#> [169] "theguardian.com"                "thejournal.ie"                 
#> [171] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [173] "tz.de"                          "us.cnn.com"                    
#> [175] "usatoday.com"                   "vice.com"                      
#> [177] "volkskrant.nl"                  "volksstimme.de"                
#> [179] "vox.de"                         "wa.de"                         
#> [181] "washingtonpost.com"             "watson.ch"                     
#> [183] "watson.de"                      "waz.de"                        
#> [185] "wdr.de"                         "welt.de"                       
#> [187] "wiwo.de"                        "wsj.com"                       
#> [189] "wz.de"                          "yahoo.com"                     
#> [191] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
