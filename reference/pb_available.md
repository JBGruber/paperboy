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
#> [133] "rbb24.de"                       "relevanzreporter.de"           
#> [135] "rnd.de"                         "rollingstone.de"               
#> [137] "rp.online.de"                   "rte.ie"                        
#> [139] "rtl.de"                         "rtl.nl"                        
#> [141] "rtlnieuws.nl"                   "ruhr24.de"                     
#> [143] "ruhrnachrichten.de"             "saechsische.de"                
#> [145] "schwaebische.de"                "seznamzpravy.cz"               
#> [147] "sfgate.com"                     "shz.de"                        
#> [149] "skwawkbox.org"                  "sky.com"                       
#> [151] "spiegel.de"                     "srf.ch"                        
#> [153] "stern.de"                       "stuttgarter.zeitung.de"        
#> [155] "sueddeutsche.de"                "suedkurier.de"                 
#> [157] "swp.de"                         "swr3.de"                       
#> [159] "swr.de"                         "swrfernsehen.de"               
#> [161] "t3n.de"                         "t.online.de"                   
#> [163] "tag24.de"                       "tagesanzeiger.ch"              
#> [165] "tagesschau.de"                  "tagesspiegel.de"               
#> [167] "taz.de"                         "techrepublic.com"              
#> [169] "telegraaf.nl"                   "telegraph.co.uk"               
#> [171] "tennessean.com"                 "thecanary.co"                  
#> [173] "theguardian.com"                "thejournal.ie"                 
#> [175] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [177] "time.com"                       "tz.de"                         
#> [179] "us.cnn.com"                     "usatoday.com"                  
#> [181] "vice.com"                       "volkskrant.nl"                 
#> [183] "volksstimme.de"                 "vox.de"                        
#> [185] "wa.de"                          "washingtonpost.com"            
#> [187] "watson.ch"                      "watson.de"                     
#> [189] "waz.de"                         "wdr.de"                        
#> [191] "welt.de"                        "wiwo.de"                       
#> [193] "wsj.com"                        "wz.de"                         
#> [195] "yahoo.com"                      "zdf.de"                        
#> [197] "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
