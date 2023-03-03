//
//  MagazineQuery.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/18.
//

import Foundation

enum MagazineQuery {
    
    // MARK: - 매거진 DB에 데이터 저장 메소드
    static func insertMagazineQuery(data: MagazineFields, images: [String], docID: String) -> Data? {
        var str : String = ""
        
        for i in 0..<images.count {
            str += """
                 { "stringValue": "\(images[i])" },
                """
        }

        str.removeLast()

        return
                """
                {
                    "fields": {
                        "lenseInfo": {
                            "stringValue": "\(data.lenseInfo.stringValue)"
                        },
                        "image": {
                            "arrayValue": {
                                "values": [
                                        \(str)
                                ]
                            }
                        },
                        "comment": {
                            "arrayValue": {
                                "values": [
                                    {
                                        "stringValue": "default"
                                    }
                                ]
                            }
                        },
                        "id": {
                            "stringValue": "\(docID)"
                        },
                        "likedNum": {
                          "integerValue": \(data.likedNum.integerValue)
                        },
                        "title": {
                          "stringValue": "\(data.title.stringValue)"
                        },
                        "filmInfo": {
                          "stringValue": "\(data.filmInfo.stringValue)"
                        },
                        "cameraInfo": {
                          "stringValue": "\(data.cameraInfo.stringValue)"
                        },
                        "customPlaceName": {
                          "stringValue": "\(data.customPlaceName.stringValue)"
                        },
                        "content": {
                          "stringValue": "\(data.content.stringValue)"
                        },
                        "latitude": {
                          "doubleValue": \(data.latitude.doubleValue!)
                        },
                        "longitude": {
                          "doubleValue": \(data.longitude.doubleValue!)
                        },
                        "nickName": {
                          "stringValue": "\(data.nickName.stringValue)"
                        },
                        "roadAddress": {
                          "stringValue": "\(data.roadAddress.stringValue)"
                        },
                        "userID": {
                          "stringValue": "\(data.userID.stringValue)"
                        }
                
                    }
                }
                """.data(using: .utf8)
    }
    
    //MARK: - 매거진 DB에 update 쿼리 리턴 메소드
    static func updateMagazineQuery(data: MagazineDocument, docID: String) -> Data? {
        var str : String = ""
        
        for i in 0..<data.fields.image.arrayValue.values.count {
            str += """
                 { "stringValue": "\(data.fields.image.arrayValue.values[i].stringValue)" },
                """
        }
        
        str.removeLast()

        return
        """
        {
            "fields": {
                "lenseInfo": {
                    "stringValue": "\(data.fields.lenseInfo.stringValue)"
                },
                "image": {
                    "arrayValue": {
                        "values": [
                                \(str)
                        ]
                    }
                },
                "id": {
                    "stringValue": "\(docID)"
                },
                "likedNum": {
                  "integerValue": \(data.fields.likedNum.integerValue)
                },
                "title": {
                  "stringValue": "\(data.fields.title.stringValue)"
                },
                "filmInfo": {
                  "stringValue": "\(data.fields.filmInfo.stringValue)"
                },
                "cameraInfo": {
                  "stringValue": "\(data.fields.cameraInfo.stringValue)"
                },
                "customPlaceName": {
                  "stringValue": "\(data.fields.customPlaceName.stringValue)"
                },
                "content": {
                  "stringValue": "\(data.fields.content.stringValue)"
                },
                "latitude": {
                  "doubleValue": \(data.fields.latitude.doubleValue)
                },
                "longitude": {
                  "doubleValue": \(data.fields.longitude.doubleValue)
                },
                "nickName": {
                  "stringValue": "\(data.fields.nickName.stringValue)"
                },
                "roadAddress": {
                  "stringValue": "\(data.fields.roadAddress.stringValue)"
                },
                "userID": {
                  "stringValue": "\(data.fields.userID.stringValue)"
                }
        
            }
        }
        """.data(using: .utf8)
    }
    
    //MARK: - 매거진 DB에 매거진의 좋아요 수 update 쿼리 리턴 메소드
    static func updateLikedNumQuery(num: String) -> Data?
    {
        let query = """
                    {
                      "fields": {
                           "likedNum": {
                                "stringValue": "\(num)"
                    }
                }
            }
            """.data(using: .utf8)
        
        return query
    }
    
}
