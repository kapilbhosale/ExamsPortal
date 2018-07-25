class Students::HomeController < ApplicationController
  def index
    @styles = '.lst-kix_39wbwk7b1djn-6>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-6,decimal) ". "}ol.lst-kix_z66j5kez7t2d-0.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-0 1}.lst-kix_39wbwk7b1djn-5>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-5,lower-roman) ". "}.lst-kix_39wbwk7b1djn-2>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-2,lower-roman) ". "}ol.lst-kix_ytqu4jrtcbsv-3.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-3 0}.lst-kix_39wbwk7b1djn-4>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-4,lower-latin) ". "}.lst-kix_39wbwk7b1djn-3>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-3,decimal) ". "}ol.lst-kix_nuxp4se5bubj-3.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-3 0}.lst-kix_z66j5kez7t2d-6>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-6}.lst-kix_39wbwk7b1djn-1>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-1,lower-latin) ". "}ol.lst-kix_psjm00bsbse0-8.start{counter-reset:lst-ctn-kix_psjm00bsbse0-8 0}.lst-kix_lrbu2hc8h017-8>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-8}.lst-kix_39wbwk7b1djn-0>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-0,decimal) ". "}.lst-kix_39wbwk7b1djn-6>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-6}ol.lst-kix_16jwsyg2bo35-1.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-1 0}ol.lst-kix_psjm00bsbse0-3.start{counter-reset:lst-ctn-kix_psjm00bsbse0-3 0}ol.lst-kix_mpfdnljw2ui-4.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-4 0}ol.lst-kix_92rtpbbyfxpt-3.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-3 0}.lst-kix_92rtpbbyfxpt-2>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-2}ol.lst-kix_ytqu4jrtcbsv-8.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-8 0}.lst-kix_t3gzkgsex1j8-5>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-5}.lst-kix_ghjdfzl651et-7>li{counter-increment:lst-ctn-kix_ghjdfzl651et-7}.lst-kix_f5lbk9pt02k3-0>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-0}.lst-kix_39wbwk7b1djn-8>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-8,lower-roman) ". "}.lst-kix_39wbwk7b1djn-7>li:before{content:"" counter(lst-ctn-kix_39wbwk7b1djn-7,lower-latin) ". "}.lst-kix_5ltos5434750-0>li{counter-increment:lst-ctn-kix_5ltos5434750-0}ol.lst-kix_avs0v18voip7-0.start{counter-reset:lst-ctn-kix_avs0v18voip7-0 29}ol.lst-kix_z66j5kez7t2d-5.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-5 0}.lst-kix_lrbu2hc8h017-4>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-4}ol.lst-kix_92rtpbbyfxpt-8{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-7{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-6{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-5{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-0{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-4{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-3{list-style-type:none}ol.lst-kix_ghjdfzl651et-4.start{counter-reset:lst-ctn-kix_ghjdfzl651et-4 0}ol.lst-kix_92rtpbbyfxpt-2{list-style-type:none}ol.lst-kix_92rtpbbyfxpt-1{list-style-type:none}ol.lst-kix_39wbwk7b1djn-8.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-8 0}.lst-kix_ytqu4jrtcbsv-5>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-5}ol.lst-kix_39wbwk7b1djn-1.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-1 0}.lst-kix_nuxp4se5bubj-5>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-5}ol.lst-kix_ytqu4jrtcbsv-4{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-5{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-2{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-3{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-0{list-style-type:none}.lst-kix_8bnlqh6lso62-3>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-3}ol.lst-kix_ytqu4jrtcbsv-1{list-style-type:none}.lst-kix_5qvxdvnm85f3-3>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-3}.lst-kix_8bnlqh6lso62-6>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-6}.lst-kix_mpfdnljw2ui-2>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-2}ol.lst-kix_ytqu4jrtcbsv-8{list-style-type:none}.lst-kix_mpfdnljw2ui-5>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-5}ol.lst-kix_ytqu4jrtcbsv-6{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-7{list-style-type:none}ol.lst-kix_nuxp4se5bubj-2{list-style-type:none}ol.lst-kix_z66j5kez7t2d-7.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-7 0}ol.lst-kix_nuxp4se5bubj-3{list-style-type:none}.lst-kix_5qvxdvnm85f3-7>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-7}ol.lst-kix_nuxp4se5bubj-4{list-style-type:none}ol.lst-kix_nuxp4se5bubj-5{list-style-type:none}.lst-kix_avs0v18voip7-2>li{counter-increment:lst-ctn-kix_avs0v18voip7-2}.lst-kix_f5lbk9pt02k3-7>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-7}ol.lst-kix_nuxp4se5bubj-0{list-style-type:none}ol.lst-kix_nuxp4se5bubj-1{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-3.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-3 0}ol.lst-kix_5ltos5434750-1.start{counter-reset:lst-ctn-kix_5ltos5434750-1 0}ol.lst-kix_nuxp4se5bubj-6{list-style-type:none}ol.lst-kix_nuxp4se5bubj-7{list-style-type:none}.lst-kix_39wbwk7b1djn-2>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-2}ol.lst-kix_nuxp4se5bubj-8{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-2.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-2 0}ol.lst-kix_lrbu2hc8h017-0.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-0 6}ol.lst-kix_psjm00bsbse0-1.start{counter-reset:lst-ctn-kix_psjm00bsbse0-1 0}.lst-kix_avs0v18voip7-1>li{counter-increment:lst-ctn-kix_avs0v18voip7-1}ol.lst-kix_lrbu2hc8h017-8.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-8 0}.lst-kix_f5lbk9pt02k3-8>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-8}.lst-kix_5ltos5434750-8>li{counter-increment:lst-ctn-kix_5ltos5434750-8}ol.lst-kix_16jwsyg2bo35-0{list-style-type:none}.lst-kix_5qvxdvnm85f3-2>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-2,lower-roman) ". "}.lst-kix_5qvxdvnm85f3-4>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-4,lower-latin) ". "}ol.lst-kix_16jwsyg2bo35-2{list-style-type:none}ol.lst-kix_ghjdfzl651et-7.start{counter-reset:lst-ctn-kix_ghjdfzl651et-7 0}ol.lst-kix_16jwsyg2bo35-1{list-style-type:none}ol.lst-kix_16jwsyg2bo35-4{list-style-type:none}ol.lst-kix_f5lbk9pt02k3-2.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-2 0}.lst-kix_lrbu2hc8h017-0>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-0}ol.lst-kix_16jwsyg2bo35-3{list-style-type:none}ol.lst-kix_39wbwk7b1djn-3.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-3 0}ol.lst-kix_16jwsyg2bo35-8.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-8 0}ol.lst-kix_nuxp4se5bubj-1.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-1 0}ol.lst-kix_39wbwk7b1djn-6.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-6 0}.lst-kix_5qvxdvnm85f3-0>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-0,decimal) ". "}.lst-kix_5qvxdvnm85f3-8>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-8,lower-roman) ". "}ol.lst-kix_avs0v18voip7-0{list-style-type:none}ol.lst-kix_z66j5kez7t2d-0{list-style-type:none}ol.lst-kix_avs0v18voip7-2{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-1.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-1 0}ol.lst-kix_avs0v18voip7-1{list-style-type:none}ol.lst-kix_z66j5kez7t2d-3{list-style-type:none}ol.lst-kix_z66j5kez7t2d-4{list-style-type:none}ol.lst-kix_z66j5kez7t2d-1{list-style-type:none}ol.lst-kix_z66j5kez7t2d-2{list-style-type:none}ol.lst-kix_16jwsyg2bo35-6{list-style-type:none}ol.lst-kix_avs0v18voip7-8{list-style-type:none}ol.lst-kix_z66j5kez7t2d-7{list-style-type:none}ol.lst-kix_16jwsyg2bo35-5{list-style-type:none}ol.lst-kix_avs0v18voip7-7{list-style-type:none}ol.lst-kix_z66j5kez7t2d-8{list-style-type:none}ol.lst-kix_16jwsyg2bo35-8{list-style-type:none}ol.lst-kix_z66j5kez7t2d-5{list-style-type:none}.lst-kix_5qvxdvnm85f3-6>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-6,decimal) ". "}ol.lst-kix_16jwsyg2bo35-7{list-style-type:none}ol.lst-kix_z66j5kez7t2d-6{list-style-type:none}ol.lst-kix_8bnlqh6lso62-7.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-7 0}.lst-kix_nuxp4se5bubj-1>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-1}ol.lst-kix_avs0v18voip7-4{list-style-type:none}ol.lst-kix_avs0v18voip7-3{list-style-type:none}ol.lst-kix_avs0v18voip7-6{list-style-type:none}ol.lst-kix_avs0v18voip7-5{list-style-type:none}ol.lst-kix_avs0v18voip7-7.start{counter-reset:lst-ctn-kix_avs0v18voip7-7 0}ol.lst-kix_lrbu2hc8h017-6{list-style-type:none}ol.lst-kix_lrbu2hc8h017-5{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-4.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-4 0}.lst-kix_lrbu2hc8h017-5>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-5}ol.lst-kix_lrbu2hc8h017-8{list-style-type:none}ol.lst-kix_lrbu2hc8h017-7{list-style-type:none}ol.lst-kix_f5lbk9pt02k3-4.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-4 0}ol.lst-kix_lrbu2hc8h017-0{list-style-type:none}ol.lst-kix_lrbu2hc8h017-2{list-style-type:none}ol.lst-kix_lrbu2hc8h017-1{list-style-type:none}ol.lst-kix_lrbu2hc8h017-4{list-style-type:none}ol.lst-kix_lrbu2hc8h017-3{list-style-type:none}.lst-kix_ytqu4jrtcbsv-1>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-1}ol.lst-kix_5qvxdvnm85f3-5.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-5 0}.lst-kix_39wbwk7b1djn-3>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-3}ol.lst-kix_92rtpbbyfxpt-1.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-1 0}.lst-kix_lrbu2hc8h017-3>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-3,decimal) ". "}.lst-kix_nuxp4se5bubj-8>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-8,lower-roman) ". "}.lst-kix_psjm00bsbse0-6>li{counter-increment:lst-ctn-kix_psjm00bsbse0-6}ol.lst-kix_16jwsyg2bo35-6.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-6 0}.lst-kix_5ltos5434750-7>li{counter-increment:lst-ctn-kix_5ltos5434750-7}.lst-kix_5ltos5434750-1>li{counter-increment:lst-ctn-kix_5ltos5434750-1}.lst-kix_lrbu2hc8h017-5>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-5,lower-roman) ". "}.lst-kix_16jwsyg2bo35-2>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-2}.lst-kix_ghjdfzl651et-0>li{counter-increment:lst-ctn-kix_ghjdfzl651et-0}.lst-kix_92rtpbbyfxpt-3>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-3}.lst-kix_lrbu2hc8h017-7>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-7,lower-latin) ". "}ol.lst-kix_nuxp4se5bubj-0.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-0 2}ol.lst-kix_ghjdfzl651et-6.start{counter-reset:lst-ctn-kix_ghjdfzl651et-6 0}.lst-kix_f5lbk9pt02k3-1>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-1}ol.lst-kix_5ltos5434750-8.start{counter-reset:lst-ctn-kix_5ltos5434750-8 0}.lst-kix_z66j5kez7t2d-7>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-7}.lst-kix_39wbwk7b1djn-7>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-7}.lst-kix_avs0v18voip7-8>li{counter-increment:lst-ctn-kix_avs0v18voip7-8}.lst-kix_nuxp4se5bubj-6>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-6}ol.lst-kix_5qvxdvnm85f3-7.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-7 0}.lst-kix_lrbu2hc8h017-7>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-7}ol.lst-kix_lrbu2hc8h017-1.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-1 0}ol.lst-kix_16jwsyg2bo35-4.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-4 0}ol.lst-kix_5ltos5434750-2.start{counter-reset:lst-ctn-kix_5ltos5434750-2 0}ol.lst-kix_92rtpbbyfxpt-6.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-6 0}.lst-kix_lrbu2hc8h017-1>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-1,lower-latin) ". "}ol.lst-kix_z66j5kez7t2d-3.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-3 0}.lst-kix_lrbu2hc8h017-0>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-0,decimal) ". "}.lst-kix_ytqu4jrtcbsv-4>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-4}.lst-kix_8bnlqh6lso62-0>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-0,decimal) ". "}.lst-kix_8bnlqh6lso62-1>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-1,lower-latin) ". "}ol.lst-kix_ghjdfzl651et-0.start{counter-reset:lst-ctn-kix_ghjdfzl651et-0 2}.lst-kix_16jwsyg2bo35-6>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-6,decimal) ". "}.lst-kix_nuxp4se5bubj-4>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-4,lower-latin) ". "}.lst-kix_avs0v18voip7-6>li{counter-increment:lst-ctn-kix_avs0v18voip7-6}.lst-kix_16jwsyg2bo35-3>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-3,decimal) ". "}.lst-kix_16jwsyg2bo35-7>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-7,lower-latin) ". "}.lst-kix_nuxp4se5bubj-3>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-3,decimal) ". "}.lst-kix_92rtpbbyfxpt-5>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-5}.lst-kix_16jwsyg2bo35-3>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-3}.lst-kix_z66j5kez7t2d-5>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-5}.lst-kix_f5lbk9pt02k3-3>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-3}.lst-kix_nuxp4se5bubj-0>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-0,decimal) ". "}ol.lst-kix_t3gzkgsex1j8-1.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-1 0}.lst-kix_39wbwk7b1djn-5>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-5}.lst-kix_ytqu4jrtcbsv-6>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-6}.lst-kix_nuxp4se5bubj-4>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-4}.lst-kix_t3gzkgsex1j8-8>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-8}ol.lst-kix_5ltos5434750-3.start{counter-reset:lst-ctn-kix_5ltos5434750-3 0}.lst-kix_92rtpbbyfxpt-7>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-7}.lst-kix_ghjdfzl651et-1>li{counter-increment:lst-ctn-kix_ghjdfzl651et-1}ol.lst-kix_5qvxdvnm85f3-8.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-8 0}ol.lst-kix_psjm00bsbse0-6.start{counter-reset:lst-ctn-kix_psjm00bsbse0-6 0}ol.lst-kix_lrbu2hc8h017-6.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-6 0}.lst-kix_f5lbk9pt02k3-5>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-5}.lst-kix_avs0v18voip7-4>li{counter-increment:lst-ctn-kix_avs0v18voip7-4}ol.lst-kix_f5lbk9pt02k3-1.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-1 0}.lst-kix_92rtpbbyfxpt-3>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-3,decimal) ". "}.lst-kix_t3gzkgsex1j8-6>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-6}.lst-kix_ghjdfzl651et-8>li{counter-increment:lst-ctn-kix_ghjdfzl651et-8}.lst-kix_ytqu4jrtcbsv-2>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-2}.lst-kix_5qvxdvnm85f3-0>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-0}.lst-kix_92rtpbbyfxpt-2>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-2,lower-roman) ". "}.lst-kix_92rtpbbyfxpt-6>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-6,decimal) ". "}ol.lst-kix_ghjdfzl651et-5.start{counter-reset:lst-ctn-kix_ghjdfzl651et-5 0}ol.lst-kix_f5lbk9pt02k3-0.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-0 4}.lst-kix_92rtpbbyfxpt-7>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-7,lower-latin) ". "}.lst-kix_nuxp4se5bubj-2>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-2}ol.lst-kix_psjm00bsbse0-5.start{counter-reset:lst-ctn-kix_psjm00bsbse0-5 0}ol.lst-kix_t3gzkgsex1j8-0.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-0 0}ol.lst-kix_16jwsyg2bo35-3.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-3 0}ol.lst-kix_92rtpbbyfxpt-5.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-5 0}ol.lst-kix_lrbu2hc8h017-7.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-7 0}.lst-kix_avs0v18voip7-3>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-3,decimal) ". "}ol.lst-kix_16jwsyg2bo35-0.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-0 5}ol.lst-kix_t3gzkgsex1j8-8{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-7{list-style-type:none}.lst-kix_avs0v18voip7-7>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-7,lower-latin) ". "}ol.lst-kix_t3gzkgsex1j8-6{list-style-type:none}.lst-kix_ytqu4jrtcbsv-6>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-6,decimal) ". "}ol.lst-kix_t3gzkgsex1j8-5{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-4{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-3{list-style-type:none}.lst-kix_lrbu2hc8h017-2>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-2}ol.lst-kix_t3gzkgsex1j8-2{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-1{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-0{list-style-type:none}.lst-kix_z66j5kez7t2d-0>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-0}.lst-kix_t3gzkgsex1j8-5>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-5,lower-roman) ". "}.lst-kix_t3gzkgsex1j8-1>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-1,lower-latin) ". "}.lst-kix_5ltos5434750-2>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-2,lower-roman) ". "}.lst-kix_39wbwk7b1djn-0>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-0}ol.lst-kix_z66j5kez7t2d-1.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-1 0}ol.lst-kix_5ltos5434750-4.start{counter-reset:lst-ctn-kix_5ltos5434750-4 0}.lst-kix_z66j5kez7t2d-5>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-5,lower-roman) ". "}.lst-kix_5qvxdvnm85f3-3>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-3,decimal) ". "}.lst-kix_5qvxdvnm85f3-7>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-7,lower-latin) ". "}ol.lst-kix_lrbu2hc8h017-5.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-5 0}.lst-kix_z66j5kez7t2d-2>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-2}.lst-kix_5ltos5434750-6>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-6,decimal) ". "}.lst-kix_ytqu4jrtcbsv-2>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-2,lower-roman) ". "}ol.lst-kix_92rtpbbyfxpt-7.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-7 0}.lst-kix_z66j5kez7t2d-1>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-1,lower-latin) ". "}ol.lst-kix_z66j5kez7t2d-4.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-4 0}ol.lst-kix_lrbu2hc8h017-2.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-2 0}ol.lst-kix_psjm00bsbse0-7.start{counter-reset:lst-ctn-kix_psjm00bsbse0-7 0}.lst-kix_8bnlqh6lso62-8>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-8}ol.lst-kix_z66j5kez7t2d-2.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-2 0}ol.lst-kix_ghjdfzl651et-1.start{counter-reset:lst-ctn-kix_ghjdfzl651et-1 0}.lst-kix_ghjdfzl651et-5>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-5,lower-roman) ". "}.lst-kix_mpfdnljw2ui-0>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-0}.lst-kix_5qvxdvnm85f3-5>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-5}.lst-kix_8bnlqh6lso62-1>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-1}.lst-kix_mpfdnljw2ui-7>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-7}.lst-kix_ghjdfzl651et-1>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-1,lower-latin) ". "}ol.lst-kix_lrbu2hc8h017-3.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-3 0}ol.lst-kix_5ltos5434750-7.start{counter-reset:lst-ctn-kix_5ltos5434750-7 0}.lst-kix_nuxp4se5bubj-7>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-7,lower-latin) ". "}.lst-kix_psjm00bsbse0-3>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-3,decimal) ". "}.lst-kix_f5lbk9pt02k3-4>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-4,lower-latin) ". "}.lst-kix_f5lbk9pt02k3-8>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-8,lower-roman) ". "}.lst-kix_psjm00bsbse0-3>li{counter-increment:lst-ctn-kix_psjm00bsbse0-3}.lst-kix_8bnlqh6lso62-4>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-4,lower-latin) ". "}.lst-kix_mpfdnljw2ui-3>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-3,decimal) ". "}ol.lst-kix_92rtpbbyfxpt-8.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-8 0}ol.lst-kix_ghjdfzl651et-2.start{counter-reset:lst-ctn-kix_ghjdfzl651et-2 0}.lst-kix_5ltos5434750-4>li{counter-increment:lst-ctn-kix_5ltos5434750-4}.lst-kix_lrbu2hc8h017-4>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-4,lower-latin) ". "}.lst-kix_8bnlqh6lso62-8>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-8,lower-roman) ". "}.lst-kix_mpfdnljw2ui-7>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-7,lower-latin) ". "}.lst-kix_ghjdfzl651et-3>li{counter-increment:lst-ctn-kix_ghjdfzl651et-3}.lst-kix_t3gzkgsex1j8-1>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-1}.lst-kix_f5lbk9pt02k3-0>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-0,decimal) ". "}ol.lst-kix_5ltos5434750-6.start{counter-reset:lst-ctn-kix_5ltos5434750-6 0}.lst-kix_16jwsyg2bo35-5>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-5}.lst-kix_92rtpbbyfxpt-0>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-0}.lst-kix_psjm00bsbse0-7>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-7,lower-latin) ". "}.lst-kix_lrbu2hc8h017-8>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-8,lower-roman) ". "}.lst-kix_92rtpbbyfxpt-4>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-4}.lst-kix_5qvxdvnm85f3-1>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-1}ol.lst-kix_lrbu2hc8h017-4.start{counter-reset:lst-ctn-kix_lrbu2hc8h017-4 0}.lst-kix_5ltos5434750-2>li{counter-increment:lst-ctn-kix_5ltos5434750-2}.lst-kix_t3gzkgsex1j8-7>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-7}ol.lst-kix_39wbwk7b1djn-7.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-7 0}ol.lst-kix_f5lbk9pt02k3-3.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-3 0}ol.lst-kix_5ltos5434750-5.start{counter-reset:lst-ctn-kix_5ltos5434750-5 0}ol.lst-kix_16jwsyg2bo35-7.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-7 0}.lst-kix_avs0v18voip7-7>li{counter-increment:lst-ctn-kix_avs0v18voip7-7}.lst-kix_f5lbk9pt02k3-2>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-2}ol.lst-kix_8bnlqh6lso62-3.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-3 0}ol.lst-kix_5qvxdvnm85f3-4.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-4 0}.lst-kix_z66j5kez7t2d-8>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-8}ol.lst-kix_avs0v18voip7-1.start{counter-reset:lst-ctn-kix_avs0v18voip7-1 0}.lst-kix_16jwsyg2bo35-0>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-0}.lst-kix_psjm00bsbse0-8>li{counter-increment:lst-ctn-kix_psjm00bsbse0-8}ol.lst-kix_ghjdfzl651et-3.start{counter-reset:lst-ctn-kix_ghjdfzl651et-3 0}.lst-kix_39wbwk7b1djn-8>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-8}ol.lst-kix_5qvxdvnm85f3-0{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-1{list-style-type:none}.lst-kix_ytqu4jrtcbsv-3>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-3}ol.lst-kix_5qvxdvnm85f3-4{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-5{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-2{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-3{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-8{list-style-type:none}.lst-kix_nuxp4se5bubj-7>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-7}ol.lst-kix_5qvxdvnm85f3-6{list-style-type:none}ol.lst-kix_5qvxdvnm85f3-7{list-style-type:none}.lst-kix_lrbu2hc8h017-6>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-6}ol.lst-kix_92rtpbbyfxpt-4.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-4 0}.lst-kix_16jwsyg2bo35-4>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-4}.lst-kix_39wbwk7b1djn-4>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-4}ol.lst-kix_16jwsyg2bo35-2.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-2 0}ol.lst-kix_mpfdnljw2ui-3.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-3 0}ol.lst-kix_f5lbk9pt02k3-8.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-8 0}ol.lst-kix_39wbwk7b1djn-2.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-2 0}ol.lst-kix_ytqu4jrtcbsv-2.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-2 0}.lst-kix_ghjdfzl651et-2>li{counter-increment:lst-ctn-kix_ghjdfzl651et-2}.lst-kix_92rtpbbyfxpt-8>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-8}.lst-kix_psjm00bsbse0-1>li{counter-increment:lst-ctn-kix_psjm00bsbse0-1}.lst-kix_t3gzkgsex1j8-3>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-3}ol.lst-kix_avs0v18voip7-6.start{counter-reset:lst-ctn-kix_avs0v18voip7-6 0}ol.lst-kix_39wbwk7b1djn-8{list-style-type:none}ol.lst-kix_z66j5kez7t2d-6.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-6 0}ol.lst-kix_39wbwk7b1djn-4{list-style-type:none}ol.lst-kix_39wbwk7b1djn-5{list-style-type:none}ol.lst-kix_39wbwk7b1djn-6{list-style-type:none}ol.lst-kix_39wbwk7b1djn-7{list-style-type:none}ol.lst-kix_39wbwk7b1djn-0{list-style-type:none}ol.lst-kix_39wbwk7b1djn-1{list-style-type:none}ol.lst-kix_39wbwk7b1djn-2{list-style-type:none}ol.lst-kix_39wbwk7b1djn-3{list-style-type:none}ol.lst-kix_mpfdnljw2ui-8.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-8 0}.lst-kix_39wbwk7b1djn-1>li{counter-increment:lst-ctn-kix_39wbwk7b1djn-1}.lst-kix_8bnlqh6lso62-5>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-5}ol.lst-kix_mpfdnljw2ui-0{list-style-type:none}.lst-kix_avs0v18voip7-2>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-2,lower-roman) ". "}.lst-kix_avs0v18voip7-4>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-4,lower-latin) ". "}ol.lst-kix_psjm00bsbse0-4.start{counter-reset:lst-ctn-kix_psjm00bsbse0-4 0}.lst-kix_t3gzkgsex1j8-8>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-8,lower-roman) ". "}.lst-kix_mpfdnljw2ui-4>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-4}ol.lst-kix_mpfdnljw2ui-6{list-style-type:none}ol.lst-kix_mpfdnljw2ui-5{list-style-type:none}ol.lst-kix_mpfdnljw2ui-8{list-style-type:none}.lst-kix_avs0v18voip7-0>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-0,decimal) ". "}.lst-kix_avs0v18voip7-6>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-6,decimal) ". "}.lst-kix_avs0v18voip7-8>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-8,lower-roman) ". "}ol.lst-kix_mpfdnljw2ui-7{list-style-type:none}ol.lst-kix_mpfdnljw2ui-2{list-style-type:none}ol.lst-kix_mpfdnljw2ui-1{list-style-type:none}.lst-kix_ytqu4jrtcbsv-5>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-5,lower-roman) ". "}ol.lst-kix_mpfdnljw2ui-4{list-style-type:none}ol.lst-kix_mpfdnljw2ui-3{list-style-type:none}.lst-kix_t3gzkgsex1j8-6>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-6,decimal) ". "}.lst-kix_5qvxdvnm85f3-8>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-8}.lst-kix_mpfdnljw2ui-3>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-3}.lst-kix_t3gzkgsex1j8-0>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-0,decimal) ". "}.lst-kix_t3gzkgsex1j8-4>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-4,lower-latin) ". "}.lst-kix_5ltos5434750-1>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-1,lower-latin) ". "}.lst-kix_ytqu4jrtcbsv-7>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-7,lower-latin) ". "}.lst-kix_ghjdfzl651et-5>li{counter-increment:lst-ctn-kix_ghjdfzl651et-5}.lst-kix_8bnlqh6lso62-4>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-4}.lst-kix_16jwsyg2bo35-7>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-7}.lst-kix_t3gzkgsex1j8-2>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-2,lower-roman) ". "}.lst-kix_5ltos5434750-5>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-5,lower-roman) ". "}ol.lst-kix_t3gzkgsex1j8-5.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-5 0}.lst-kix_5ltos5434750-3>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-3,decimal) ". "}.lst-kix_5ltos5434750-7>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-7,lower-latin) ". "}.lst-kix_z66j5kez7t2d-4>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-4,lower-latin) ". "}.lst-kix_avs0v18voip7-3>li{counter-increment:lst-ctn-kix_avs0v18voip7-3}.lst-kix_z66j5kez7t2d-2>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-2,lower-roman) ". "}.lst-kix_z66j5kez7t2d-0>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-0,decimal) ". "}.lst-kix_psjm00bsbse0-5>li{counter-increment:lst-ctn-kix_psjm00bsbse0-5}.lst-kix_ytqu4jrtcbsv-3>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-3,decimal) ". "}.lst-kix_f5lbk9pt02k3-6>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-6}ol.lst-kix_nuxp4se5bubj-4.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-4 0}.lst-kix_5ltos5434750-6>li{counter-increment:lst-ctn-kix_5ltos5434750-6}ol.lst-kix_16jwsyg2bo35-5.start{counter-reset:lst-ctn-kix_16jwsyg2bo35-5 0}ol.lst-kix_f5lbk9pt02k3-5.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-5 0}ol.lst-kix_mpfdnljw2ui-0.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-0 27}.lst-kix_ytqu4jrtcbsv-1>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-1,lower-latin) ". "}ol.lst-kix_8bnlqh6lso62-0{list-style-type:none}ol.lst-kix_8bnlqh6lso62-1{list-style-type:none}.lst-kix_ghjdfzl651et-6>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-6,decimal) ". "}.lst-kix_ghjdfzl651et-8>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-8,lower-roman) ". "}ol.lst-kix_psjm00bsbse0-1{list-style-type:none}ol.lst-kix_psjm00bsbse0-0{list-style-type:none}ol.lst-kix_psjm00bsbse0-3{list-style-type:none}ol.lst-kix_psjm00bsbse0-2{list-style-type:none}ol.lst-kix_8bnlqh6lso62-8{list-style-type:none}.lst-kix_ghjdfzl651et-4>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-4,lower-latin) ". "}.lst-kix_t3gzkgsex1j8-4>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-4}ol.lst-kix_8bnlqh6lso62-6{list-style-type:none}ol.lst-kix_8bnlqh6lso62-7{list-style-type:none}ol.lst-kix_8bnlqh6lso62-4{list-style-type:none}ol.lst-kix_8bnlqh6lso62-5{list-style-type:none}ol.lst-kix_8bnlqh6lso62-2{list-style-type:none}ol.lst-kix_8bnlqh6lso62-3{list-style-type:none}.lst-kix_ghjdfzl651et-6>li{counter-increment:lst-ctn-kix_ghjdfzl651et-6}.lst-kix_ytqu4jrtcbsv-0>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-0}.lst-kix_ghjdfzl651et-0>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-0,decimal) ". "}ol.lst-kix_39wbwk7b1djn-5.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-5 0}ol.lst-kix_psjm00bsbse0-5{list-style-type:none}ol.lst-kix_psjm00bsbse0-4{list-style-type:none}.lst-kix_ghjdfzl651et-2>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-2,lower-roman) ". "}ol.lst-kix_z66j5kez7t2d-8.start{counter-reset:lst-ctn-kix_z66j5kez7t2d-8 0}ol.lst-kix_psjm00bsbse0-7{list-style-type:none}.lst-kix_16jwsyg2bo35-0>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-0,decimal) ". "}.lst-kix_16jwsyg2bo35-2>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-2,lower-roman) ". "}.lst-kix_ytqu4jrtcbsv-7>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-7}ol.lst-kix_psjm00bsbse0-6{list-style-type:none}.lst-kix_z66j5kez7t2d-6>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-6,decimal) ". "}.lst-kix_psjm00bsbse0-0>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-0,decimal) ". "}ol.lst-kix_psjm00bsbse0-8{list-style-type:none}.lst-kix_mpfdnljw2ui-0>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-0,decimal) ". "}.lst-kix_z66j5kez7t2d-8>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-8,lower-roman) ". "}.lst-kix_psjm00bsbse0-2>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-2,lower-roman) ". "}ol.lst-kix_8bnlqh6lso62-8.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-8 0}.lst-kix_f5lbk9pt02k3-5>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-5,lower-roman) ". "}.lst-kix_f5lbk9pt02k3-7>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-7,lower-latin) ". "}.lst-kix_8bnlqh6lso62-3>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-3,decimal) ". "}.lst-kix_8bnlqh6lso62-5>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-5,lower-roman) ". "}ol.lst-kix_avs0v18voip7-8.start{counter-reset:lst-ctn-kix_avs0v18voip7-8 0}.lst-kix_mpfdnljw2ui-2>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-2,lower-roman) ". "}.lst-kix_16jwsyg2bo35-8>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-8}.lst-kix_psjm00bsbse0-4>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-4,lower-latin) ". "}.lst-kix_nuxp4se5bubj-0>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-0}.lst-kix_psjm00bsbse0-0>li{counter-increment:lst-ctn-kix_psjm00bsbse0-0}.lst-kix_mpfdnljw2ui-8>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-8,lower-roman) ". "}ol.lst-kix_5ltos5434750-0.start{counter-reset:lst-ctn-kix_5ltos5434750-0 7}.lst-kix_8bnlqh6lso62-7>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-7,lower-latin) ". "}ol.lst-kix_92rtpbbyfxpt-2.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-2 0}.lst-kix_mpfdnljw2ui-4>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-4,lower-latin) ". "}.lst-kix_psjm00bsbse0-6>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-6,decimal) ". "}ol.lst-kix_ghjdfzl651et-8.start{counter-reset:lst-ctn-kix_ghjdfzl651et-8 0}ol.lst-kix_5qvxdvnm85f3-6.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-6 0}.lst-kix_f5lbk9pt02k3-1>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-1,lower-latin) ". "}.lst-kix_f5lbk9pt02k3-3>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-3,decimal) ". "}ol.lst-kix_nuxp4se5bubj-2.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-2 0}ol.lst-kix_t3gzkgsex1j8-3.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-3 0}.lst-kix_z66j5kez7t2d-4>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-4}ol.lst-kix_psjm00bsbse0-2.start{counter-reset:lst-ctn-kix_psjm00bsbse0-2 0}.lst-kix_mpfdnljw2ui-6>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-6,decimal) ". "}ol.lst-kix_39wbwk7b1djn-4.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-4 0}.lst-kix_psjm00bsbse0-8>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-8,lower-roman) ". "}ol.lst-kix_t3gzkgsex1j8-6.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-6 0}.lst-kix_16jwsyg2bo35-1>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-1}ol.lst-kix_ytqu4jrtcbsv-0.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-0 3}ol.lst-kix_8bnlqh6lso62-0.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-0 9}ol.lst-kix_mpfdnljw2ui-1.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-1 0}ol.lst-kix_f5lbk9pt02k3-6.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-6 0}.lst-kix_8bnlqh6lso62-2>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-2,lower-roman) ". "}.lst-kix_nuxp4se5bubj-6>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-6,decimal) ". "}.lst-kix_16jwsyg2bo35-4>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-4,lower-latin) ". "}ol.lst-kix_mpfdnljw2ui-6.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-6 0}.lst-kix_nuxp4se5bubj-5>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-5,lower-roman) ". "}.lst-kix_nuxp4se5bubj-2>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-2,lower-roman) ". "}ol.lst-kix_psjm00bsbse0-0.start{counter-reset:lst-ctn-kix_psjm00bsbse0-0 21}.lst-kix_5qvxdvnm85f3-2>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-2}.lst-kix_16jwsyg2bo35-5>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-5,lower-roman) ". "}ol.lst-kix_avs0v18voip7-4.start{counter-reset:lst-ctn-kix_avs0v18voip7-4 0}ol.lst-kix_5qvxdvnm85f3-1.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-1 0}.lst-kix_5ltos5434750-3>li{counter-increment:lst-ctn-kix_5ltos5434750-3}.lst-kix_nuxp4se5bubj-1>li:before{content:"" counter(lst-ctn-kix_nuxp4se5bubj-1,lower-latin) ". "}ol.lst-kix_92rtpbbyfxpt-0.start{counter-reset:lst-ctn-kix_92rtpbbyfxpt-0 0}.lst-kix_16jwsyg2bo35-8>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-8,lower-roman) ". "}.lst-kix_5ltos5434750-5>li{counter-increment:lst-ctn-kix_5ltos5434750-5}.lst-kix_92rtpbbyfxpt-1>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-1}.lst-kix_psjm00bsbse0-7>li{counter-increment:lst-ctn-kix_psjm00bsbse0-7}ol.lst-kix_nuxp4se5bubj-5.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-5 0}ol.lst-kix_mpfdnljw2ui-7.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-7 0}ol.lst-kix_8bnlqh6lso62-5.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-5 0}ol.lst-kix_8bnlqh6lso62-6.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-6 0}ol.lst-kix_5qvxdvnm85f3-2.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-2 0}.lst-kix_z66j5kez7t2d-3>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-3}ol.lst-kix_ghjdfzl651et-6{list-style-type:none}ol.lst-kix_ghjdfzl651et-5{list-style-type:none}ol.lst-kix_ghjdfzl651et-4{list-style-type:none}ol.lst-kix_ghjdfzl651et-3{list-style-type:none}ol.lst-kix_ghjdfzl651et-8{list-style-type:none}ol.lst-kix_t3gzkgsex1j8-7.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-7 0}ol.lst-kix_ghjdfzl651et-7{list-style-type:none}ol.lst-kix_nuxp4se5bubj-6.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-6 0}ol.lst-kix_f5lbk9pt02k3-7.start{counter-reset:lst-ctn-kix_f5lbk9pt02k3-7 0}.lst-kix_mpfdnljw2ui-8>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-8}ol.lst-kix_ghjdfzl651et-2{list-style-type:none}ol.lst-kix_ghjdfzl651et-1{list-style-type:none}ol.lst-kix_ghjdfzl651et-0{list-style-type:none}.lst-kix_92rtpbbyfxpt-1>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-1,lower-latin) ". "}.lst-kix_nuxp4se5bubj-8>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-8}.lst-kix_92rtpbbyfxpt-0>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-0,decimal) ". "}.lst-kix_92rtpbbyfxpt-8>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-8,lower-roman) ". "}.lst-kix_ytqu4jrtcbsv-8>li{counter-increment:lst-ctn-kix_ytqu4jrtcbsv-8}ol.lst-kix_mpfdnljw2ui-2.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-2 0}.lst-kix_8bnlqh6lso62-0>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-0}.lst-kix_5qvxdvnm85f3-6>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-6}.lst-kix_92rtpbbyfxpt-5>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-5,lower-roman) ". "}.lst-kix_92rtpbbyfxpt-4>li:before{content:"" counter(lst-ctn-kix_92rtpbbyfxpt-4,lower-latin) ". "}.lst-kix_ghjdfzl651et-4>li{counter-increment:lst-ctn-kix_ghjdfzl651et-4}.lst-kix_avs0v18voip7-1>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-1,lower-latin) ". "}.lst-kix_avs0v18voip7-5>li:before{content:"" counter(lst-ctn-kix_avs0v18voip7-5,lower-roman) ". "}ol.lst-kix_avs0v18voip7-5.start{counter-reset:lst-ctn-kix_avs0v18voip7-5 0}.lst-kix_t3gzkgsex1j8-2>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-2}.lst-kix_t3gzkgsex1j8-7>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-7,lower-latin) ". "}.lst-kix_ytqu4jrtcbsv-4>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-4,lower-latin) ". "}.lst-kix_lrbu2hc8h017-1>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-1}.lst-kix_t3gzkgsex1j8-3>li:before{content:"" counter(lst-ctn-kix_t3gzkgsex1j8-3,decimal) ". "}ol.lst-kix_ytqu4jrtcbsv-7.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-7 0}ol.lst-kix_5qvxdvnm85f3-0.start{counter-reset:lst-ctn-kix_5qvxdvnm85f3-0 1}.lst-kix_5ltos5434750-0>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-0,decimal) ". "}.lst-kix_ytqu4jrtcbsv-8>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-8,lower-roman) ". "}.lst-kix_psjm00bsbse0-4>li{counter-increment:lst-ctn-kix_psjm00bsbse0-4}ol.lst-kix_39wbwk7b1djn-0.start{counter-reset:lst-ctn-kix_39wbwk7b1djn-0 8}.lst-kix_5ltos5434750-4>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-4,lower-latin) ". "}.lst-kix_t3gzkgsex1j8-0>li{counter-increment:lst-ctn-kix_t3gzkgsex1j8-0}.lst-kix_avs0v18voip7-0>li{counter-increment:lst-ctn-kix_avs0v18voip7-0}.lst-kix_16jwsyg2bo35-6>li{counter-increment:lst-ctn-kix_16jwsyg2bo35-6}ol.lst-kix_ytqu4jrtcbsv-4.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-4 0}.lst-kix_z66j5kez7t2d-3>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-3,decimal) ". "}ol.lst-kix_8bnlqh6lso62-1.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-1 0}.lst-kix_5qvxdvnm85f3-1>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-1,lower-latin) ". "}ol.lst-kix_t3gzkgsex1j8-8.start{counter-reset:lst-ctn-kix_t3gzkgsex1j8-8 0}.lst-kix_psjm00bsbse0-2>li{counter-increment:lst-ctn-kix_psjm00bsbse0-2}.lst-kix_5ltos5434750-8>li:before{content:"" counter(lst-ctn-kix_5ltos5434750-8,lower-roman) ". "}ol.lst-kix_8bnlqh6lso62-4.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-4 0}ol.lst-kix_f5lbk9pt02k3-8{list-style-type:none}.lst-kix_lrbu2hc8h017-3>li{counter-increment:lst-ctn-kix_lrbu2hc8h017-3}ol.lst-kix_f5lbk9pt02k3-7{list-style-type:none}ol.lst-kix_f5lbk9pt02k3-6{list-style-type:none}.lst-kix_ytqu4jrtcbsv-0>li:before{content:"" counter(lst-ctn-kix_ytqu4jrtcbsv-0,decimal) ". "}ol.lst-kix_nuxp4se5bubj-7.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-7 0}.lst-kix_5qvxdvnm85f3-5>li:before{content:"" counter(lst-ctn-kix_5qvxdvnm85f3-5,lower-roman) ". "}.lst-kix_ghjdfzl651et-7>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-7,lower-latin) ". "}ol.lst-kix_f5lbk9pt02k3-1{list-style-type:none}ol.lst-kix_f5lbk9pt02k3-0{list-style-type:none}.lst-kix_8bnlqh6lso62-2>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-2}.lst-kix_f5lbk9pt02k3-4>li{counter-increment:lst-ctn-kix_f5lbk9pt02k3-4}.lst-kix_avs0v18voip7-5>li{counter-increment:lst-ctn-kix_avs0v18voip7-5}ol.lst-kix_f5lbk9pt02k3-5{list-style-type:none}.lst-kix_5qvxdvnm85f3-4>li{counter-increment:lst-ctn-kix_5qvxdvnm85f3-4}ol.lst-kix_f5lbk9pt02k3-4{list-style-type:none}ol.lst-kix_ytqu4jrtcbsv-5.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-5 0}ol.lst-kix_f5lbk9pt02k3-3{list-style-type:none}ol.lst-kix_8bnlqh6lso62-2.start{counter-reset:lst-ctn-kix_8bnlqh6lso62-2 0}ol.lst-kix_f5lbk9pt02k3-2{list-style-type:none}.lst-kix_mpfdnljw2ui-6>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-6}.lst-kix_mpfdnljw2ui-1>li{counter-increment:lst-ctn-kix_mpfdnljw2ui-1}ol.lst-kix_avs0v18voip7-3.start{counter-reset:lst-ctn-kix_avs0v18voip7-3 0}.lst-kix_nuxp4se5bubj-3>li{counter-increment:lst-ctn-kix_nuxp4se5bubj-3}.lst-kix_8bnlqh6lso62-7>li{counter-increment:lst-ctn-kix_8bnlqh6lso62-7}ol.lst-kix_nuxp4se5bubj-8.start{counter-reset:lst-ctn-kix_nuxp4se5bubj-8 0}.lst-kix_ghjdfzl651et-3>li:before{content:"" counter(lst-ctn-kix_ghjdfzl651et-3,decimal) ". "}.lst-kix_z66j5kez7t2d-7>li:before{content:"" counter(lst-ctn-kix_z66j5kez7t2d-7,lower-latin) ". "}.lst-kix_16jwsyg2bo35-1>li:before{content:"" counter(lst-ctn-kix_16jwsyg2bo35-1,lower-latin) ". "}.lst-kix_f5lbk9pt02k3-6>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-6,decimal) ". "}.lst-kix_mpfdnljw2ui-1>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-1,lower-latin) ". "}.lst-kix_psjm00bsbse0-1>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-1,lower-latin) ". "}.lst-kix_psjm00bsbse0-5>li:before{content:"" counter(lst-ctn-kix_psjm00bsbse0-5,lower-roman) ". "}.lst-kix_lrbu2hc8h017-2>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-2,lower-roman) ". "}.lst-kix_lrbu2hc8h017-6>li:before{content:"" counter(lst-ctn-kix_lrbu2hc8h017-6,decimal) ". "}ol.lst-kix_5ltos5434750-6{list-style-type:none}ol.lst-kix_5ltos5434750-7{list-style-type:none}ol.lst-kix_5ltos5434750-8{list-style-type:none}.lst-kix_8bnlqh6lso62-6>li:before{content:"" counter(lst-ctn-kix_8bnlqh6lso62-6,decimal) ". "}ol.lst-kix_5ltos5434750-0{list-style-type:none}ol.lst-kix_5ltos5434750-1{list-style-type:none}ol.lst-kix_5ltos5434750-2{list-style-type:none}ol.lst-kix_5ltos5434750-3{list-style-type:none}ol.lst-kix_5ltos5434750-4{list-style-type:none}ol.lst-kix_5ltos5434750-5{list-style-type:none}.lst-kix_f5lbk9pt02k3-2>li:before{content:"" counter(lst-ctn-kix_f5lbk9pt02k3-2,lower-roman) ". "}.lst-kix_mpfdnljw2ui-5>li:before{content:"" counter(lst-ctn-kix_mpfdnljw2ui-5,lower-roman) ". "}.lst-kix_92rtpbbyfxpt-6>li{counter-increment:lst-ctn-kix_92rtpbbyfxpt-6}ol.lst-kix_avs0v18voip7-2.start{counter-reset:lst-ctn-kix_avs0v18voip7-2 0}ol.lst-kix_mpfdnljw2ui-5.start{counter-reset:lst-ctn-kix_mpfdnljw2ui-5 0}ol.lst-kix_ytqu4jrtcbsv-6.start{counter-reset:lst-ctn-kix_ytqu4jrtcbsv-6 0}.lst-kix_z66j5kez7t2d-1>li{counter-increment:lst-ctn-kix_z66j5kez7t2d-1}ol{margin:0;padding:0}table td,table th{padding:0}.c9{margin-left:18pt;padding-top:0pt;padding-bottom:0pt;line-height:1.0;orphans:2;widows:2;text-align:center}.c2{margin-left:18pt;padding-top:0pt;padding-bottom:0pt;line-height:1.0;orphans:2;widows:2;text-align:justify}.c6{color:#000000;font-weight:400;text-decoration:none;vertical-align:sub;font-size:18.3pt;font-family:"Times New Roman";font-style:normal}.c7{vertical-align:sub;font-size:18.3pt;font-family:"Times New Roman";font-weight:400}.c1{color:#000000;text-decoration:none;vertical-align:baseline;font-style:normal}.c0{font-size:10pt;font-family:"Times New Roman";font-weight:400}.c10{background-color:#ffffff;max-width:524.1pt;padding:7.1pt 36pt 7.1pt 35.1pt}.c4{padding:0;margin:0}.c3{padding-left:0pt}.c5{height:11pt}.c8{vertical-align:super}.title{padding-top:0pt;color:#000000;font-size:26pt;padding-bottom:3pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}.subtitle{padding-top:0pt;color:#666666;font-size:15pt;padding-bottom:16pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}li{color:#000000;font-size:11pt;font-family:"Arial"}p{margin:0;color:#000000;font-size:11pt;font-family:"Arial"}h1{padding-top:20pt;color:#000000;font-size:20pt;padding-bottom:6pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h2{padding-top:18pt;color:#000000;font-size:16pt;padding-bottom:6pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h3{padding-top:16pt;color:#434343;font-size:14pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h4{padding-top:14pt;color:#666666;font-size:12pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h5{padding-top:12pt;color:#666666;font-size:11pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;orphans:2;widows:2;text-align:left}h6{padding-top:12pt;color:#666666;font-size:11pt;padding-bottom:4pt;font-family:"Arial";line-height:1.15;page-break-after:avoid;font-style:italic;orphans:2;widows:2;text-align:left}'
  end

  def tests
  end

  def instructions
  end

  def confirmation
  end

  def subscription
  end

  def summary
  end

  def questions_data_0
    {
      currentQuestionIndex: 0,
      totalQuestions: 13,
      questions: [{
                    title: '<ol class="c4 lst-kix_t3gzkgsex1j8-0 start" start="1"><li class="c2 c3"><span class="c1 c0">Which of the following is not correct statement for periodic classification of elements? &nbsp;</span></li></ol>',
                    options: [
                      '<p class="c2"><span class="c1 c0">The properties of elements are the periodic functions of their atomic number.</span></p>',
                      '<p class="c2"><span class="c1 c0">Non &ndash; metallic elements are less in number than metallic elements.</span></p>',
                      '<p class="c2"><span class="c1 c0">The first ionization energies of elements along a period do not vary in regular manner with increase in atomic number.</span></p>',
                      '<p class="c2"><span class="c1 c0">For transition elements, the last electron enters into (n &ndash; 2) d &ndash; subshell.</span></p>'],
                    answerProps: {
                      isAnswered: false,
                      visited: true,
                      needReview: false,
                      answer: 1
                    }
                  },{ # 2
                      title: '<ol class="c4 lst-kix_z66j5kez7t2d-0 start" start="2"><li class="c2 c3"><span class="c1 c0">A sudden large jump between the values of second and third ionization energies of an element would be associated with which of the following electronic configuration? &nbsp; </span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image18.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image21.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                        '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 88.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image7.png" style="width: 88.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 96.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image13.png" style="width: 96.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{
                    title: '<ol class="c4 lst-kix_ghjdfzl651et-0 start" start="3"><li class="c2 c3"><span class="c1 c0">Which one of the following groupings represents a collection of isoelectronic species? &nbsp;(At. Nos .: Cs &ndash; 55, Br &ndash; 35)</span></li></ol>',
                    options: [
                      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 103.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image23.png" style="width: 103.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c7">&nbsp;</span><span class="c1 c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 79.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image2.png" style="width: 79.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 72.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image17.png" style="width: 72.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 83.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image14.png" style="width: 83.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
                    ],
                    answerProps: {
                      isAnswered: false,
                      visited: false,
                      needReview: false,
                      answer: 1
                    }
                  },{
                    title: '<ol class="c4 lst-kix_ytqu4jrtcbsv-0 start" start="4"><li class="c2 c3"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 22.97px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 22.97px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions are isoelectronic. Which of the statements is not correct? &nbsp; </span></li></ol>',
                    options: [
                      '<p class="c2"><span class="c0"> Both </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions contain 18 electrons.</span></p>',
                      '<p class="c2"><span class="c0"> Both </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions have same configuration.</span></p>',
                      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;ion is bigger than </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ion is ionic size.</span></p>',
                      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;ion is bigger than </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ion in size.</span></p>'
                    ],
                    answerProps: {
                      isAnswered: false,
                      visited: false,
                      needReview: false,
                      answer: 1
                    }
                  },{ # 5
                      title: '<ol class="c4 lst-kix_f5lbk9pt02k3-0 start" start="5"><li class="c2 c3"><span class="c1 c0">Which of the following statements regarding the variation of atomic radii in the periodic table is not true?</span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> In a group, there is continuous increase in size with increase in atomic number.</span></p>',
                        '<p class="c2"><span class="c1 c0"> In 4f &ndash; series, there is a continuous decrease in size with increase in atomic number.</span></p>',
                        '<p class="c2"><span class="c1 c0"> the size of inert gases is larger than halogens.</span></p>',
                        '<p class="c2"><span class="c0"> In 3</span><span class="c0 c8">rd</span><span class="c1 c0">&nbsp;period, the size of atoms increases with increase in atomic number.</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 6
                      title: '<ol class="c4 lst-kix_16jwsyg2bo35-0 start" start="6"><li class="c2 c3"><span class="c1 c0">Which of the following is not a periodic property for the elements? </span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> Electronegativity&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c1 c0"> Atomic size</span></p>',
                        '<p class="c2"><span class="c1 c0"> Occurrence in nature&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c1 c0"> Ionization energy</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 7
                      title: '<ol class="c4 lst-kix_lrbu2hc8h017-0 start" start="7"><li class="c2 c3"><span class="c1 c0">Which of the following statements is true about the variation of density of elements in the periodic table? </span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> In a period from left to right density first increases upto the middle and then strts decreasing.</span></p>',
                        '<p class="c2"><span class="c1 c0"> In a group on moving down the density decreases from top to bottom.</span></p>',
                        '<p class="c2"><span class="c1 c0"> A less closely packed solid has higher density.</span></p>',
                        '<p class="c2"><span class="c1 c0"> Density of elements is not a periodic property.</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 8
                      title: '<ol class="c4 lst-kix_5ltos5434750-0 start" start="8"><li class="c2 c3"><span class="c1 c0">The correct order of acidic character of oxides in third period of periodic table is &nbsp;</span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image16.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image15.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image20.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image11.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 9
                      title: '<ol class="c4 lst-kix_39wbwk7b1djn-0 start" start="9"><li class="c2 c3"><span class="c0">Consider the isoelectronic species, </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 88.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image22.png" style="width: 88.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 27.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image24.png" style="width: 27.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0 c1">&nbsp;the correct order of increasing length of their radii is.</span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 119.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image9.png" style="width: 119.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 131.00px; height: 22.00px;"><img alt="" src="assets/images_exam_1/image6.png" style="width: 131.00px; height: 22.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 125.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image5.png" style="width: 125.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 132.00px; height: 22.00px;"><img alt="" src="assets/images_exam_1/image8.png" style="width: 132.00px; height: 22.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 10
                      title: '<ol class="c4 lst-kix_8bnlqh6lso62-0 start" start="10"><li class="c2 c3"><span class="c1 c0">The first ionization enthalpies of Na, Mg, Al and Si are in the order.</span></li></ol>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> &nbsp;Na &lt; Mg &gt; Al &lt; Si&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c1 c0"> Na &gt; Mg &gt; Al &gt; Si</span></p>',
                        '<p class="c2"><span class="c1 c0"> Na &lt; Mg &lt; Al &lt; Si&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
                        '<p class="c2"><span class="c1 c0"> Na &gt; Mg&gt; Al &lt; Si</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 11
                      title: '<ol class="c4 lst-kix_psjm00bsbse0-0 start" start="22"><li class="c2 c3"><span class="c1 c0">Part of the periodic table showing p &ndash; block is depicted below. What are the elements shown in thezig &ndash; zag boxes called? What is the nature of the elements outside this boundary on the right side of the table?</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 76.00px; height: 73.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-46.bmp" src="assets/images_exam_1/image10.png" style="width: 76.00px; height: 73.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> Metalloids, non &ndash; metals</span></p>',
                        '<p class="c2"><span class="c1 c0"> Transition elements, metalloids</span></p>',
                        '<p class="c2"><span class="c1 c0"> Metals, non &ndash; metals</span></p>',
                        '<p class="c2"><span class="c1 c0"> Non &ndash; metals, noble gases</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 12
                      title: '<ol class="c4 lst-kix_mpfdnljw2ui-0 start" start="28"><li class="c2 c3"><span class="c1 c0">What are the two radii shown as &lsquo;a&rsquo; and &lsquo;b&rsquo; in the figure known as? &nbsp;</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 126.00px; height: 60.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-50.bmp" src="assets/images_exam_1/image19.png" style="width: 126.00px; height: 60.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                      options: [
                        '<p class="c2"><span class="c1 c0"> a = Atomic radius, b = Molecular radius</span></p>',
                        '<p class="c2"><span class="c1 c0"> a = Covalent radius, b = van der Waals&rsquo; radius</span></p>',
                        '<p class="c2"><span class="c1 c0"> a = Ionic radius, b = Covalent radius</span></p>',
                        '<p class="c2"><span class="c1 c0"> a = Covalent radius, b = Atomic radius</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  },{ # 13
                      title: '<ol class="c4 lst-kix_avs0v18voip7-0 start" start="30"><li class="c2 c3"><span class="c1 c0">In the given graph, a periodic property &reg; is plotted against atomic numbers (Z) of the lements. Which property is shown in the graph and how is it correlated with reactivity of the elements? &nbsp;</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 124.00px; height: 98.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-51.bmp" src="assets/images_exam_1/image12.png" style="width: 124.00px; height: 98.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
                      options: [
                        '<p class="c2"><span class="c0"> Ionisation enthalpy in a group, reactivity dectreases from a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
                        '<p class="c2"><span class="c0"> Ionisation enthalpy in a group, reactivity increases from a </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
                        '<p class="c2"><span class="c0"> Atomic radius in a group, reactivity decreases from &nbsp;a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
                        '<p class="c2"><span class="c0"> Metallic character in a group, reactivity increases from a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">e</span></p>'
                      ],
                      answerProps: {
                        isAnswered: false,
                        visited: false,
                        needReview: false,
                        answer: 1
                      }
                  }
      ],
    }
  end

  def questions_data_1
    {
      currentQuestionIndex: 0,
      totalQuestions: 10,
      questions: [
        {
          title: '<p>Which of the following match is the correct? <br> I. STDs – Sexually Transmitted Diseases <br> II. VD – Venerable Disease <br> III. RTI – Reproductive Tract Infection</p>',
          options: [
            '<p>a)I and II</p>',
            '<p>b)II and IV</p>',
            '<p>c)I and III</p>',
            '<p>d)I, II and III</p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'Study of population trends is:',
          options: [
            'a)Kalography',
            'b)Psychobiology',
            'c)Biography',
            'd)Demograghy'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'One of the legal methods of birth control is:',
          options: [
            'a)By abstaining from coitus from day 10 to 17 of the menstrual cycle',
            'b)By having coitus at the time of day break',
            'c)By a premature ejaculation during coitus',
            'd)Absorption by taking an approximate medicine'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'Greatest biological problems faced by human beings is:',
          options: [
            'a)Population explosion',
            'b)Depletion of ozone layer',
            'c)Depletion of natural resources',
            'd)Land erosion'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'The prenatal technique to determine the genetic disorders in a foetus is called',
          options: [
            'a)Laparoscopy',
            'b)Amniocentesis',
            'c)Abstinence',
            'd)Coitus interruptus'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'July 11 is :',
          options: [
            'a)World Environment day',
            'b)World Population day',
            'c)World AIDS day',
            'd)World Education day'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'Most thickly populated country is:',
          options: [
            'a)Bangladesh',
            'b)Australia',
            'c)U.S.A',
            'd)India'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'What is the function of copper T?',
          options: [
            'a)Prevents mutation',
            'b)Prevents fertilization',
            'c)Prevents zygote formation',
            'd)(B) and (C)'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'Spermicidal cream used on the coating of condoms, diaphragms, cervical cap and vaults are',
          options: [
            'a)For lubrication',
            'b)For shining',
            'c)For increasing effectiveness',
            'd)None of the above'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: 'The prenatal technique to determine the genetic disorders in a foetus is called',
          options: [
            'a)Laparoscopy',
            'b)Amniocentesis',
            'c)Abstinence',
            'd)Coitus interruptus'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
      ],
    }
  end

  def questions_data_2
    {
      currentQuestionIndex: 0,
      totalQuestions: 37,
      questions: [
        {
          title: '<p class="c2"><span class="c0">1. For a particle moving in a vertical circle </span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;K.E. is constant</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.E. is constant</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;neither K.E. nor P.E. is const</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;both Kinetic energy and Potential energy is constant</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },
        {
          title: '<p class="c2"><span class="c0">2.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Centrifugal force is not a real force , but it arises due to </span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;accn of rotating frame</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mass of rotating body</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;presence of CFF</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rotation of moon around the earth</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">3.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 radian angular disp. is nearly equal to ( in degree ) &nbsp;</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.7&deg;</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp; &nbsp; &nbsp;57.8&deg;</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;57&deg;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.578&deg;</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p><span>4.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Three identical cars A , B , and C are moving at the same speed on three bridges. The car A goes on a plane bridge , B on a bridge convex upward and C goes on a bridge concave upward. Let F</span><span class="c4 c10">A</span><span class="c4">&nbsp;, F</span><span class="c4 c10">B</span><span class="c4">&nbsp;and F</span><span class="c4 c10">C</span><span class="c0">&nbsp;be the normal forces exerted by the cars on the bridges when they are at the middle of bridges . Then </span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</span><span class="c4 c10">A</span><span class="c0">&nbsp;is max.of the 3 forces</span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</span><span class="c4 c10">B</span><span class="c0">&nbsp;is max. of the 3 forces</span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</span><span class="c4 c10">C</span><span class="c0">&nbsp;is max. of the 3 forces&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; F</span><span class="c4 c10">A</span><span class="c4">&nbsp;= F</span><span class="c4 c10">B</span><span class="c4">&nbsp;=F</span><span class="c4 c10 c13">C</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">5.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The angular velocity of earth rotating about its axis be</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Greater than that of hour hand of clock</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Equal to that of hour hand of clock</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Greater that or equal to hour hand of clock </span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Smaller than that of hour hand of clock</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p><span>6.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A car is moving &nbsp;with maximum speed on a curved banked road. The statements is/are correct</span></p>
            <p class="c2"><span class="c0">A) &nbsp;the weight mg of car acting vertically downwards &nbsp;is &nbsp; &nbsp;balanced by the vertical component of normal reaction ( N cos &#x1d703; ) B) normal reaction N between the car and road acts at right angles to road surface</span></p>
            <p class="c2 c19"><span class="c0">C) the horizontal component of normal reaction (N sin &#x1d703;) &nbsp; is directed towards the centre of curve and it provides the necessary centripetal force&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;only A</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;only C</span></p>',
            '<p class="c2"><span class="c0">c) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A &amp; C</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A , B , &amp; C</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2 c6"><span class="c0">7.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The motion of the particle along the circumference of the circle with variable speed is a</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uniform circular motion &nbsp;</span></p>',
            '<p class="c2"><span class="c4">&nbsp;</span><span class="c5">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;non uniform circular motion</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;accelerated motion&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rotational motion</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2 c6"><span class="c0">8.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If the fingers of the right hand are curled in the sense of motion of the particle performing circular motion then the outstretched thumb gives the direction of </span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Angular velocity, Angular accn </span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tangential velocity </span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tangential acceleration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Linear velocity</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p ><span>9.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;On a dry road , the max. speed is 5</span><img src="assets/images_exam_2/image1.png"><span class="c0">&nbsp;m/s.The max.speed on wet road is 5 m/s. If the coefficient of friction for dry road is &mu; then , that for wet road is</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&mu; / 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &mu; / 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">c) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2 &mu;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3 &mu; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">10.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Two bodies of masses m</span><span class="c4 c10">1</span><span class="c4">&nbsp;and m</span><span class="c4 c10">2</span><span class="c4">&nbsp;are moving in circle of radii r</span><span class="c4 c10">1</span><span class="c4">&nbsp;and r</span><span class="c4 c10">2</span><span class="c0">&nbsp;respectively. They make one revolution in same time Their angular speeds are in the ratio</span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;m</span><span class="c4 c10">1 </span><span class="c4">: m</span><span class="c4 c10">2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;m</span><span class="c4 c10">1</span><span class="c4">&nbsp;r</span><span class="c4 c10">1 </span><span class="c4">: m</span><span class="c4 c10">2</span><span class="c4">r</span><span class="c4 c13 c10">2 &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c4">c) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image2.png"><span class="c0">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 : 1</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">11.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Centrifuges are used to separate the particles of </span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;different masses&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;different densities</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;different sizes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;all the above are true</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c4">12.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="c5">Which &nbsp;of the following is not related with circular motion</span><span class="c0">&nbsp;</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;particles of a spinning top</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rotating fan about vertical axis</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;motion of artificial satellite round the earth</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;motion of simple pendulum</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">13.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If distance between the earth and sun is increased by 3 times , then attraction between them will </span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;decrease by </span><img src="assets/images_exam_2/image3.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;remain same</span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;decrease by </span><img src="assets/images_exam_2/image4.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;increase by 3</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">14.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;According to kepler&rsquo;s second law , line joining the planet to the sun sweeps out equal areas in equal time intervals. This suggests that for the planet.</span></p>',
          options: [
            '<p class=""><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Radial accn is zero&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Tangential accn is zero</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transverse accn is zero&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All of the above</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">15.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The weight of body on the moon&rsquo;s surface is less than that on earth surface because :</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moon has no atmosphere&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moon is far from earth</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moon is close than earth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Accn due to gravity on moon is less</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">16.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The radius of the earth is about 6400 km and that of mars is 3200 km .The mass of the earth is about 10 times the mass of mars .An object weighs 200 N on the surface of earth . Its weight on the surface of mars will be</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;80 N</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;40 N&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 N&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;60 N</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">17.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Inertial mass of body can be measured by</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hooks law&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Newton&rsquo;s Ist law</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Newton&rsquo;s IInd law &nbsp; </span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Newton&rsquo;s law of gravitation</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">18.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The earth (mass =6 x10</span><span class="c4 c15">24</span><span class="c4">kg) revolves round the sun with an angular velocity of 2&times;10 </span><span class="c4 c15">- 7</span><span class="c4">&nbsp;rad/s in a circular orbit of radius 1.5 &times;10 </span><span class="c4 c15">8</span><span class="c0">&nbsp;km The gravitational force exerted by the sun on the earth , in newton , is</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zero &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18&times;10</span><span class="c4 c13 c15">25&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;36&times;10</span><span class="c4 c13 c15">21 &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.6&times;10</span><span class="c4 c15">18</span></p>',
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c5 c8">19.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;An artificial satellite stays in the orbit around the earth because</span></p>',
          options: [
            '<p class=""><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Earth&rsquo;s attraction on it is balanced by the attraction of the planets</span></p>',
            '<p class=""><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The fuel in the satellite burns and releases hot gases which produce thrust</span></p>',
            '<p class=""><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Earth&rsquo;s attraction on it is just balanced by the viscous force on it produced by the atmosphere</span></p>',
            '<p class=""><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Earth&rsquo;s attraction on in produces necessary centripetal force</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">20.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If </span><img src="assets/images_exam_2/image5.png"><span class="c0">&nbsp;is the mean density of the earth and R is its radius , then critical speed of a satellite revolving very close to the surface of earth is</span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image6.png"><span class="c0">&nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image7.png"><span class="c0">&nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">c) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image8.png"></p>',
            '<p class="c2"><span class="c4">&nbsp;d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image9.png"></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">21.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The relay satellite transmits TV programme continuously from one part of the world to another because its</span></p>',
          options: [
            '<p class="c2"><span class="c5">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Period is greater than the period of rotation of the earth</span></p>',
            '<p class="c2"><span class="c8 c5">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Period is less than the period of the earth about its axis</span></p>',
            '<p class=""><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Period has no relation with the period of the earth about its axis</span></p>',
            '<p class=""><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Period is equal to the period of rotations of the earth about its axis</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">22.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The escape velocity of a body depends upon</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Gravitational constant&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mass of the body</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Both mass and gravitational constant</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Density of planet</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">23.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The value of universal gravitational constant G in M.K.S. system is </span><img src="assets/images_exam_2/image10.png"><span class="c0">&nbsp;Its value in C.G.S. system is</span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image11.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image12.png"></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image13.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image14.png"></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">The angular velocity of rotation of a star (of mass M and radius R) at which the matter starts to escape from its equator is</span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image15.png"><span class="c0">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image16.png"><span class="c0">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image17.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image18.png"></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">25.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A stone tied to string performs horizontal circle.During the motion,</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;linear and angular momentum are constant</span></p>',
            '<p class=""><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;linear momentum is const. but angular momentum is changing</span></p>',
            '<p class=""><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;angular momentum is constant but linear momentum is changing</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;both linear and angular momentum are changing</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">26.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A body of mass m slides down on an inclined plane and reaches the bottom with a velocity &#39;v&#39;. If the same mass </span><span class="c5">were in the form of a ring which rolls down on the inclined</span><span class="c0">&nbsp;plane , then the velocity of the ring at the bottom will be</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;v &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image19.png"><span class="c0">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image20.png"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><img src="assets/images_exam_2/image21.png"></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">27.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In the absence of external force the centre of mass of the system will move</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zero velocity&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; constant velocity</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Infinite velocity&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Moderate variable velocity</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">28.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The spokes used in a cycle wheel to increase its</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;total acceleration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;centripetal acceleration</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tangential acceleration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; moment of inertia</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">29.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Generally most of the mass of the flywheel is placed on the rim</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to decrease M.I.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to obtain equilibrium</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to increase M.I.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to obtain strong wheel</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class="c2"><span class="c0">30.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The centre of mass of a body lies</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;on its surface&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;inside the body</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;outside the body&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;both &lsquo;b&#39; and &#39;c&#39;</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">31.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A body has rotational energy by virtue of its motion is 1000 kgm</span><span class="c4 c15">2</span><span class="c0">&nbsp;has an angular speed of 20 rad/sec in anti clock wise direction.The body has rotational inertial about the axis is </span></p>',
          options: [
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 kgm</span><span class="c4 c13 c15">2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 kgm</span><span class="c4 c13 c15">2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">c) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.5 kgm</span><span class="c4 c13 c15">2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2 kgm</span><span class="c4 c15">2</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">32.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Two diff. masses 1 kg and 2 kg are moving with velocities 2 m/s &amp; 8 m/s towards each other due to gravitational influence. Their centre of mass has a velocity of</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.8 m/s</span></p>',
            '<p class="c2"><span class="c0">b) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;zero</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;infinity(&infin;)</span></p>',
            '<p class="c2"><span class="c0">d) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.4 m/s</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">33.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Centre of mass of a homogenous semicircular plate of radius &#39;r&#39; lies</span></p>',
          options: [
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;outside the plate</span></p>',
            '<p class="c2"><span class="c0">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;on the circumference of the plate</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; on the line of symmetry of the semicircle</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;at the mid point radius of</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">34.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The total angular momentum of a body is equal to angular momentum of its centre of mass if the body has</span></p>',
          options:[
            '<p class="c2"><span class="c0">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;only translational motion&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c0">b) only rotational motion</span></p>',
            '<p class="c2"><span class="c0">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;both translational and rotational motion</span></p>',
            '<p class="c2"><span class="c0">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;no motion at all</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">35.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A heavy disc is rotating with uniform angular velocity w about its own axis. A piece of wax sticks to it. The angular velocity of the disc will</span></p>',
          options:[
            '<p class="c2"><span class="c8 c5">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;increase &nbsp;</span></p>',
            '<p class="c2"><span class="c8 c5">b) decrease </span></p>',
            '<p class="c2"><span class="c8 c5">c) becomes 0 </span></p>',
            '<p class="c2"><span class="c8 c5">d) remain unchanged</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c4">36.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Two circular uniform discs A and B are of equal masses and thickness but made of metal with densities d</span><span class="c4 c10">A</span><span class="c4">&nbsp;and d</span><span class="c4 c10">B</span><span class="c4">&nbsp;(d</span><span class="c4 c10">A</span><span class="c4">&nbsp;&gt; d</span><span class="c4 c10">B</span><span class="c4">). If their M.I. about an axis passing through their centre &amp; perpendicular to circular faces be I</span><span class="c4 c10">A</span><span class="c4">&nbsp;and I</span><span class="c4 c10">B</span><span class="c0">&nbsp;then</span></p>',
          options:[
            '<p class="c2"><span class="c4">a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I</span><span class="c4 c10">A</span><span class="c4 c15">&nbsp;</span><span class="c4">= I</span><span class="c4 c13 c10">B &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></p>',
            '<p class="c2"><span class="c4">b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; I</span><span class="c4 c10">A</span><span class="c4 c15">&nbsp;</span><span class="c4">&gt; I</span><span class="c4 c13 c10">B &nbsp; &nbsp; &nbsp; &nbsp; </span></p>',
            '<p class="c2"><span class="c4">c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;I</span><span class="c4 c10">A</span><span class="c4 c15">&nbsp;</span><span class="c4">&lt; I</span><span class="c4 c10">B</span><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
            '<p class="c2"><span class="c4">d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; I</span><span class="c4 c10">A</span><span class="c4 c15">&nbsp;</span><span class="c16">&ge;</span><span class="c4">&nbsp;I</span><span class="c4 c10">B</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        },{
          title: '<p class=""><span class="c0">37.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The total energy of a linear harmonic oscillator is directly proportional to</span></p>',
          options:[
            '<p class="c2"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;it mass only</span></p>',
            '<p class="c2"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the square of its amplitude only</span></p>',
            '<p class="c2"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the square of its frequency only</span></p>',
            '<p class="c2"><span class="c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;all of these</span></p>'
          ],
          answerProps: {
            isAnswered: false,
            visited: false,
            needReview: false,
            answer: 1
          }
        }
      ],
    }
  end


  def exam_data
    puts "params: \n\n--------- #{params.inspect}"
    exam_id = params[:id].split('?')[1]
    question_data = questions_data_0 if exam_id.nil?
    question_data = questions_data_1 if exam_id == '1'
    question_data = questions_data_2 if exam_id == '2'
    render json: question_data
  end
end
