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
#>  [47] "dnn.de"                         "echo24.de"                     
#>  [49] "edition.cnn.com"                "epochtimes.de"                 
#>  [51] "eu.courier.journal.com"         "eu.democratandchronicle.com"   
#>  [53] "eu.tennessean.com"              "eu.usatoday.com"               
#>  [55] "evolvepolitics.com"             "express.de"                    
#>  [57] "faz.net"                        "finanzen.net"                  
#>  [59] "fnp.de"                         "focus.de"                      
#>  [61] "forbes.com"                     "fortune.com"                   
#>  [63] "foxbusiness.com"                "foxnews.com"                   
#>  [65] "fr.de"                          "frankenpost.de"                
#>  [67] "freiepresse.de"                 "ftw.usatoday.com"              
#>  [69] "geenstijl.nl"                   "golfweek.usatoday.com"         
#>  [71] "handelsblatt.com"               "haz.de"                        
#>  [73] "heidelberg24.de"                "heise.de"                      
#>  [75] "hn.cz"                          "hna.de"                        
#>  [77] "huffingtonpost.co.uk"           "huffingtonpost.com"            
#>  [79] "huffpost.com"                   "idnes.cz"                      
#>  [81] "independent.co.uk"              "independent.ie"                
#>  [83] "infranken.de"                   "irishexaminer.com"             
#>  [85] "irishmirror.ie"                 "irishtimes.com"                
#>  [87] "irozhlas.cz"                    "joe.ie"                        
#>  [89] "jungefreiheit.de"               "kabeleins.de"                  
#>  [91] "karlsruhe.insider.de"           "kreiszeitung.de"               
#>  [93] "ksta.de"                        "kurier.at"                     
#>  [95] "latimes.com"                    "lidovky.cz"                    
#>  [97] "lvz.de"                         "malaymail.com"                 
#>  [99] "malaysiakini.com"               "manager.magazin.de"            
#> [101] "marketwatch.com"                "maz.online.de"                 
#> [103] "mdr.de"                         "mediacourant.nl"               
#> [105] "merkur.de"                      "metronieuws.nl"                
#> [107] "mmajunkie.usatoday.com"         "mopo.de"                       
#> [109] "morgenpost.de"                  "n.tv.de"                       
#> [111] "ndr.de"                         "news.de"                       
#> [113] "news.und.nachrichten.de"        "newsflash24.de"                
#> [115] "newstatesman.com"               "newsweek.com"                  
#> [117] "nordkurier.de"                  "nos.nl"                        
#> [119] "novinky.cz"                     "noz.de"                        
#> [121] "nrc.nl"                         "nu.nl"                         
#> [123] "nw.de"                          "nypost.com"                    
#> [125] "nytimes.com"                    "nzz.ch"                        
#> [127] "orf.at"                         "ostsee.zeitung.de"             
#> [129] "pagesix.com"                    "parlamentnilisty.cz"           
#> [131] "presseportal.de"                "prosieben.de"                  
#> [133] "rbb24.de"                       "rnd.de"                        
#> [135] "rollingstone.de"                "rp.online.de"                  
#> [137] "rte.ie"                         "rtl.de"                        
#> [139] "rtl.nl"                         "rtlnieuws.nl"                  
#> [141] "ruhr24.de"                      "ruhrnachrichten.de"            
#> [143] "saechsische.de"                 "schwaebische.de"               
#> [145] "seznamzpravy.cz"                "sfgate.com"                    
#> [147] "shz.de"                         "skwawkbox.org"                 
#> [149] "sky.com"                        "spiegel.de"                    
#> [151] "srf.ch"                         "stern.de"                      
#> [153] "stuttgarter.zeitung.de"         "sueddeutsche.de"               
#> [155] "suedkurier.de"                  "swp.de"                        
#> [157] "swr3.de"                        "swr.de"                        
#> [159] "swrfernsehen.de"                "t3n.de"                        
#> [161] "t.online.de"                    "tag24.de"                      
#> [163] "tagesanzeiger.ch"               "tagesschau.de"                 
#> [165] "tagesspiegel.de"                "taz.de"                        
#> [167] "techrepublic.com"               "telegraaf.nl"                  
#> [169] "telegraph.co.uk"                "tennessean.com"                
#> [171] "thecanary.co"                   "theguardian.com"               
#> [173] "thejournal.ie"                  "thesun.ie"                     
#> [175] "thueringer.allgemeine.de"       "time.com"                      
#> [177] "tz.de"                          "us.cnn.com"                    
#> [179] "usatoday.com"                   "vice.com"                      
#> [181] "volkskrant.nl"                  "volksstimme.de"                
#> [183] "vox.de"                         "wa.de"                         
#> [185] "washingtonpost.com"             "watson.ch"                     
#> [187] "watson.de"                      "waz.de"                        
#> [189] "wdr.de"                         "welt.de"                       
#> [191] "wiwo.de"                        "wsj.com"                       
#> [193] "wz.de"                          "yahoo.com"                     
#> [195] "zdf.de"                         "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
