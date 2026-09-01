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
#>  [25] "breitbart.com"                  "businessinsider.de"            
#>  [27] "buzzfeed.com"                   "capetownetc.com"               
#>  [29] "cbsnews.com"                    "ceskatelevize.cz"              
#>  [31] "cnet.com"                       "cnn.com"                       
#>  [33] "cnnbrasil.com.br"               "courier.journal.com"           
#>  [35] "dailymail.co.uk"                "dailymail.com"                 
#>  [37] "decider.com"                    "democratandchronicle.com"      
#>  [39] "denikn.cz"                      "denverpost.com"                
#>  [41] "der.postillon.com"              "derstandard.at"                
#>  [43] "derwesten.de"                   "deutschlandfunk.de"            
#>  [45] "deutschlandfunkkultur.de"       "dnn.de"                        
#>  [47] "echo24.de"                      "edition.cnn.com"               
#>  [49] "epochtimes.de"                  "eu.courier.journal.com"        
#>  [51] "eu.democratandchronicle.com"    "eu.tennessean.com"             
#>  [53] "eu.usatoday.com"                "evolvepolitics.com"            
#>  [55] "express.de"                     "faz.net"                       
#>  [57] "finanzen.net"                   "fnp.de"                        
#>  [59] "focus.de"                       "forbes.com"                    
#>  [61] "fortune.com"                    "foxbusiness.com"               
#>  [63] "foxnews.com"                    "fr.de"                         
#>  [65] "frankenpost.de"                 "freiepresse.de"                
#>  [67] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [69] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [71] "haz.de"                         "heidelberg24.de"               
#>  [73] "heise.de"                       "hn.cz"                         
#>  [75] "hna.de"                         "huffingtonpost.co.uk"          
#>  [77] "huffingtonpost.com"             "huffpost.com"                  
#>  [79] "idnes.cz"                       "independent.co.uk"             
#>  [81] "independent.ie"                 "infranken.de"                  
#>  [83] "irishexaminer.com"              "irishmirror.ie"                
#>  [85] "irishtimes.com"                 "irozhlas.cz"                   
#>  [87] "joe.ie"                         "jungefreiheit.de"              
#>  [89] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [91] "kreiszeitung.de"                "ksta.de"                       
#>  [93] "kurier.at"                      "latimes.com"                   
#>  [95] "lidovky.cz"                     "lvz.de"                        
#>  [97] "malaymail.com"                  "malaysiakini.com"              
#>  [99] "manager.magazin.de"             "marketwatch.com"               
#> [101] "maz.online.de"                  "mdr.de"                        
#> [103] "mediacourant.nl"                "merkur.de"                     
#> [105] "metronieuws.nl"                 "mmajunkie.usatoday.com"        
#> [107] "mopo.de"                        "morgenpost.de"                 
#> [109] "n.tv.de"                        "ndr.de"                        
#> [111] "news.de"                        "news.und.nachrichten.de"       
#> [113] "newsflash24.de"                 "newstatesman.com"              
#> [115] "newsweek.com"                   "nordkurier.de"                 
#> [117] "nos.nl"                         "novinky.cz"                    
#> [119] "noz.de"                         "nrc.nl"                        
#> [121] "nu.nl"                          "nw.de"                         
#> [123] "nypost.com"                     "nytimes.com"                   
#> [125] "nzz.ch"                         "orf.at"                        
#> [127] "ostsee.zeitung.de"              "pagesix.com"                   
#> [129] "parlamentnilisty.cz"            "presseportal.de"               
#> [131] "prosieben.de"                   "rbb24.de"                      
#> [133] "rnd.de"                         "rollingstone.de"               
#> [135] "rp.online.de"                   "rte.ie"                        
#> [137] "rtl.de"                         "rtl.nl"                        
#> [139] "rtlnieuws.nl"                   "ruhr24.de"                     
#> [141] "ruhrnachrichten.de"             "saechsische.de"                
#> [143] "schwaebische.de"                "seznamzpravy.cz"               
#> [145] "sfgate.com"                     "shz.de"                        
#> [147] "skwawkbox.org"                  "sky.com"                       
#> [149] "spiegel.de"                     "srf.ch"                        
#> [151] "stern.de"                       "stuttgarter.zeitung.de"        
#> [153] "sueddeutsche.de"                "suedkurier.de"                 
#> [155] "swp.de"                         "swr3.de"                       
#> [157] "swr.de"                         "swrfernsehen.de"               
#> [159] "t3n.de"                         "t.online.de"                   
#> [161] "tag24.de"                       "tagesanzeiger.ch"              
#> [163] "tagesschau.de"                  "tagesspiegel.de"               
#> [165] "taz.de"                         "techrepublic.com"              
#> [167] "telegraaf.nl"                   "telegraph.co.uk"               
#> [169] "tennessean.com"                 "thecanary.co"                  
#> [171] "theguardian.com"                "thejournal.ie"                 
#> [173] "thesun.ie"                      "thueringer.allgemeine.de"      
#> [175] "time.com"                       "tz.de"                         
#> [177] "us.cnn.com"                     "usatoday.com"                  
#> [179] "vice.com"                       "volkskrant.nl"                 
#> [181] "volksstimme.de"                 "vox.de"                        
#> [183] "wa.de"                          "washingtonpost.com"            
#> [185] "watson.ch"                      "watson.de"                     
#> [187] "waz.de"                         "wdr.de"                        
#> [189] "welt.de"                        "wiwo.de"                       
#> [191] "wsj.com"                        "wz.de"                         
#> [193] "yahoo.com"                      "zdf.de"                        
#> [195] "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
