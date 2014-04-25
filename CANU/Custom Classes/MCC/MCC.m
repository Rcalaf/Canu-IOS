//
//  MCC.m
//  CANU
//
//  Created by Vivien Cormier on 09/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "MCC.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface MCC ()



@end

@implementation MCC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
        CTCarrier *carrier                   = network_Info.subscriberCellularProvider;
        
        self.carriereVersion = [NSString stringWithFormat:@"%@ %@",[carrier carrierName],[carrier mobileNetworkCode]];
        
        self.mcc = [carrier mobileCountryCode];
        
        self.callingCode = [self.mcc_CallingCode objectForKey:_mcc];
        
        for (NSString* key in self.countryName_CallingCode) {
            NSString *callingCode = [self.countryName_CallingCode objectForKey:key];
            if ([callingCode isEqualToString:self.callingCode]) {
                self.country = key;
            }
        }
        
    }
    return self;
}

- (NSString *)callingCodeWithCountryName:(NSString *)countryName{
    
    NSString *callingCode = [self.countryName_CallingCode objectForKey:countryName];
    
    return callingCode;
    
}

- (NSArray *)countryName_CallingCode_Array{
    
    if (!_countryName_CallingCode_Array) {
        
        _countryName_CallingCode_Array = @[
                                     @"Canada"
                                     ,@"China"
                                     ,@"France"
                                     ,@"Germany"
                                     ,@"India"
                                     ,@"Japan"
                                     ,@"Pakistan"
                                     ,@"United Kingdom"
                                     ,@"United States"
                                     ,@"Abkhazia"
                                     ,@"Abkhazia"
                                     ,@"Afghanistan"
                                     ,@"Albania"
                                     ,@"Algeria"
                                     ,@"American Samoa"
                                     ,@"Andorra"
                                     ,@"Angola"
                                     ,@"Anguilla"
                                     ,@"Antigua and Barbuda"
                                     ,@"Argentina"
                                     ,@"Armenia"
                                     ,@"Aruba"
                                     ,@"Ascension"
                                     ,@"Australia"
                                     ,@"Australian External Territories"
                                     ,@"Austria"
                                     ,@"Azerbaijan"
                                     ,@"Bahamas"
                                     ,@"Bahrain"
                                     ,@"Bangladesh"
                                     ,@"Barbados"
                                     ,@"Barbuda"
                                     ,@"Belarus"
                                     ,@"Belgium"
                                     ,@"Belize"
                                     ,@"Benin"
                                     ,@"Bermuda"
                                     ,@"Bhutan"
                                     ,@"Bolivia"
                                     ,@"Bosnia and Herzegovina"
                                     ,@"Botswana"
                                     ,@"Brazil"
                                     ,@"British Indian Ocean Territory"
                                     ,@"British Virgin Islands"
                                     ,@"Brunei"
                                     ,@"Bulgaria"
                                     ,@"Burkina Faso"
                                     ,@"Burundi"
                                     ,@"Cambodia"
                                     ,@"Cameroon"
                                     ,@"Canada"
                                     ,@"Cape Verde"
                                     ,@"Cayman Islands"
                                     ,@"Central African Republic"
                                     ,@"Chad"
                                     ,@"Chile"
                                     ,@"China"
                                     ,@"Christmas Island"
                                     ,@"Cocos-Keeling Islands"
                                     ,@"Colombia"
                                     ,@"Comoros"
                                     ,@"Congo"
                                     ,@"Congo, Dem. Rep. of (Zaire)"
                                     ,@"Cook Islands"
                                     ,@"Costa Rica"
                                     ,@"Ivory Coast"
                                     ,@"Croatia"
                                     ,@"Cuba"
                                     ,@"Curacao"
                                     ,@"Cyprus"
                                     ,@"Czech Republic"
                                     ,@"Denmark"
                                     ,@"Diego Garcia"
                                     ,@"Djibouti"
                                     ,@"Dominica"
                                     ,@"Dominican Republic"
                                     ,@"Dominican Republic"
                                     ,@"Dominican Republic"
                                     ,@"East Timor"
                                     ,@"Easter Island"
                                     ,@"Ecuador"
                                     ,@"Egypt"
                                     ,@"El Salvador"
                                     ,@"Equatorial Guinea"
                                     ,@"Eritrea"
                                     ,@"Estonia"
                                     ,@"Ethiopia"
                                     ,@"Falkland Islands"
                                     ,@"Faroe Islands"
                                     ,@"Fiji"
                                     ,@"Finland"
                                     ,@"France"
                                     ,@"French Antilles"
                                     ,@"French Guiana"
                                     ,@"French Polynesia"
                                     ,@"Gabon"
                                     ,@"Gambia"
                                     ,@"Georgia"
                                     ,@"Germany"
                                     ,@"Ghana"
                                     ,@"Gibraltar"
                                     ,@"Greece"
                                     ,@"Greenland"
                                     ,@"Grenada"
                                     ,@"Guadeloupe"
                                     ,@"Guam"
                                     ,@"Guatemala"
                                     ,@"Guinea"
                                     ,@"Guinea-Bissau"
                                     ,@"Guyana"
                                     ,@"Haiti"
                                     ,@"Honduras"
                                     ,@"Hong Kong SAR China"
                                     ,@"Hungary"
                                     ,@"Iceland"
                                     ,@"India"
                                     ,@"Indonesia"
                                     ,@"Iran"
                                     ,@"Iraq"
                                     ,@"Ireland"
                                     ,@"Israel"
                                     ,@"Italy"
                                     ,@"Jamaica"
                                     ,@"Japan"
                                     ,@"Jordan"
                                     ,@"Kazakhstan"
                                     ,@"Kenya"
                                     ,@"Kiribati"
                                     ,@"North Korea"
                                     ,@"South Korea"
                                     ,@"Kuwait"
                                     ,@"Kyrgyzstan"
                                     ,@"Laos"
                                     ,@"Latvia"
                                     ,@"Lebanon"
                                     ,@"Lesotho"
                                     ,@"Liberia"
                                     ,@"Libya"
                                     ,@"Liechtenstein"
                                     ,@"Lithuania"
                                     ,@"Luxembourg"
                                     ,@"Macau SAR China"
                                     ,@"Macedonia"
                                     ,@"Madagascar"
                                     ,@"Malawi"
                                     ,@"Malaysia"
                                     ,@"Maldives"
                                     ,@"Mali"
                                     ,@"Malta"
                                     ,@"Marshall Islands"
                                     ,@"Martinique"
                                     ,@"Mauritania"
                                     ,@"Mauritius"
                                     ,@"Mayotte"
                                     ,@"Mexico"
                                     ,@"Micronesia"
                                     ,@"Midway Island"
                                     ,@"Micronesia"
                                     ,@"Moldova"
                                     ,@"Monaco"
                                     ,@"Mongolia"
                                     ,@"Montenegro"
                                     ,@"Montserrat"
                                     ,@"Morocco"
                                     ,@"Myanmar"
                                     ,@"Namibia"
                                     ,@"Nauru"
                                     ,@"Nepal"
                                     ,@"Netherlands"
                                     ,@"Netherlands Antilles"
                                     ,@"Nevis"
                                     ,@"New Caledonia"
                                     ,@"New Zealand"
                                     ,@"Nicaragua"
                                     ,@"Niger"
                                     ,@"Nigeria"
                                     ,@"Niue"
                                     ,@"Norfolk Island"
                                     ,@"Northern Mariana Islands"
                                     ,@"Norway"
                                     ,@"Oman"
                                     ,@"Pakistan"
                                     ,@"Palau"
                                     ,@"Palestinian Territory"
                                     ,@"Panama"
                                     ,@"Papua New Guinea"
                                     ,@"Paraguay"
                                     ,@"Peru"
                                     ,@"Philippines"
                                     ,@"Poland"
                                     ,@"Portugal"
                                     ,@"Puerto Rico"
                                     ,@"Puerto Rico"
                                     ,@"Qatar"
                                     ,@"Reunion"
                                     ,@"Romania"
                                     ,@"Russia"
                                     ,@"Rwanda"
                                     ,@"Samoa"
                                     ,@"San Marino"
                                     ,@"Saudi Arabia"
                                     ,@"Senegal"
                                     ,@"Serbia"
                                     ,@"Seychelles"
                                     ,@"Sierra Leone"
                                     ,@"Singapore"
                                     ,@"Slovakia"
                                     ,@"Slovenia"
                                     ,@"Solomon Islands"
                                     ,@"South Africa"
                                     ,@"South Georgia and the South Sandwich Islands"
                                     ,@"Spain"
                                     ,@"Sri Lanka"
                                     ,@"Sudan"
                                     ,@"Suriname"
                                     ,@"Swaziland"
                                     ,@"Sweden"
                                     ,@"Switzerland"
                                     ,@"Syria"
                                     ,@"Taiwan"
                                     ,@"Tajikistan"
                                     ,@"Tanzania"
                                     ,@"Thailand"
                                     ,@"Timor Leste"
                                     ,@"Togo"
                                     ,@"Tokelau"
                                     ,@"Tonga"
                                     ,@"Trinidad and Tobago"
                                     ,@"Tunisia"
                                     ,@"Turkey"
                                     ,@"Turkmenistan"
                                     ,@"Turks and Caicos Islands"
                                     ,@"Tuvalu"
                                     ,@"Uganda"
                                     ,@"Ukraine"
                                     ,@"United Arab Emirates"
                                     ,@"United Kingdom"
                                     ,@"United States"
                                     ,@"Uruguay"
                                     ,@"U.S. Virgin Islands"
                                     ,@"Uzbekistan"
                                     ,@"Vanuatu"
                                     ,@"Venezuela"
                                     ,@"Vietnam"
                                     ,@"Wake Island"
                                     ,@"Wallis and Futuna"
                                     ,@"Yemen"
                                     ,@"Zambia"
                                     ,@"Zanzibar"
                                     ,@"Zimbabwe"
                                     ];
        
    }
    
    return _countryName_CallingCode_Array;
    
}

- (NSDictionary *)countryName_CallingCode{
    
    if (!_countryName_CallingCode) {
        
        _countryName_CallingCode = @{
                              @"Canada"                                       : @"+1",
                              @"China"                                        : @"+86",
                              @"France"                                       : @"+33",
                              @"Germany"                                      : @"+49",
                              @"India"                                        : @"+91",
                              @"Japan"                                        : @"+81",
                              @"Pakistan"                                     : @"+92",
                              @"United Kingdom"                               : @"+44",
                              @"United States"                                : @"+1",
                              @"Abkhazia"                                     : @"+7 840",
                              @"Abkhazia"                                     : @"+7 940",
                              @"Afghanistan"                                  : @"+93",
                              @"Albania"                                      : @"+355",
                              @"Algeria"                                      : @"+213",
                              @"American Samoa"                               : @"+1 684",
                              @"Andorra"                                      : @"+376",
                              @"Angola"                                       : @"+244",
                              @"Anguilla"                                     : @"+1 264",
                              @"Antigua and Barbuda"                          : @"+1 268",
                              @"Argentina"                                    : @"+54",
                              @"Armenia"                                      : @"+374",
                              @"Aruba"                                        : @"+297",
                              @"Ascension"                                    : @"+247",
                              @"Australia"                                    : @"+61",
                              @"Australian External Territories"              : @"+672",
                              @"Austria"                                      : @"+43",
                              @"Azerbaijan"                                   : @"+994",
                              @"Bahamas"                                      : @"+1 242",
                              @"Bahrain"                                      : @"+973",
                              @"Bangladesh"                                   : @"+880",
                              @"Barbados"                                     : @"+1 246",
                              @"Barbuda"                                      : @"+1 268",
                              @"Belarus"                                      : @"+375",
                              @"Belgium"                                      : @"+32",
                              @"Belize"                                       : @"+501",
                              @"Benin"                                        : @"+229",
                              @"Bermuda"                                      : @"+1 441",
                              @"Bhutan"                                       : @"+975",
                              @"Bolivia"                                      : @"+591",
                              @"Bosnia and Herzegovina"                       : @"+387",
                              @"Botswana"                                     : @"+267",
                              @"Brazil"                                       : @"+55",
                              @"British Indian Ocean Territory"               : @"+246",
                              @"British Virgin Islands"                       : @"+1 284",
                              @"Brunei"                                       : @"+673",
                              @"Bulgaria"                                     : @"+359",
                              @"Burkina Faso"                                 : @"+226",
                              @"Burundi"                                      : @"+257",
                              @"Cambodia"                                     : @"+855",
                              @"Cameroon"                                     : @"+237",
                              @"Canada"                                       : @"+1",
                              @"Cape Verde"                                   : @"+238",
                              @"Cayman Islands"                               : @"+ 345",
                              @"Central African Republic"                     : @"+236",
                              @"Chad"                                         : @"+235",
                              @"Chile"                                        : @"+56",
                              @"China"                                        : @"+86",
                              @"Christmas Island"                             : @"+61",
                              @"Cocos-Keeling Islands"                        : @"+61",
                              @"Colombia"                                     : @"+57",
                              @"Comoros"                                      : @"+269",
                              @"Congo"                                        : @"+242",
                              @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                              @"Cook Islands"                                 : @"+682",
                              @"Costa Rica"                                   : @"+506",
                              @"Ivory Coast"                                  : @"+225",
                              @"Croatia"                                      : @"+385",
                              @"Cuba"                                         : @"+53",
                              @"Curacao"                                      : @"+599",
                              @"Cyprus"                                       : @"+537",
                              @"Czech Republic"                               : @"+420",
                              @"Denmark"                                      : @"+45",
                              @"Diego Garcia"                                 : @"+246",
                              @"Djibouti"                                     : @"+253",
                              @"Dominica"                                     : @"+1 767",
                              @"Dominican Republic"                           : @"+1 809",
                              @"Dominican Republic"                           : @"+1 829",
                              @"Dominican Republic"                           : @"+1 849",
                              @"East Timor"                                   : @"+670",
                              @"Easter Island"                                : @"+56",
                              @"Ecuador"                                      : @"+593",
                              @"Egypt"                                        : @"+20",
                              @"El Salvador"                                  : @"+503",
                              @"Equatorial Guinea"                            : @"+240",
                              @"Eritrea"                                      : @"+291",
                              @"Estonia"                                      : @"+372",
                              @"Ethiopia"                                     : @"+251",
                              @"Falkland Islands"                             : @"+500",
                              @"Faroe Islands"                                : @"+298",
                              @"Fiji"                                         : @"+679",
                              @"Finland"                                      : @"+358",
                              @"France"                                       : @"+33",
                              @"French Antilles"                              : @"+596",
                              @"French Guiana"                                : @"+594",
                              @"French Polynesia"                             : @"+689",
                              @"Gabon"                                        : @"+241",
                              @"Gambia"                                       : @"+220",
                              @"Georgia"                                      : @"+995",
                              @"Germany"                                      : @"+49",
                              @"Ghana"                                        : @"+233",
                              @"Gibraltar"                                    : @"+350",
                              @"Greece"                                       : @"+30",
                              @"Greenland"                                    : @"+299",
                              @"Grenada"                                      : @"+1 473",
                              @"Guadeloupe"                                   : @"+590",
                              @"Guam"                                         : @"+1 671",
                              @"Guatemala"                                    : @"+502",
                              @"Guinea"                                       : @"+224",
                              @"Guinea-Bissau"                                : @"+245",
                              @"Guyana"                                       : @"+595",
                              @"Haiti"                                        : @"+509",
                              @"Honduras"                                     : @"+504",
                              @"Hong Kong SAR China"                          : @"+852",
                              @"Hungary"                                      : @"+36",
                              @"Iceland"                                      : @"+354",
                              @"India"                                        : @"+91",
                              @"Indonesia"                                    : @"+62",
                              @"Iran"                                         : @"+98",
                              @"Iraq"                                         : @"+964",
                              @"Ireland"                                      : @"+353",
                              @"Israel"                                       : @"+972",
                              @"Italy"                                        : @"+39",
                              @"Jamaica"                                      : @"+1 876",
                              @"Japan"                                        : @"+81",
                              @"Jordan"                                       : @"+962",
                              @"Kazakhstan"                                   : @"+7 7",
                              @"Kenya"                                        : @"+254",
                              @"Kiribati"                                     : @"+686",
                              @"North Korea"                                  : @"+850",
                              @"South Korea"                                  : @"+82",
                              @"Kuwait"                                       : @"+965",
                              @"Kyrgyzstan"                                   : @"+996",
                              @"Laos"                                         : @"+856",
                              @"Latvia"                                       : @"+371",
                              @"Lebanon"                                      : @"+961",
                              @"Lesotho"                                      : @"+266",
                              @"Liberia"                                      : @"+231",
                              @"Libya"                                        : @"+218",
                              @"Liechtenstein"                                : @"+423",
                              @"Lithuania"                                    : @"+370",
                              @"Luxembourg"                                   : @"+352",
                              @"Macau SAR China"                              : @"+853",
                              @"Macedonia"                                    : @"+389",
                              @"Madagascar"                                   : @"+261",
                              @"Malawi"                                       : @"+265",
                              @"Malaysia"                                     : @"+60",
                              @"Maldives"                                     : @"+960",
                              @"Mali"                                         : @"+223",
                              @"Malta"                                        : @"+356",
                              @"Marshall Islands"                             : @"+692",
                              @"Martinique"                                   : @"+596",
                              @"Mauritania"                                   : @"+222",
                              @"Mauritius"                                    : @"+230",
                              @"Mayotte"                                      : @"+262",
                              @"Mexico"                                       : @"+52",
                              @"Micronesia"                                   : @"+691",
                              @"Midway Island"                                : @"+1 808",
                              @"Micronesia"                                   : @"+691",
                              @"Moldova"                                      : @"+373",
                              @"Monaco"                                       : @"+377",
                              @"Mongolia"                                     : @"+976",
                              @"Montenegro"                                   : @"+382",
                              @"Montserrat"                                   : @"+1664",
                              @"Morocco"                                      : @"+212",
                              @"Myanmar"                                      : @"+95",
                              @"Namibia"                                      : @"+264",
                              @"Nauru"                                        : @"+674",
                              @"Nepal"                                        : @"+977",
                              @"Netherlands"                                  : @"+31",
                              @"Netherlands Antilles"                         : @"+599",
                              @"Nevis"                                        : @"+1 869",
                              @"New Caledonia"                                : @"+687",
                              @"New Zealand"                                  : @"+64",
                              @"Nicaragua"                                    : @"+505",
                              @"Niger"                                        : @"+227",
                              @"Nigeria"                                      : @"+234",
                              @"Niue"                                         : @"+683",
                              @"Norfolk Island"                               : @"+672",
                              @"Northern Mariana Islands"                     : @"+1 670",
                              @"Norway"                                       : @"+47",
                              @"Oman"                                         : @"+968",
                              @"Pakistan"                                     : @"+92",
                              @"Palau"                                        : @"+680",
                              @"Palestinian Territory"                        : @"+970",
                              @"Panama"                                       : @"+507",
                              @"Papua New Guinea"                             : @"+675",
                              @"Paraguay"                                     : @"+595",
                              @"Peru"                                         : @"+51",
                              @"Philippines"                                  : @"+63",
                              @"Poland"                                       : @"+48",
                              @"Portugal"                                     : @"+351",
                              @"Puerto Rico"                                  : @"+1 787",
                              @"Puerto Rico"                                  : @"+1 939",
                              @"Qatar"                                        : @"+974",
                              @"Reunion"                                      : @"+262",
                              @"Romania"                                      : @"+40",
                              @"Russia"                                       : @"+7",
                              @"Rwanda"                                       : @"+250",
                              @"Samoa"                                        : @"+685",
                              @"San Marino"                                   : @"+378",
                              @"Saudi Arabia"                                 : @"+966",
                              @"Senegal"                                      : @"+221",
                              @"Serbia"                                       : @"+381",
                              @"Seychelles"                                   : @"+248",
                              @"Sierra Leone"                                 : @"+232",
                              @"Singapore"                                    : @"+65",
                              @"Slovakia"                                     : @"+421",
                              @"Slovenia"                                     : @"+386",
                              @"Solomon Islands"                              : @"+677",
                              @"South Africa"                                 : @"+27",
                              @"South Georgia and the South Sandwich Islands" : @"+500",
                              @"Spain"                                        : @"+34",
                              @"Sri Lanka"                                    : @"+94",
                              @"Sudan"                                        : @"+249",
                              @"Suriname"                                     : @"+597",
                              @"Swaziland"                                    : @"+268",
                              @"Sweden"                                       : @"+46",
                              @"Switzerland"                                  : @"+41",
                              @"Syria"                                        : @"+963",
                              @"Taiwan"                                       : @"+886",
                              @"Tajikistan"                                   : @"+992",
                              @"Tanzania"                                     : @"+255",
                              @"Thailand"                                     : @"+66",
                              @"Timor Leste"                                  : @"+670",
                              @"Togo"                                         : @"+228",
                              @"Tokelau"                                      : @"+690",
                              @"Tonga"                                        : @"+676",
                              @"Trinidad and Tobago"                          : @"+1 868",
                              @"Tunisia"                                      : @"+216",
                              @"Turkey"                                       : @"+90",
                              @"Turkmenistan"                                 : @"+993",
                              @"Turks and Caicos Islands"                     : @"+1 649",
                              @"Tuvalu"                                       : @"+688",
                              @"Uganda"                                       : @"+256",
                              @"Ukraine"                                      : @"+380",
                              @"United Arab Emirates"                         : @"+971",
                              @"United Kingdom"                               : @"+44",
                              @"United States"                                : @"+1",
                              @"Uruguay"                                      : @"+598",
                              @"U.S. Virgin Islands"                          : @"+1 340",
                              @"Uzbekistan"                                   : @"+998",
                              @"Vanuatu"                                      : @"+678",
                              @"Venezuela"                                    : @"+58",
                              @"Vietnam"                                      : @"+84",
                              @"Wake Island"                                  : @"+1 808",
                              @"Wallis and Futuna"                            : @"+681",
                              @"Yemen"                                        : @"+967",
                              @"Zambia"                                       : @"+260",
                              @"Zanzibar"                                     : @"+255",
                              @"Zimbabwe"                                     : @"+263"
                              };
        
    }
    
    return _countryName_CallingCode;
    
}

- (NSDictionary *)mcc_CallingCode{
    
    if (!_mcc_CallingCode) {
        
        _mcc_CallingCode = @{
                                     @"302" : @"+1",
                                     @"460" : @"+86",
                                     @"208" : @"+33",
                                     @"262" : @"+49",
                                     @"404" : @"+91",
                                     @"440" : @"+81",
                                     @"410" : @"+92",
                                     @"234" : @"+44",
                                     @"310" : @"+1",
                                     @"311" : @"+1",
                                     @"312" : @"+1",
                                     @"289" : @"+7 840",
                                     @"289" : @"+7 940",
                                     @"412" : @"+93",
                                     @"276" : @"+355",
                                     @"603" : @"+213",
                                     @"544" : @"+1 684",
                                     @"549" : @"+1 684",
                                     @"213" : @"+376",
                                     @"631" : @"+244",
                                     @"365" : @"+1 264",
                                     @"344" : @"+1 268",
                                     @"722" : @"+54",
                                     @"283" : @"+374",
                                     @"363" : @"+297",
                                     @"505" : @"+61",
                                     @"232" : @"+43",
                                     @"400" : @"+994",
                                     @"364" : @"+1 242",
                                     @"426" : @"+973",
                                     @"470" : @"+880",
                                     @"342" : @"+1 246",
                                     @"344" : @"+1 268",
                                     @"257" : @"+375",
                                     @"206" : @"+32",
                                     @"702" : @"+501",
                                     @"616" : @"+229",
                                     @"350" : @"+1 441",
                                     @"402" : @"+975",
                                     @"736" : @"+591",
                                     @"218" : @"+387",
                                     @"652" : @"+267",
                                     @"724" : @"+55",
                                     @"348" : @"+1 284",
                                     @"528" : @"+673",
                                     @"284" : @"+359",
                                     @"613" : @"+226",
                                     @"642" : @"+257",
                                     @"456" : @"+855",
                                     @"624" : @"+237",
                                     @"302" : @"+1",
                                     @"625" : @"+238",
                                     @"346" : @"+ 345",
                                     @"623" : @"+236",
                                     @"622" : @"+235",
                                     @"730" : @"+56",
                                     @"460" : @"+86",
                                     @"732" : @"+57",
                                     @"654" : @"+269",
                                     @"629" : @"+242",
                                     @"630" : @"+243",
                                     @"548" : @"+682",
                                     @"712" : @"+506",
                                     @"612" : @"+225",
                                     @"219" : @"+385",
                                     @"368" : @"+53",
                                     @"362" : @"+599",
                                     @"280" : @"+537",
                                     @"230" : @"+420",
                                     @"238" : @"+45",
                                     @"638" : @"+253",
                                     @"366" : @"+1 767",
                                     @"370" : @"+1 809",
                                     @"370" : @"+1 829",
                                     @"370" : @"+1 849",
                                     @"514" : @"+670",
                                     @"740" : @"+593",
                                     @"602" : @"+20",
                                     @"706" : @"+503",
                                     @"627" : @"+240",
                                     @"657" : @"+291",
                                     @"248" : @"+372",
                                     @"636" : @"+251",
                                     @"750" : @"+500",
                                     @"288" : @"+298",
                                     @"542" : @"+679",
                                     @"244" : @"+358",
                                     @"208" : @"+33",
                                     @"340" : @"+594",
                                     @"547" : @"+689",
                                     @"628" : @"+241",
                                     @"607" : @"+220",
                                     @"282" : @"+995",
                                     @"262" : @"+49",
                                     @"620" : @"+233",
                                     @"266" : @"+350",
                                     @"202" : @"+30",
                                     @"290" : @"+299",
                                     @"352" : @"+1 473",
                                     @"340" : @"+590",
                                     @"310" : @"+1 671",
                                     @"704" : @"+502",
                                     @"611" : @"+224",
                                     @"632" : @"+245",
                                     @"744" : @"+595",
                                     @"372" : @"+509",
                                     @"708" : @"+504",
                                     @"454" : @"+852",
                                     @"216" : @"+36",
                                     @"274" : @"+354",
                                     @"404" : @"+91",
                                     @"510" : @"+62",
                                     @"432" : @"+98",
                                     @"418" : @"+964",
                                     @"272" : @"+353",
                                     @"425" : @"+972",
                                     @"222" : @"+39",
                                     @"338" : @"+1 876",
                                     @"440" : @"+81",
                                     @"416" : @"+962",
                                     @"401" : @"+7 7",
                                     @"639" : @"+254",
                                     @"545" : @"+686",
                                     @"467" : @"+850",
                                     @"450" : @"+82",
                                     @"419" : @"+965",
                                     @"437" : @"+996",
                                     @"457" : @"+856",
                                     @"247" : @"+371",
                                     @"415" : @"+961",
                                     @"651" : @"+266",
                                     @"618" : @"+231",
                                     @"606" : @"+218",
                                     @"295" : @"+423",
                                     @"246" : @"+370",
                                     @"270" : @"+352",
                                     @"455" : @"+853",
                                     @"294" : @"+389",
                                     @"646" : @"+261",
                                     @"650" : @"+265",
                                     @"502" : @"+60",
                                     @"472" : @"+960",
                                     @"610" : @"+223",
                                     @"278" : @"+356",
                                     @"609" : @"+222",
                                     @"617" : @"+230",
                                     @"647" : @"+262",
                                     @"334" : @"+52",
                                     @"550" : @"+691",
                                     @"550" : @"+691",
                                     @"259" : @"+373",
                                     @"212" : @"+377",
                                     @"428" : @"+976",
                                     @"297" : @"+382",
                                     @"354" : @"+1664",
                                     @"604" : @"+212",
                                     @"414" : @"+95",
                                     @"649" : @"+264",
                                     @"429" : @"+977",
                                     @"204" : @"+31",
                                     @"362" : @"+599",
                                     @"356" : @"+1 869",
                                     @"546" : @"+687",
                                     @"530" : @"+64",
                                     @"710" : @"+505",
                                     @"614" : @"+227",
                                     @"621" : @"+234",
                                     @"672" : @"+1 670",
                                     @"242" : @"+47",
                                     @"422" : @"+968",
                                     @"410" : @"+92",
                                     @"425" : @"+970",
                                     @"714" : @"+507",
                                     @"537" : @"+675",
                                     @"744" : @"+595",
                                     @"716" : @"+51",
                                     @"515" : @"+63",
                                     @"260" : @"+48",
                                     @"268" : @"+351",
                                     @"427" : @"+974",
                                     @"647" : @"+262",
                                     @"250" : @"+7",
                                     @"635" : @"+250",
                                     @"549" : @"+685",
                                     @"292" : @"+378",
                                     @"420" : @"+966",
                                     @"608" : @"+221",
                                     @"220" : @"+381",
                                     @"633" : @"+248",
                                     @"619" : @"+232",
                                     @"525" : @"+65",
                                     @"231" : @"+421",
                                     @"293" : @"+386",
                                     @"540" : @"+677",
                                     @"655" : @"+27",
                                     @"214" : @"+34",
                                     @"413" : @"+94",
                                     @"634" : @"+249",
                                     @"746" : @"+597",
                                     @"653" : @"+268",
                                     @"240" : @"+46",
                                     @"228" : @"+41",
                                     @"417" : @"+963",
                                     @"466" : @"+886",
                                     @"436" : @"+992",
                                     @"640" : @"+255",
                                     @"520" : @"+66",
                                     @"514" : @"+670",
                                     @"615" : @"+228",
                                     @"539" : @"+676",
                                     @"374" : @"+1 868",
                                     @"605" : @"+216",
                                     @"286" : @"+90",
                                     @"438" : @"+993",
                                     @"649" : @"+1 649",
                                     @"641" : @"+256",
                                     @"255" : @"+380",
                                     @"424" : @"+971",
                                     @"234" : @"+44",
                                     @"311" : @"+1",
                                     @"748" : @"+598",
                                     @"376" : @"+1 340",
                                     @"434" : @"+998",
                                     @"541" : @"+678",
                                     @"734" : @"+58",
                                     @"452" : @"+84",
                                     @"421" : @"+967",
                                     @"645" : @"+260",
                                     @"640" : @"+255",
                                     @"648" : @"+263"
                                     };
        
    }
    
    return _mcc_CallingCode;
}



@end
