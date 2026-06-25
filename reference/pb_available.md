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
#>  [31] "cnn.com"                        "dailymail.co.uk"               
#>  [33] "dailymail.com"                  "decider.com"                   
#>  [35] "democratandchronicle.com"       "denikn.cz"                     
#>  [37] "denverpost.com"                 "der.postillon.com"             
#>  [39] "derstandard.at"                 "derwesten.de"                  
#>  [41] "deutschlandfunk.de"             "deutschlandfunkkultur.de"      
#>  [43] "dnn.de"                         "echo24.de"                     
#>  [45] "edition.cnn.com"                "epochtimes.de"                 
#>  [47] "eu.courier.journal.com"         "eu.democratandchronicle.com"   
#>  [49] "eu.tennessean.com"              "eu.usatoday.com"               
#>  [51] "evolvepolitics.com"             "express.de"                    
#>  [53] "faz.net"                        "finanzen.net"                  
#>  [55] "fnp.de"                         "focus.de"                      
#>  [57] "forbes.com"                     "foxbusiness.com"               
#>  [59] "foxnews.com"                    "fr.de"                         
#>  [61] "frankenpost.de"                 "freiepresse.de"                
#>  [63] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [65] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [67] "haz.de"                         "heidelberg24.de"               
#>  [69] "heise.de"                       "hn.cz"                         
#>  [71] "hna.de"                         "huffingtonpost.co.uk"          
#>  [73] "huffingtonpost.com"             "huffpost.com"                  
#>  [75] "idnes.cz"                       "independent.co.uk"             
#>  [77] "independent.ie"                 "infranken.de"                  
#>  [79] "irishexaminer.com"              "irishmirror.ie"                
#>  [81] "irishtimes.com"                 "irozhlas.cz"                   
#>  [83] "joe.ie"                         "jungefreiheit.de"              
#>  [85] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [87] "kreiszeitung.de"                "ksta.de"                       
#>  [89] "kurier.at"                      "latimes.com"                   
#>  [91] "lidovky.cz"                     "lvz.de"                        
#>  [93] "malaymail.com"                  "malaysiakini.com"              
#>  [95] "manager.magazin.de"             "marketwatch.com"               
#>  [97] "maz.online.de"                  "mdr.de"                        
#>  [99] "mediacourant.nl"                "merkur.de"                     
#> [101] "metronieuws.nl"                 "mmajunkie.usatoday.com"        
#> [103] "mopo.de"                        "morgenpost.de"                 
#> [105] "n.tv.de"                        "ndr.de"                        
#> [107] "news.de"                        "news.und.nachrichten.de"       
#> [109] "newsflash24.de"                 "newstatesman.com"              
#> [111] "newsweek.com"                   "nordkurier.de"                 
#> [113] "nos.nl"                         "novinky.cz"                    
#> [115] "noz.de"                         "nrc.nl"                        
#> [117] "nu.nl"                          "nw.de"                         
#> [119] "nypost.com"                     "nytimes.com"                   
#> [121] "nzz.ch"                         "orf.at"                        
#> [123] "ostsee.zeitung.de"              "pagesix.com"                   
#> [125] "parlamentnilisty.cz"            "presseportal.de"               
#> [127] "prosieben.de"                   "rbb24.de"                      
#> [129] "rnd.de"                         "rollingstone.de"               
#> [131] "rp.online.de"                   "rte.ie"                        
#> [133] "rtl.de"                         "rtl.nl"                        
#> [135] "rtlnieuws.nl"                   "ruhr24.de"                     
#> [137] "ruhrnachrichten.de"             "saechsische.de"                
#> [139] "schwaebische.de"                "seznamzpravy.cz"               
#> [141] "sfgate.com"                     "shz.de"                        
#> [143] "skwawkbox.org"                  "sky.com"                       
#> [145] "spiegel.de"                     "srf.ch"                        
#> [147] "stern.de"                       "stuttgarter.zeitung.de"        
#> [149] "sueddeutsche.de"                "suedkurier.de"                 
#> [151] "swp.de"                         "swr3.de"                       
#> [153] "swr.de"                         "swrfernsehen.de"               
#> [155] "t3n.de"                         "t.online.de"                   
#> [157] "tag24.de"                       "tagesanzeiger.ch"              
#> [159] "tagesschau.de"                  "tagesspiegel.de"               
#> [161] "taz.de"                         "techrepublic.com"              
#> [163] "telegraaf.nl"                   "telegraph.co.uk"               
#> [165] "thecanary.co"                   "theguardian.com"               
#> [167] "thejournal.ie"                  "thesun.ie"                     
#> [169] "thueringer.allgemeine.de"       "tz.de"                         
#> [171] "us.cnn.com"                     "usatoday.com"                  
#> [173] "vice.com"                       "volkskrant.nl"                 
#> [175] "volksstimme.de"                 "vox.de"                        
#> [177] "wa.de"                          "washingtonpost.com"            
#> [179] "watson.ch"                      "watson.de"                     
#> [181] "waz.de"                         "wdr.de"                        
#> [183] "welt.de"                        "wiwo.de"                       
#> [185] "wsj.com"                        "wz.de"                         
#> [187] "yahoo.com"                      "zdf.de"                        
#> [189] "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
