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
#>   [3] "abendzeitung.muenchen.de"       "abs.cbn.com"                   
#>   [5] "ac24.cz"                        "ad.nl"                         
#>   [7] "aftenposten.no"                 "aktualne.cz"                   
#>   [9] "anotherangryvoice.blogspot.com" "augsburger.allgemeine.de"      
#>  [11] "badische.zeitung.de"            "bbc.co.uk"                     
#>  [13] "bbc.com"                        "berliner.kurier.de"            
#>  [15] "berliner.zeitung.de"            "bernama.com"                   
#>  [17] "bild.de"                        "blesk.cz"                      
#>  [19] "blogs.faz.net"                  "bnn.de"                        
#>  [21] "boston.com"                     "bostonglobe.com"               
#>  [23] "br.de"                          "breakingnews.ie"               
#>  [25] "breitbart.com"                  "brisbanetimes.com.au"          
#>  [27] "businessinsider.de"             "buzzfeed.com"                  
#>  [29] "capetownetc.com"                "cbsnews.com"                   
#>  [31] "ceskatelevize.cz"               "cnet.com"                      
#>  [33] "cnn.com"                        "cnnbrasil.com.br"              
#>  [35] "courier.journal.com"            "dailymail.co.uk"               
#>  [37] "dailymail.com"                  "decider.com"                   
#>  [39] "democratandchronicle.com"       "denikn.cz"                     
#>  [41] "denverpost.com"                 "der.postillon.com"             
#>  [43] "derstandard.at"                 "derwesten.de"                  
#>  [45] "deutschlandfunk.de"             "deutschlandfunkkultur.de"      
#>  [47] "dnn.de"                         "dw.com"                        
#>  [49] "echo24.de"                      "edition.cnn.com"               
#>  [51] "epochtimes.de"                  "eu.courier.journal.com"        
#>  [53] "eu.democratandchronicle.com"    "eu.tennessean.com"             
#>  [55] "eu.usatoday.com"                "evolvepolitics.com"            
#>  [57] "express.de"                     "faz.net"                       
#>  [59] "finanzen.net"                   "fnp.de"                        
#>  [61] "focus.de"                       "forbes.com"                    
#>  [63] "fortune.com"                    "foxbusiness.com"               
#>  [65] "foxnews.com"                    "fr.de"                         
#>  [67] "frankenpost.de"                 "freiepresse.de"                
#>  [69] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [71] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [73] "haz.de"                         "heidelberg24.de"               
#>  [75] "heise.de"                       "hn.cz"                         
#>  [77] "hna.de"                         "huffingtonpost.co.uk"          
#>  [79] "huffingtonpost.com"             "huffpost.com"                  
#>  [81] "idnes.cz"                       "independent.co.uk"             
#>  [83] "independent.ie"                 "infranken.de"                  
#>  [85] "irishexaminer.com"              "irishmirror.ie"                
#>  [87] "irishtimes.com"                 "irozhlas.cz"                   
#>  [89] "joe.ie"                         "jungefreiheit.de"              
#>  [91] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [93] "kreiszeitung.de"                "ksta.de"                       
#>  [95] "kurier.at"                      "latimes.com"                   
#>  [97] "lidovky.cz"                     "lvz.de"                        
#>  [99] "malaymail.com"                  "malaysiakini.com"              
#> [101] "manager.magazin.de"             "marketwatch.com"               
#> [103] "maz.online.de"                  "mdr.de"                        
#> [105] "mediacourant.nl"                "merkur.de"                     
#> [107] "metronieuws.nl"                 "mmajunkie.usatoday.com"        
#> [109] "mopo.de"                        "morgenpost.de"                 
#> [111] "n.tv.de"                        "ndr.de"                        
#> [113] "news.de"                        "news.und.nachrichten.de"       
#> [115] "newsflash24.de"                 "newstatesman.com"              
#> [117] "newsweek.com"                   "nordkurier.de"                 
#> [119] "nos.nl"                         "novinky.cz"                    
#> [121] "noz.de"                         "nrc.nl"                        
#> [123] "nu.nl"                          "nw.de"                         
#> [125] "nypost.com"                     "nytimes.com"                   
#> [127] "nzz.ch"                         "orf.at"                        
#> [129] "ostsee.zeitung.de"              "pagesix.com"                   
#> [131] "parlamentnilisty.cz"            "presseportal.de"               
#> [133] "prosieben.de"                   "rbb24.de"                      
#> [135] "relevanzreporter.de"            "rnd.de"                        
#> [137] "rollingstone.de"                "rp.online.de"                  
#> [139] "rte.ie"                         "rtl.de"                        
#> [141] "rtl.nl"                         "rtlnieuws.nl"                  
#> [143] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [145] "saechsische.de"                 "schwaebische.de"               
#> [147] "seznamzpravy.cz"                "sfgate.com"                    
#> [149] "shz.de"                         "skwawkbox.org"                 
#> [151] "sky.com"                        "spiegel.de"                    
#> [153] "srf.ch"                         "stern.de"                      
#> [155] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [157] "suedkurier.de"                  "swp.de"                        
#> [159] "swr3.de"                        "swr.de"                        
#> [161] "swrfernsehen.de"                "t3n.de"                        
#> [163] "t.online.de"                    "tag24.de"                      
#> [165] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [167] "tagesspiegel.de"                "taz.de"                        
#> [169] "techrepublic.com"               "telegraaf.nl"                  
#> [171] "telegraph.co.uk"                "tennessean.com"                
#> [173] "thecanary.co"                   "theguardian.com"               
#> [175] "thejournal.ie"                  "thesun.ie"                     
#> [177] "thueringer.allgemeine.de"       "time.com"                      
#> [179] "tz.de"                          "us.cnn.com"                    
#> [181] "usatoday.com"                   "vice.com"                      
#> [183] "volkskrant.nl"                  "volksstimme.de"                
#> [185] "vox.de"                         "wa.de"                         
#> [187] "washingtonpost.com"             "watson.ch"                     
#> [189] "watson.de"                      "waz.de"                        
#> [191] "wdr.de"                         "welt.de"                       
#> [193] "wiwo.de"                        "wsj.com"                       
#> [195] "wz.de"                          "yahoo.com"                     
#> [197] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
