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
#>  [59] "foxbusiness.com"                "foxnews.com"                   
#>  [61] "fr.de"                          "frankenpost.de"                
#>  [63] "freiepresse.de"                 "ftw.usatoday.com"              
#>  [65] "geenstijl.nl"                   "golfweek.usatoday.com"         
#>  [67] "handelsblatt.com"               "haz.de"                        
#>  [69] "heidelberg24.de"                "heise.de"                      
#>  [71] "hn.cz"                          "hna.de"                        
#>  [73] "huffingtonpost.co.uk"           "huffingtonpost.com"            
#>  [75] "huffpost.com"                   "idnes.cz"                      
#>  [77] "independent.co.uk"              "independent.ie"                
#>  [79] "infranken.de"                   "irishexaminer.com"             
#>  [81] "irishmirror.ie"                 "irishtimes.com"                
#>  [83] "irozhlas.cz"                    "joe.ie"                        
#>  [85] "jungefreiheit.de"               "kabeleins.de"                  
#>  [87] "karlsruhe.insider.de"           "kreiszeitung.de"               
#>  [89] "ksta.de"                        "kurier.at"                     
#>  [91] "latimes.com"                    "lidovky.cz"                    
#>  [93] "lvz.de"                         "malaymail.com"                 
#>  [95] "malaysiakini.com"               "manager.magazin.de"            
#>  [97] "marketwatch.com"                "maz.online.de"                 
#>  [99] "mdr.de"                         "mediacourant.nl"               
#> [101] "merkur.de"                      "metronieuws.nl"                
#> [103] "mmajunkie.usatoday.com"         "mopo.de"                       
#> [105] "morgenpost.de"                  "n.tv.de"                       
#> [107] "ndr.de"                         "news.de"                       
#> [109] "news.und.nachrichten.de"        "newsflash24.de"                
#> [111] "newstatesman.com"               "newsweek.com"                  
#> [113] "nordkurier.de"                  "nos.nl"                        
#> [115] "novinky.cz"                     "noz.de"                        
#> [117] "nrc.nl"                         "nu.nl"                         
#> [119] "nw.de"                          "nypost.com"                    
#> [121] "nytimes.com"                    "nzz.ch"                        
#> [123] "orf.at"                         "ostsee.zeitung.de"             
#> [125] "pagesix.com"                    "parlamentnilisty.cz"           
#> [127] "presseportal.de"                "prosieben.de"                  
#> [129] "rbb24.de"                       "rnd.de"                        
#> [131] "rollingstone.de"                "rp.online.de"                  
#> [133] "rte.ie"                         "rtl.de"                        
#> [135] "rtl.nl"                         "rtlnieuws.nl"                  
#> [137] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [139] "saechsische.de"                 "schwaebische.de"               
#> [141] "seznamzpravy.cz"                "sfgate.com"                    
#> [143] "shz.de"                         "skwawkbox.org"                 
#> [145] "sky.com"                        "spiegel.de"                    
#> [147] "srf.ch"                         "stern.de"                      
#> [149] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [151] "suedkurier.de"                  "swp.de"                        
#> [153] "swr3.de"                        "swr.de"                        
#> [155] "swrfernsehen.de"                "t3n.de"                        
#> [157] "t.online.de"                    "tag24.de"                      
#> [159] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [161] "tagesspiegel.de"                "taz.de"                        
#> [163] "techrepublic.com"               "telegraaf.nl"                  
#> [165] "telegraph.co.uk"                "tennessean.com"                
#> [167] "thecanary.co"                   "theguardian.com"               
#> [169] "thejournal.ie"                  "thesun.ie"                     
#> [171] "thueringer.allgemeine.de"       "tz.de"                         
#> [173] "us.cnn.com"                     "usatoday.com"                  
#> [175] "vice.com"                       "volkskrant.nl"                 
#> [177] "volksstimme.de"                 "vox.de"                        
#> [179] "wa.de"                          "washingtonpost.com"            
#> [181] "watson.ch"                      "watson.de"                     
#> [183] "waz.de"                         "wdr.de"                        
#> [185] "welt.de"                        "wiwo.de"                       
#> [187] "wsj.com"                        "wz.de"                         
#> [189] "yahoo.com"                      "zdf.de"                        
#> [191] "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
