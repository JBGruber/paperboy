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
#>  [31] "cnn.com"                        "cnnbrasil.com.br"              
#>  [33] "courier.journal.com"            "dailymail.co.uk"               
#>  [35] "dailymail.com"                  "decider.com"                   
#>  [37] "democratandchronicle.com"       "denikn.cz"                     
#>  [39] "denverpost.com"                 "der.postillon.com"             
#>  [41] "derstandard.at"                 "derwesten.de"                  
#>  [43] "deutschlandfunk.de"             "deutschlandfunkkultur.de"      
#>  [45] "dnn.de"                         "echo24.de"                     
#>  [47] "edition.cnn.com"                "epochtimes.de"                 
#>  [49] "eu.courier.journal.com"         "eu.democratandchronicle.com"   
#>  [51] "eu.tennessean.com"              "eu.usatoday.com"               
#>  [53] "evolvepolitics.com"             "express.de"                    
#>  [55] "faz.net"                        "finanzen.net"                  
#>  [57] "fnp.de"                         "focus.de"                      
#>  [59] "forbes.com"                     "fortune.com"                   
#>  [61] "foxbusiness.com"                "foxnews.com"                   
#>  [63] "fr.de"                          "frankenpost.de"                
#>  [65] "freiepresse.de"                 "ftw.usatoday.com"              
#>  [67] "geenstijl.nl"                   "golfweek.usatoday.com"         
#>  [69] "handelsblatt.com"               "haz.de"                        
#>  [71] "heidelberg24.de"                "heise.de"                      
#>  [73] "hn.cz"                          "hna.de"                        
#>  [75] "huffingtonpost.co.uk"           "huffingtonpost.com"            
#>  [77] "huffpost.com"                   "idnes.cz"                      
#>  [79] "independent.co.uk"              "independent.ie"                
#>  [81] "infranken.de"                   "irishexaminer.com"             
#>  [83] "irishmirror.ie"                 "irishtimes.com"                
#>  [85] "irozhlas.cz"                    "joe.ie"                        
#>  [87] "jungefreiheit.de"               "kabeleins.de"                  
#>  [89] "karlsruhe.insider.de"           "kreiszeitung.de"               
#>  [91] "ksta.de"                        "kurier.at"                     
#>  [93] "latimes.com"                    "lidovky.cz"                    
#>  [95] "lvz.de"                         "malaymail.com"                 
#>  [97] "malaysiakini.com"               "manager.magazin.de"            
#>  [99] "marketwatch.com"                "maz.online.de"                 
#> [101] "mdr.de"                         "mediacourant.nl"               
#> [103] "merkur.de"                      "metronieuws.nl"                
#> [105] "mmajunkie.usatoday.com"         "mopo.de"                       
#> [107] "morgenpost.de"                  "n.tv.de"                       
#> [109] "ndr.de"                         "news.de"                       
#> [111] "news.und.nachrichten.de"        "newsflash24.de"                
#> [113] "newstatesman.com"               "newsweek.com"                  
#> [115] "nordkurier.de"                  "nos.nl"                        
#> [117] "novinky.cz"                     "noz.de"                        
#> [119] "nrc.nl"                         "nu.nl"                         
#> [121] "nw.de"                          "nypost.com"                    
#> [123] "nytimes.com"                    "nzz.ch"                        
#> [125] "orf.at"                         "ostsee.zeitung.de"             
#> [127] "pagesix.com"                    "parlamentnilisty.cz"           
#> [129] "presseportal.de"                "prosieben.de"                  
#> [131] "rbb24.de"                       "rnd.de"                        
#> [133] "rollingstone.de"                "rp.online.de"                  
#> [135] "rte.ie"                         "rtl.de"                        
#> [137] "rtl.nl"                         "rtlnieuws.nl"                  
#> [139] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [141] "saechsische.de"                 "schwaebische.de"               
#> [143] "seznamzpravy.cz"                "sfgate.com"                    
#> [145] "shz.de"                         "skwawkbox.org"                 
#> [147] "sky.com"                        "spiegel.de"                    
#> [149] "srf.ch"                         "stern.de"                      
#> [151] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [153] "suedkurier.de"                  "swp.de"                        
#> [155] "swr3.de"                        "swr.de"                        
#> [157] "swrfernsehen.de"                "t3n.de"                        
#> [159] "t.online.de"                    "tag24.de"                      
#> [161] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [163] "tagesspiegel.de"                "taz.de"                        
#> [165] "techrepublic.com"               "telegraaf.nl"                  
#> [167] "telegraph.co.uk"                "tennessean.com"                
#> [169] "thecanary.co"                   "theguardian.com"               
#> [171] "thejournal.ie"                  "thesun.ie"                     
#> [173] "thueringer.allgemeine.de"       "time.com"                      
#> [175] "tz.de"                          "us.cnn.com"                    
#> [177] "usatoday.com"                   "vice.com"                      
#> [179] "volkskrant.nl"                  "volksstimme.de"                
#> [181] "vox.de"                         "wa.de"                         
#> [183] "washingtonpost.com"             "watson.ch"                     
#> [185] "watson.de"                      "waz.de"                        
#> [187] "wdr.de"                         "welt.de"                       
#> [189] "wiwo.de"                        "wsj.com"                       
#> [191] "wz.de"                          "yahoo.com"                     
#> [193] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
