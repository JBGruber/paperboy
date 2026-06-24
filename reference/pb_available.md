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
#>  [19] "bnn.de"                         "br.de"                         
#>  [21] "breakingnews.ie"                "breitbart.com"                 
#>  [23] "businessinsider.de"             "buzzfeed.com"                  
#>  [25] "capetownetc.com"                "cbsnews.com"                   
#>  [27] "ceskatelevize.cz"               "cnet.com"                      
#>  [29] "cnn.com"                        "dailymail.co.uk"               
#>  [31] "dailymail.com"                  "decider.com"                   
#>  [33] "democratandchronicle.com"       "denikn.cz"                     
#>  [35] "denverpost.com"                 "der.postillon.com"             
#>  [37] "derstandard.at"                 "derwesten.de"                  
#>  [39] "deutschlandfunk.de"             "deutschlandfunkkultur.de"      
#>  [41] "dnn.de"                         "echo24.de"                     
#>  [43] "edition.cnn.com"                "epochtimes.de"                 
#>  [45] "eu.courier.journal.com"         "eu.democratandchronicle.com"   
#>  [47] "eu.tennessean.com"              "eu.usatoday.com"               
#>  [49] "evolvepolitics.com"             "express.de"                    
#>  [51] "faz.net"                        "finanzen.net"                  
#>  [53] "fnp.de"                         "focus.de"                      
#>  [55] "forbes.com"                     "foxbusiness.com"               
#>  [57] "foxnews.com"                    "fr.de"                         
#>  [59] "frankenpost.de"                 "freiepresse.de"                
#>  [61] "ftw.usatoday.com"               "geenstijl.nl"                  
#>  [63] "golfweek.usatoday.com"          "handelsblatt.com"              
#>  [65] "haz.de"                         "heidelberg24.de"               
#>  [67] "heise.de"                       "hn.cz"                         
#>  [69] "hna.de"                         "huffingtonpost.co.uk"          
#>  [71] "huffingtonpost.com"             "huffpost.com"                  
#>  [73] "idnes.cz"                       "independent.co.uk"             
#>  [75] "independent.ie"                 "infranken.de"                  
#>  [77] "irishexaminer.com"              "irishmirror.ie"                
#>  [79] "irishtimes.com"                 "irozhlas.cz"                   
#>  [81] "joe.ie"                         "jungefreiheit.de"              
#>  [83] "kabeleins.de"                   "karlsruhe.insider.de"          
#>  [85] "kreiszeitung.de"                "ksta.de"                       
#>  [87] "kurier.at"                      "latimes.com"                   
#>  [89] "lidovky.cz"                     "lvz.de"                        
#>  [91] "malaymail.com"                  "malaysiakini.com"              
#>  [93] "manager.magazin.de"             "marketwatch.com"               
#>  [95] "maz.online.de"                  "mdr.de"                        
#>  [97] "mediacourant.nl"                "merkur.de"                     
#>  [99] "metronieuws.nl"                 "mmajunkie.usatoday.com"        
#> [101] "mopo.de"                        "morgenpost.de"                 
#> [103] "n.tv.de"                        "ndr.de"                        
#> [105] "news.de"                        "news.und.nachrichten.de"       
#> [107] "newsflash24.de"                 "newstatesman.com"              
#> [109] "newsweek.com"                   "nordkurier.de"                 
#> [111] "nos.nl"                         "novinky.cz"                    
#> [113] "noz.de"                         "nrc.nl"                        
#> [115] "nu.nl"                          "nw.de"                         
#> [117] "nypost.com"                     "nytimes.com"                   
#> [119] "nzz.ch"                         "orf.at"                        
#> [121] "ostsee.zeitung.de"              "pagesix.com"                   
#> [123] "parlamentnilisty.cz"            "presseportal.de"               
#> [125] "prosieben.de"                   "rbb24.de"                      
#> [127] "rnd.de"                         "rollingstone.de"               
#> [129] "rp.online.de"                   "rte.ie"                        
#> [131] "rtl.de"                         "rtl.nl"                        
#> [133] "rtlnieuws.nl"                   "ruhr24.de"                     
#> [135] "ruhrnachrichten.de"             "saechsische.de"                
#> [137] "schwaebische.de"                "seznamzpravy.cz"               
#> [139] "sfgate.com"                     "shz.de"                        
#> [141] "skwawkbox.org"                  "sky.com"                       
#> [143] "spiegel.de"                     "srf.ch"                        
#> [145] "stern.de"                       "stuttgarter.zeitung.de"        
#> [147] "sueddeutsche.de"                "suedkurier.de"                 
#> [149] "swp.de"                         "swr3.de"                       
#> [151] "swr.de"                         "swrfernsehen.de"               
#> [153] "t3n.de"                         "t.online.de"                   
#> [155] "tag24.de"                       "tagesanzeiger.ch"              
#> [157] "tagesschau.de"                  "tagesspiegel.de"               
#> [159] "taz.de"                         "techrepublic.com"              
#> [161] "telegraaf.nl"                   "telegraph.co.uk"               
#> [163] "thecanary.co"                   "theguardian.com"               
#> [165] "thejournal.ie"                  "thesun.ie"                     
#> [167] "thueringer.allgemeine.de"       "tz.de"                         
#> [169] "us.cnn.com"                     "usatoday.com"                  
#> [171] "vice.com"                       "volkskrant.nl"                 
#> [173] "volksstimme.de"                 "vox.de"                        
#> [175] "wa.de"                          "washingtonpost.com"            
#> [177] "watson.ch"                      "watson.de"                     
#> [179] "waz.de"                         "wdr.de"                        
#> [181] "welt.de"                        "wiwo.de"                       
#> [183] "wsj.com"                        "wz.de"                         
#> [185] "yahoo.com"                      "zdf.de"                        
#> [187] "zeit.de"                       
pb_available("https://edition.cnn.com/",
             "https://www.nytimes.com/",
             "https://www.google.com/")
#> https://edition.cnn.com/ https://www.nytimes.com/  https://www.google.com/ 
#>                     TRUE                     TRUE                    FALSE 
```
